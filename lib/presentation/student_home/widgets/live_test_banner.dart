import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../domain/catalog/entities/test.dart';

class LiveTestBanner extends StatelessWidget {
  const LiveTestBanner({super.key, required this.liveTestsAsync});

  final AsyncValue<List<Test>> liveTestsAsync;

  @override
  Widget build(BuildContext context) {
    final liveTests = liveTestsAsync.value;
    if (liveTests == null || liveTests.isEmpty) return const SizedBox.shrink();

    final next = liveTests.first;
    final radius = BorderRadius.circular(context.dimens.radiusLg);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => context.push(AppRoutes.studentLiveTests),
        child: Container(
          padding: EdgeInsets.all(context.dimens.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colors.warning,
                Color.lerp(context.colors.warning, context.colors.error, 0.35)!,
              ],
            ),
            borderRadius: radius,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.dimens.sm),
                decoration: BoxDecoration(
                  color: context.colors.onPrimary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.podcasts, color: context.colors.onPrimary),
              ),
              SizedBox(width: context.dimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _PulsingLiveDot(),
                        SizedBox(width: context.dimens.xs),
                        Text(
                          liveTests.length == 1
                              ? context.l10n.liveTestScheduledSingle
                              : context.l10n.liveTestScheduledMultiple(
                                  liveTests.length,
                                ),
                          style: context.textStyles.titleSmall?.copyWith(
                            color: context.colors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimens.xs / 2),
                    Text(
                      next.title,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onPrimary.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.colors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small animated dot next to the "Live" copy so the banner reads as
/// genuinely live, not a static list row — a gentle opacity pulse, not a
/// distracting animation.
class _PulsingLiveDot extends StatefulWidget {
  @override
  State<_PulsingLiveDot> createState() => _PulsingLiveDotState();
}

class _PulsingLiveDotState extends State<_PulsingLiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.35,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: context.colors.onPrimary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
