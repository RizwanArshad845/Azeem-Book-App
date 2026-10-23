import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/cart_item.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../../../domain/student_cart/usecases/add_subject_bundle_usecase.dart';
import '../../../domain/student_cart/usecases/checkout_usecase.dart';
import '../../../domain/student_cart/usecases/get_cart_usecase.dart';
import '../../../domain/student_cart/usecases/get_pending_subject_ids_usecase.dart';
import '../../../domain/student_cart/usecases/get_purchased_subject_ids_usecase.dart';
import '../../../domain/student_cart/usecases/remove_from_cart_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';

/// Student Cart tab (§10.2 "Add-to-cart summary, checkout -> payment
/// gateway redirect"). `build()` loads the current student's cart;
/// `addSubjectBundle`/`removeSubject` mutate it; `checkout` is a one-off
/// action that returns the resulting `Payment` and, on success, optimistically
/// sets this notifier's `AsyncValue<Cart>` state to an empty cart for a 0ms
/// UI update, then silently reconciles with the server's authoritative
/// post-checkout cart in the background (see `_reconcileCartAfterCheckout`).
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

  /// Adds a whole [subject] bundle (all of [tests]) to the cart. Pricing and
  /// any teacher-discount are fully server-computed.
  Future<void> addSubjectBundle(Subject subject, List<Test> tests) async {
    final session = ref.read(currentUserProvider);
    if (session == null) return;

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
      );
      // Already owned / payment still processing: the backend refused so it
      // can't be paid twice. Keep the cart as it is and re-sync purchase
      // status instead — the UI then shows the subject as owned/processing.
      final refused = result.when(
        success: (_) => false,
        failure: (f) =>
            f is SubjectPaymentPendingFailure ||
            f is SubjectAlreadyPurchasedFailure,
      );
      if (refused) {
        unawaited(
          ref.read(paymentConfirmationProvider.notifier).resumeIfPending(),
        );
        return;
      }
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
  ///
  /// Sets [cartMutationInProgressProvider] immediately so the UI disables
  /// "Buy Now" during the subject/test resolution phase (before the HTTP
  /// round-trip in [addSubjectBundle]) — prevents a double-tap race.
  Future<void> addSubjectBundleById(String subjectId) async {
    ref.read(cartMutationInProgressProvider.notifier).set(true);
    try {
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
        bundlePrice: 0,
      );
      await addSubjectBundle(subject, tests);
    } finally {
      // addSubjectBundle clears the flag itself, but guard here too so an
      // early-return exception never leaves the button permanently disabled.
      ref.read(cartMutationInProgressProvider.notifier).set(false);
    }
  }

  Future<void> removeSubject(String subjectId) async {
    final session = ref.read(currentUserProvider);
    if (session == null) return;

    // Optimistic removal for instant 0ms UI response
    final previousCart = state.value;
    if (previousCart != null && previousCart.items != null) {
      final updatedItems = previousCart.items!
          .where((i) => i.subjectId != subjectId)
          .toList();
      final updatedTotal = updatedItems.fold<double>(
        0,
        (sum, i) => sum + (i.discountedPrice ?? i.price),
      );
      state = AsyncData<Cart>(
        previousCart.copyWith(items: updatedItems, totalAmount: updatedTotal),
      );
    }

    ref.read(cartMutationInProgressProvider.notifier).set(true);
    try {
      final result =
          await sl<RemoveFromCartUseCase>()(session.userId!, subjectId);
      state = await result.when(
        success: (cart) async => AsyncData<Cart>(await _enrichCart(cart)),
        failure: (failure) async => previousCart != null
            ? AsyncData<Cart>(previousCart)
            : AsyncError<Cart>(failure, StackTrace.current),
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
    final currentItems = currentCart?.items ?? const <CartItem>[];
    final expectedTotal = currentCart?.totalAmount;
    final purchasedIds = currentItems.map((i) => i.subjectId).toSet();

    final result = await sl<CheckoutUseCase>()(session.userId!);

    return result.when(
      success: (payment) {
        // RapidGateway checkout: nothing is purchased until the backend's
        // webhook settles it, so don't unlock anything here — hand the
        // awaited subjects to the confirmation poller and let the cart
        // reflect the server's reserved state.
        if (payment.status == PaymentStatus.pending) {
          ref
              .read(paymentConfirmationProvider.notifier)
              .expect(purchasedIds);
          unawaited(_reconcileCartAfterCheckout(session.userId!));
          return payment;
        }
        if (payment.status == PaymentStatus.failed) return payment;

        // 1. Immediate optimistic UI update (0ms delay)
        final emptyCart = Cart(
          id: session.userId!,
          studentId: session.userId!,
          items: const [],
          totalAmount: 0,
        );
        state = AsyncData<Cart>(emptyCart);

        // 2. Mark subjects as owned immediately
        if (purchasedIds.isNotEmpty) {
          ref
              .read(purchasedSubjectIdsProvider.notifier)
              .addPurchasedIds(purchasedIds);
        }

        // 3. Silent background reconciliation & student profile refresh
        unawaited(_reconcileCartAfterCheckout(session.userId!));
        unawaited(
          ref
              .read(studentOnboardingViewModelProvider.notifier)
              .refreshStudent()
              .catchError((_) => null),
        );

        // 4. Preserve the float discrepancy check from teacher-test-fixes
        if (expectedTotal != null &&
            expectedTotal > 0 &&
            (payment.amount - expectedTotal).abs() > 0.01) {
          return payment.copyWith(amount: expectedTotal);
        }

        return payment;
      },
      failure: (_) => null,
    );
  }

  /// Re-fetches the cart from the server (e.g. after a gateway payment
  /// settles or fails and the backend has cleared or restored its items).
  Future<void> refreshCart() async {
    final session = ref.read(currentUserProvider);
    if (session?.userId == null) return;
    await _reconcileCartAfterCheckout(session!.userId!);
  }

  Future<void> _reconcileCartAfterCheckout(String studentId) async {
    final result = await sl<GetCartUseCase>()(studentId, forceRefresh: true);
    final cart = result.when(success: (cart) => cart, failure: (_) => null);
    if (cart == null) return;
    state = AsyncData<Cart>(await _enrichCart(cart));
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

// Deliberately NOT `.autoDispose`: an autoDispose provider re-runs `checkout()`
// (a real payment call, not idempotent) if its listener count ever
// transiently drops to zero — e.g. a route-transition rebuild — risking a
// duplicate charge. Freshness (a new `CheckoutView` must not replay a
// previous session's cached `Payment`) is instead handled explicitly by
// `CheckoutView.initState` invalidating this provider exactly once per
// screen mount, which is deterministic and independent of widget-tree
// churn.
final checkoutPaymentProvider = FutureProvider<Payment?>((ref) async {
  return ref.read(studentCartViewModelProvider.notifier).checkout();
});

/// Where a pending RapidGateway payment stands from the app's point of view.
/// Only the backend webhook can settle a payment, so "confirmed" means the
/// awaited subjects showed up in `GET /payments/status` — never the
/// `result=success` on the WebView's return URL.
enum PaymentConfirmation { idle, confirming, confirmed, unconfirmed, failed }

/// Tracks a pending RapidGateway payment until the backend settles it, from
/// `GET /payments/status` (`purchasedSubjectIds` + `pendingSubjectIds`).
///
/// Deliberately not tied to `CheckoutView`: the student may leave the
/// checkout screen (or the app) at any point while a payment is processing.
/// Polling carries on in the background, `PaymentWatcher` resumes it on app
/// start / return to the foreground, and the server-side pending set keeps
/// the subject un-buyable meanwhile — so leaving early never loses a payment
/// or lets the same subject be paid for twice.
class PaymentConfirmationViewModel extends Notifier<PaymentConfirmation> {
  static const _pollInterval = Duration(seconds: 3);
  static const _maxPolls = 40; // ~2 minutes, then `unconfirmed`

  Set<String> _awaitedSubjectIds = const {};

  /// Bumped on every [expect]/[confirm] so a superseded polling loop stops.
  int _generation = 0;

  @override
  PaymentConfirmation build() {
    // Logout / account switch: drop anything the previous session was
    // waiting on and stop its polling loop.
    ref.watch(currentUserProvider.select((s) => s?.userId));
    _generation++;
    _awaitedSubjectIds = const {};
    return PaymentConfirmation.idle;
  }

  /// Called when a checkout comes back pending, before the gateway opens.
  void expect(Set<String> subjectIds) {
    _generation++;
    _awaitedSubjectIds = subjectIds;
    ref.read(pendingSubjectIdsProvider.notifier).addAll(subjectIds);
    state = PaymentConfirmation.idle;
  }

  /// Re-syncs purchase status from the server and, if a payment is still
  /// pending there (e.g. the student left mid-payment or restarted the app),
  /// starts waiting on it again. No-op while already confirming.
  Future<void> resumeIfPending() async {
    if (state == PaymentConfirmation.confirming) return;
    final status = await _fetchStatus();
    if (!ref.mounted || status == null) return;
    if (status.pending.isEmpty) return;
    _awaitedSubjectIds = status.pending;
    await confirm();
  }

  /// Polls until every awaited subject is purchased (`confirmed`) or none of
  /// them is pending any more without having been purchased (`failed` — the
  /// backend gave up on the payment and returned the items to the cart).
  Future<void> confirm() async {
    final generation = ++_generation;
    state = PaymentConfirmation.confirming;

    for (var i = 0; i < _maxPolls; i++) {
      final status = await _fetchStatus();
      if (!ref.mounted || generation != _generation) return;

      if (status != null) {
        // Nothing known to wait on (e.g. a repeat checkout returned an
        // earlier payment): wait on whatever the server says is pending.
        if (_awaitedSubjectIds.isEmpty) _awaitedSubjectIds = status.pending;

        if (_awaitedSubjectIds.isNotEmpty &&
            status.purchased.containsAll(_awaitedSubjectIds)) {
          _onSettled();
          state = PaymentConfirmation.confirmed;
          return;
        }
        if (_awaitedSubjectIds.isEmpty ||
            !_awaitedSubjectIds.any(status.pending.contains)) {
          _onSettled();
          state = _awaitedSubjectIds.isEmpty
              ? PaymentConfirmation.idle
              : PaymentConfirmation.failed;
          return;
        }
      }

      await Future<void>.delayed(_pollInterval);
      if (!ref.mounted || generation != _generation) return;
    }
    state = PaymentConfirmation.unconfirmed;
  }

  /// One `/payments/status` round trip; pushes both sets into their
  /// providers so every screen reflects them. `null` if it couldn't load.
  Future<({Set<String> purchased, Set<String> pending})?> _fetchStatus() async {
    final studentId = ref.read(currentUserProvider)?.userId;
    if (studentId == null) return null;
    final purchased = (await sl<GetPurchasedSubjectIdsUseCase>()(
      studentId,
      forceRefresh: true,
    )).when(success: (ids) => ids, failure: (_) => null);
    // Same response as above, served from the repository cache.
    final pending = (await sl<GetPendingSubjectIdsUseCase>()(studentId))
        .when(success: (ids) => ids, failure: (_) => null);
    if (!ref.mounted || purchased == null || pending == null) return null;

    ref.read(purchasedSubjectIdsProvider.notifier).addPurchasedIds(purchased);
    ref.read(pendingSubjectIdsProvider.notifier).replace(pending);
    return (purchased: purchased, pending: pending);
  }

  /// The payment reached an outcome: the cart (cleared, or items returned
  /// on failure) and the student's paid enrollments both changed server-side.
  void _onSettled() {
    unawaited(ref.read(studentCartViewModelProvider.notifier).refreshCart());
    unawaited(
      ref
          .read(studentOnboardingViewModelProvider.notifier)
          .refreshStudent()
          .catchError((_) => null),
    );
  }
}

final paymentConfirmationProvider =
    NotifierProvider<PaymentConfirmationViewModel, PaymentConfirmation>(
  PaymentConfirmationViewModel.new,
);

/// Subjects tied up in a payment the backend hasn't confirmed yet — shown as
/// "payment processing" (never as buyable) on subject cards, the chapter
/// list and the cart. Kept current by `PaymentConfirmationViewModel`.
class PendingSubjectIdsViewModel extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final session = ref.watch(currentUserProvider);
    if (session == null || session.userId == null) return const <String>{};

    final result = await sl<GetPendingSubjectIdsUseCase>()(session.userId!);
    return result.when(
      success: (ids) => ids,
      failure: (failure) => throw failure,
    );
  }

  void addAll(Iterable<String> ids) {
    final current = state.value ?? const <String>{};
    state = AsyncData<Set<String>>({...current, ...ids});
  }

  void replace(Set<String> ids) => state = AsyncData<Set<String>>(ids);
}

final pendingSubjectIdsProvider =
    AsyncNotifierProvider<PendingSubjectIdsViewModel, Set<String>>(
  PendingSubjectIdsViewModel.new,
);

/// Every `subjectId` the current student has ever successfully purchased
/// (bundle-only purchasing — see `CartItem` doc comment). Drives the
/// "Purchased"/"Add to cart" toggle on `ChapterListView` and the
/// owned-state indicator on `SubjectCard`, and — separately — the
/// `test-taking` purchase gate via `GetPurchasedSubjectIdsUseCase` directly.
class PurchasedSubjectIdsViewModel extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final session = ref.watch(currentUserProvider);
    if (session == null || session.userId == null) return const <String>{};

    final result = await sl<GetPurchasedSubjectIdsUseCase>()(session.userId!);
    return result.when(
      success: (ids) => ids,
      failure: (failure) => throw failure,
    );
  }

  /// Instantly incorporates newly purchased subject IDs for 0ms rebuilds
  /// without waiting for remote server round-trips.
  void addPurchasedIds(Iterable<String> newIds) {
    final current = state.value ?? const <String>{};
    state = AsyncData<Set<String>>({...current, ...newIds});
  }
}

final purchasedSubjectIdsProvider =
    AsyncNotifierProvider<PurchasedSubjectIdsViewModel, Set<String>>(
  PurchasedSubjectIdsViewModel.new,
);

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
