import 'package:azeem_book_app/core/config/app_config.dart';
import 'package:azeem_book_app/presentation/auth/viewmodel/otp_timer_viewmodel.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('startCooldown counts down from the configured cooldown to 0', () {
    fakeAsync((async) {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(otpTimerViewModelProvider, (_, _) {});

      container
          .read(otpTimerViewModelProvider.notifier)
          .startCooldown('03001234567');

      final initial = container.read(otpTimerViewModelProvider);
      expect(initial.secondsRemaining, AppConfig.otpResendCooldownSeconds);
      expect(initial.canRequestNow, isFalse);
      expect(initial.attemptCount, 1);

      async.elapse(
        Duration(seconds: AppConfig.otpResendCooldownSeconds - 1),
      );
      expect(container.read(otpTimerViewModelProvider).secondsRemaining, 1);
      expect(container.read(otpTimerViewModelProvider).canRequestNow, isFalse);

      async.elapse(const Duration(seconds: 1));
      expect(container.read(otpTimerViewModelProvider).secondsRemaining, 0);
      expect(container.read(otpTimerViewModelProvider).canRequestNow, isTrue);
    });
  });

  test(
    'startCooldown increments attemptCount for the same number, resets for '
    'a different one',
    () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container.listen(otpTimerViewModelProvider, (_, _) {});
        final notifier = container.read(otpTimerViewModelProvider.notifier);

        notifier.startCooldown('03001234567');
        async.elapse(Duration(seconds: AppConfig.otpResendCooldownSeconds));

        notifier.startCooldown('03001234567');
        expect(container.read(otpTimerViewModelProvider).attemptCount, 2);
        async.elapse(Duration(seconds: AppConfig.otpResendCooldownSeconds));

        notifier.startCooldown('03009999999');
        expect(container.read(otpTimerViewModelProvider).attemptCount, 1);
      });
    },
  );

  test(
    'attemptLimitReached flips once attemptCount reaches otpMaxResendAttempts',
    () {
      fakeAsync((async) {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container.listen(otpTimerViewModelProvider, (_, _) {});
        final notifier = container.read(otpTimerViewModelProvider.notifier);

        for (var i = 1; i < AppConfig.otpMaxResendAttempts; i++) {
          notifier.startCooldown('03001234567');
          expect(
            container.read(otpTimerViewModelProvider).attemptLimitReached,
            isFalse,
          );
          async.elapse(Duration(seconds: AppConfig.otpResendCooldownSeconds));
        }

        notifier.startCooldown('03001234567');
        expect(
          container.read(otpTimerViewModelProvider).attemptLimitReached,
          isTrue,
        );
      });
    },
  );
}
