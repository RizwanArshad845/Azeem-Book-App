import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extensions.dart';
import '../providers/connectivity_provider.dart';
import 'app_button.dart';
import 'app_logo.dart';
import 'blurred_logo_backdrop.dart';

/// Full-screen "you're offline" screen, shown over the whole app (by `App`)
/// for as long as the device has no connection and removed automatically once
/// it's back — so whatever the user was doing underneath is still there.
///
/// Deliberately calm rather than error-red: a branded backdrop, a pulsing
/// "searching for signal" badge, a live reconnecting indicator (connectivity
/// is re-checked in the background) and one primary "Try again" action.
///
/// [footer] is optional extra content below (the app passes the student's
/// downloaded-ebooks list, still readable offline).
class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key, this.footer});

  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.dimens.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.dimens.contentMaxWidth,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo(size: 72)),
                    SizedBox(height: context.dimens.xl),
                    const Center(child: _SignalPulse()),
                    SizedBox(height: context.dimens.lg),
                    Text(
                      context.l10n.offlineTitle,
                      textAlign: TextAlign.center,
                      style: context.textStyles.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: context.dimens.sm),
                    Text(
                      context.l10n.offlineMessage,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: context.dimens.md),
                    const _ReconnectingChip(),
                    SizedBox(height: context.dimens.lg),
                    AppButton(
                      label: context.l10n.offlineTryAgain,
                      icon: Icons.refresh_rounded,
                      onPressed: () =>
                          ref.read(isOnlineProvider.notifier).recheck(),
                    ),
                    ?footer,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wi-Fi-off badge with two rings rippling outward — reads as "looking for a
/// signal" instead of a static error.
class _SignalPulse extends StatefulWidget {
  const _SignalPulse();

  @override
  State<_SignalPulse> createState() => _SignalPulseState();
}

class _SignalPulseState extends State<_SignalPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.primary;
    final core = context.dimens.avatarLg * 1.3;
    final extent = core * 2;

    Widget ring(double phase) {
      final t = (_controller.value + phase) % 1;
      return Opacity(
        opacity: (1 - t) * 0.35,
        child: Container(
          width: core + (extent - core) * t,
          height: core + (extent - core) * t,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
      );
    }

    return SizedBox(
      width: extent,
      height: extent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            ring(0),
            ring(0.5),
            Container(
              width: core,
              height: core,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: context.colors.brandGradient,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: context.dimens.lg,
                    offset: Offset(0, context.dimens.sm),
                  ),
                ],
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: context.colors.onPrimary,
                size: core * 0.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReconnectingChip extends StatelessWidget {
  const _ReconnectingChip();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimens.md,
          vertical: context.dimens.xs + 2,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.dimens.pillRadius),
          border: Border.all(color: context.colors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: context.dimens.iconSm - 4,
              height: context.dimens.iconSm - 4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.primary,
              ),
            ),
            SizedBox(width: context.dimens.sm),
            Text(
              context.l10n.offlineReconnecting,
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
