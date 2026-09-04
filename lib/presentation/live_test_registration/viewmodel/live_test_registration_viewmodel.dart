import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/live_test_registration/entities/live_test_registration.dart';
import '../../../domain/live_test_registration/usecases/get_live_test_registrations_usecase.dart';
import '../../../domain/live_test_registration/usecases/register_for_live_test_usecase.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

/// Live-test registration state for the current student (§9.2
/// `LiveTestRegistration`; §11 Phase-1 "Live tests | Beta (register +
/// run)"). `build()` loads every registration the student has ever made;
/// [register] is a one-off write with its own loading/error state on the
/// button press that triggered it, mirroring `StudentCartViewModel.addTest`.
///
/// Note: this project has no `riverpod_generator` dependency (only
/// `flutter_riverpod`), so — consistent with `StudentCartViewModel`/
/// `TestTakingViewModel` — this is a hand-written `AsyncNotifier` with a
/// manually declared provider, not `@riverpod` codegen. Also note: this
/// codebase's Riverpod 3.x has no `AsyncValue.valueOrNull` — `.value` is
/// used directly throughout.
class LiveTestRegistrationViewModel
    extends AsyncNotifier<List<LiveTestRegistration>> {
  @override
  Future<List<LiveTestRegistration>> build() async {
    final session = ref.watch(currentUserProvider);
    if (session == null) {
      // Edge case only — router redirect guarantees a resolved session
      // before the student shell is reachable (mirrors
      // StudentCartViewModel.build()).
      return const <LiveTestRegistration>[];
    }

    final result = await sl<GetLiveTestRegistrationsUseCase>()(
      session.userId!,
    );
    return result.when(
      success: (registrations) => registrations,
      failure: (failure) => throw failure,
    );
  }

  bool isRegistered(String testId) =>
      (state.value ?? const <LiveTestRegistration>[]).any(
        (registration) => registration.testId == testId,
      );

  /// Registers the current student for [testId]. No-ops if already
  /// registered (checked against the last-loaded state) so a double-tap on
  /// the "Register" button can never produce a duplicate registration.
  Future<void> register(String testId) async {
    final session = ref.read(currentUserProvider);
    if (session == null) return;

    final current = state.value ?? const <LiveTestRegistration>[];
    if (current.any((registration) => registration.testId == testId)) return;

    state = const AsyncLoading<List<LiveTestRegistration>>();
    final result = await sl<RegisterForLiveTestUseCase>()(
      studentId: session.userId!,
      testId: testId,
    );
    state = result.when(
      success: (registration) =>
          AsyncData<List<LiveTestRegistration>>([...current, registration]),
      failure: (failure) => AsyncError<List<LiveTestRegistration>>(
        failure,
        StackTrace.current,
      ),
    );
  }
}

final liveTestRegistrationViewModelProvider = AsyncNotifierProvider<
  LiveTestRegistrationViewModel,
  List<LiveTestRegistration>
>(LiveTestRegistrationViewModel.new);
