import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/cart_item.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../../../domain/student_cart/usecases/add_subject_bundle_usecase.dart';
import '../../../domain/student_cart/usecases/checkout_usecase.dart';
import '../../../domain/student_cart/usecases/get_cart_usecase.dart';
import '../../../domain/student_cart/usecases/get_purchased_subject_ids_usecase.dart';
import '../../../domain/student_cart/usecases/remove_from_cart_usecase.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';

/// Student Cart tab (§10.2 "Add-to-cart summary, checkout -> payment
/// gateway redirect"). `build()` loads the current student's cart;
/// `addSubjectBundle`/`removeSubject` mutate it; `checkout` is a one-off
/// action that returns the resulting `Payment` without touching this
/// notifier's own `AsyncValue<Cart>` state directly on success — it
/// invalidates itself so the next read re-fetches the now-cleared cart from
/// the repository.
///
/// Note: this project's `pubspec.yaml` does not include `riverpod_generator`
/// / `riverpod_annotation` (only `flutter_riverpod`), so — consistent with
/// `AuthViewModel`/`NotificationsViewModel` — this is a hand-written
/// `AsyncNotifier` with a manually declared provider rather than `@riverpod`
/// codegen. Also note: this codebase's Riverpod 3.x has no
/// `AsyncValue.valueOrNull` — `.value` is used directly throughout.
class StudentCartViewModel extends AsyncNotifier<Cart> {
  @override
  Future<Cart> build() async {
    final session = ref.watch(currentUserProvider);
    if (session == null) {
      // Edge case only — router redirect guarantees a resolved session
      // before the student shell is reachable (mirrors
      // NotificationsViewModel.build()).
      return const Cart(id: '', studentId: '', items: null, totalAmount: 0);
    }

    final result = await sl<GetCartUseCase>()(session.userId);
    return result.when(
      success: (cart) => cart,
      failure: (failure) => throw failure,
    );
  }

  /// Adds a whole [subject] bundle (all of [tests]) to the cart, reading the
  /// current student's `subjectEnrollments` off
  /// `studentOnboardingViewModelProvider`'s resolved `Student` to apply the
  /// teacher-discount rule.
  Future<void> addSubjectBundle(Subject subject, List<Test> tests) async {
    final session = ref.read(currentUserProvider);
    if (session == null) return;

    final student = ref.read(studentOnboardingViewModelProvider).value;
    final subjectEnrollments =
        student?.subjectEnrollments ?? const <SubjectEnrollment>[];

    state = const AsyncLoading<Cart>();
    final result = await sl<AddSubjectBundleUseCase>()(
      session.userId,
      subject,
      tests,
      subjectEnrollments: subjectEnrollments,
    );
    state = result.when(
      success: (cart) => AsyncData<Cart>(cart),
      failure: (failure) => AsyncError<Cart>(failure, StackTrace.current),
    );
  }

  Future<void> removeSubject(String subjectId) async {
    final session = ref.read(currentUserProvider);
    if (session == null) return;

    state = const AsyncLoading<Cart>();
    final result = await sl<RemoveFromCartUseCase>()(session.userId, subjectId);
    state = result.when(
      success: (cart) => AsyncData<Cart>(cart),
      failure: (failure) => AsyncError<Cart>(failure, StackTrace.current),
    );
  }

  /// Checks out the current cart, returning the resulting [Payment] (or
  /// `null` on failure). Deliberately does not navigate itself — mirrors
  /// the auth/onboarding "let the caller/router handle navigation"
  /// convention; `CheckoutView` calls this and renders the result itself.
  ///
  /// Reads this notifier's own already-resolved `Cart` items plus
  /// `studentOnboardingViewModelProvider` (same source `addSubjectBundle`
  /// already uses) and passes them into `CheckoutUseCase` so it can
  /// attribute a teacher commission per purchased item without needing its
  /// own catalog/student-repository dependency — see `CheckoutUseCase` doc
  /// comment. `CartItem.subjectId` is now direct, so no `testsById` lookup
  /// is needed.
  Future<Payment?> checkout() async {
    final session = ref.read(currentUserProvider);
    if (session == null) return null;

    final cartItems = state.value?.items ?? const <CartItem>[];
    final student = ref.read(studentOnboardingViewModelProvider).value;
    final subjectEnrollments =
        student?.subjectEnrollments ?? const <SubjectEnrollment>[];

    final result = await sl<CheckoutUseCase>()(
      session.userId,
      cartItems: cartItems,
      subjectEnrollments: subjectEnrollments,
    );
    return result.when(
      success: (payment) {
        // Repository clears the cart's items on a successful payment;
        // invalidate so the next read of this provider (e.g. returning to
        // the Cart tab) re-fetches the now-empty cart instead of showing
        // stale items.
        ref.invalidateSelf();
        return payment;
      },
      failure: (_) => null,
    );
  }
}

final studentCartViewModelProvider =
    AsyncNotifierProvider<StudentCartViewModel, Cart>(StudentCartViewModel.new);

final checkoutPaymentProvider = FutureProvider<Payment?>((ref) async {
  return ref.read(studentCartViewModelProvider.notifier).checkout();
});

/// Every `subjectId` the current student has ever successfully purchased
/// (bundle-only purchasing — see `CartItem` doc comment). Drives the
/// "Purchased"/"Add to cart" toggle on `ChapterListView` and the
/// owned-state indicator on `SubjectCard`, and — separately — the
/// `test-taking` purchase gate via `GetPurchasedSubjectIdsUseCase` directly.
final purchasedSubjectIdsProvider = FutureProvider<Set<String>>((ref) async {
  final session = ref.watch(currentUserProvider);
  if (session == null) return const <String>{};

  final result = await sl<GetPurchasedSubjectIdsUseCase>()(session.userId);
  return result.when(
    success: (ids) => ids,
    failure: (failure) => throw failure,
  );
});

/// All tests for a single subject (`ChapterListView`'s bundle-purchase
/// header needs the full test list to compute bundle price/count), keyed by
/// `subjectId`. Mirrors the existing `subjectsForBoardClassProvider` family
/// shape (`student_onboarding_viewmodel.dart`).
final testsForSubjectProvider =
    FutureProvider.family<List<Test>, String>((ref, subjectId) async {
      final result = await ref.read(getTestsUseCaseProvider)(subjectId: subjectId);
      return result.when(
        success: (tests) => tests,
        failure: (failure) => throw failure,
      );
    });
