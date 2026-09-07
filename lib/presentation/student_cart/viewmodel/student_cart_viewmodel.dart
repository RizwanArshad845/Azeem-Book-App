import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../../../domain/student_cart/usecases/add_subject_bundle_usecase.dart';
import '../../../domain/student_cart/usecases/checkout_usecase.dart';
import '../../../domain/student_cart/usecases/get_cart_usecase.dart';
import '../../../domain/student_cart/usecases/get_purchased_subject_ids_usecase.dart';
import '../../../domain/student_cart/usecases/price_for_subject_bundle.dart';
import '../../../domain/student_cart/usecases/remove_from_cart_usecase.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';
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

    final result = await sl<GetCartUseCase>()(session.userId!);
    final cart = result.when(
      success: (cart) => cart,
      failure: (failure) => throw failure,
    );
    return _enrichCart(cart);
  }

  /// Resolves any missing [CartItem.subjectName] or [CartItem.testCount] from
  /// the catalog providers so presentation screens display the human-readable
  /// subject name instead of the raw backend identifier.
  Future<Cart> _enrichCart(Cart cart) async {
    final items = cart.items;
    if (items == null || items.isEmpty) return cart;

    final needsEnrichment = items.any(
      (i) =>
          i.subjectName == null ||
          i.subjectName!.isEmpty ||
          i.testCount == null,
    );
    if (!needsEnrichment) return cart;

    final enriched = await Future.wait(
      items.map((item) async {
        var subjectName = item.subjectName;
        var testCount = item.testCount;

        if (subjectName == null || subjectName.isEmpty) {
          try {
            final subject =
                await ref.read(subjectByIdProvider(item.subjectId).future);
            if (subject != null) {
              subjectName = subject.name;
            }
          } catch (_) {}
        }

        if (testCount == null) {
          try {
            final tests =
                await ref.read(testsForSubjectProvider(item.subjectId).future);
            testCount = tests.length;
          } catch (_) {}
        }

        return item.copyWith(
          subjectName: subjectName ?? item.subjectName,
          testCount: testCount ?? item.testCount,
        );
      }),
    );

    return cart.copyWith(items: enriched);
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

    // Deliberately does NOT set `state = AsyncLoading()` here — the current
    // cart stays visible on screen for the whole round trip instead of
    // blanking to a skeleton (that blank-out, not real network latency, was
    // what read as "delay"). `cartMutationInProgressProvider` drives the
    // small in-place spinner/disabled-button affordance instead.
    ref.read(cartMutationInProgressProvider.notifier).set(true);
    try {
      final result = await sl<AddSubjectBundleUseCase>()(
        session.userId!,
        subject,
        tests,
        subjectEnrollments: subjectEnrollments,
      );
      state = await result.when(
        success: (cart) async => AsyncData<Cart>(await _enrichCart(cart)),
        failure: (failure) async =>
            AsyncError<Cart>(failure, StackTrace.current),
      );
    } finally {
      ref.read(cartMutationInProgressProvider.notifier).set(false);
    }
  }

  /// Convenience method to resolve subject and tests by [subjectId] and add
  /// the bundle to cart.
  Future<void> addSubjectBundleById(String subjectId) async {
    final tests = await ref.read(testsForSubjectProvider(subjectId).future);
    var subject = await ref.read(subjectByIdProvider(subjectId).future);
    if (subject == null) {
      final subjects = await ref.read(enrolledSubjectsProvider.future);
      for (final s in subjects) {
        if (s.id == subjectId) {
          subject = s;
          break;
        }
      }
    }
    subject ??= Subject(
      id: subjectId,
      boardClassId: '',
      name: 'Subject',
    );
    await addSubjectBundle(subject, tests);
  }

  Future<void> removeSubject(String subjectId) async {
    final session = ref.read(currentUserProvider);
    if (session == null) return;

    // See `addSubjectBundle`'s comment above — same reason for not touching
    // `state` up front.
    ref.read(cartMutationInProgressProvider.notifier).set(true);
    try {
      final result =
          await sl<RemoveFromCartUseCase>()(session.userId!, subjectId);
      state = await result.when(
        success: (cart) async => AsyncData<Cart>(await _enrichCart(cart)),
        failure: (failure) async =>
            AsyncError<Cart>(failure, StackTrace.current),
      );
    } finally {
      ref.read(cartMutationInProgressProvider.notifier).set(false);
    }
  }

  /// Checks out the current cart, returning the resulting [Payment] (or
  /// `null` on failure). Deliberately does not navigate itself — mirrors
  /// the auth/onboarding "let the caller/router handle navigation"
  /// convention; `CheckoutView` calls this and renders the result itself.
  ///
  /// Teacher-commission attribution happens server-side automatically on a
  /// successful checkout — see `CheckoutUseCase` doc comment — so this only
  /// needs the student id.
  Future<Payment?> checkout() async {
    final session = ref.read(currentUserProvider);
    if (session == null) return null;

    final currentCart = state.value;
    final expectedTotal = currentCart?.totalAmount;

    final result = await sl<CheckoutUseCase>()(session.userId!);

    // NOTE: Do NOT use result.when() with an async callback here.
    // Result.when() is synchronous — passing an async lambda makes it return
    // Future<Payment?> immediately without awaiting the body, so all the
    // invalidations below would fire in an unawaited future and the backend
    // state would never actually update before the checkout screen renders.
    if (result is ResultFailure<Payment>) return null;

    final payment = (result as Success<Payment>).data;

    // Clear cart and invalidate self so the next read re-fetches from network.
    ref.invalidateSelf();
    // Eagerly re-fetch purchasedSubjectIds so isOwned becomes true immediately.
    ref.invalidate(purchasedSubjectIdsProvider);
    try {
      // ignore: unused_result — we are awaiting the returned Future directly.
      await ref.refresh(purchasedSubjectIdsProvider.future);
    } catch (_) {}
    // Refresh the student's profile (subjectEnrollments, etc.)
    try {
      await ref
          .read(studentOnboardingViewModelProvider.notifier)
          .refreshStudent();
    } catch (_) {}

    if (expectedTotal != null &&
        expectedTotal > 0 &&
        (payment.amount - expectedTotal).abs() > 0.01) {
      return payment.copyWith(amount: expectedTotal);
    }
    return payment;
  }
}

final studentCartViewModelProvider =
    AsyncNotifierProvider<StudentCartViewModel, Cart>(StudentCartViewModel.new);

/// True while `addSubjectBundle`/`removeSubject` is in flight — drives the
/// "Buy Now" button's spinner and the cart list's disabled remove icons.
/// Deliberately separate from `studentCartViewModelProvider`'s own
/// `AsyncValue` so those mutations never have to touch `state = AsyncLoading`
/// (which would blank the currently-displayed cart) just to signal this.
class CartMutationInProgressNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final cartMutationInProgressProvider =
    NotifierProvider<CartMutationInProgressNotifier, bool>(
  CartMutationInProgressNotifier.new,
);

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

  final result = await sl<GetPurchasedSubjectIdsUseCase>()(session.userId!);
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

/// Wraps `priceForSubjectBundle` behind a provider so presentation widgets
/// (`SubjectCard`, `ChapterListView`) don't import the domain usecase
/// directly (audit C1) — keyed by `subjectId`, null while tests are still
/// loading or the subject has no tests yet.
final subjectBundlePriceProvider = Provider.family<double?, String>((
  ref,
  subjectId,
) {
  final tests = ref.watch(testsForSubjectProvider(subjectId)).value;
  return (tests != null && tests.isNotEmpty)
      ? priceForSubjectBundle(tests)
      : null;
});
