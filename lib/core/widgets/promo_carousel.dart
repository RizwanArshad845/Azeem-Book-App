import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extensions.dart';

/// Data for a single promotional banner card.
class PromoBanner {
  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.fallbackIcon,
    this.imageAsset,
    this.onTap,
    this.gradientColors,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData fallbackIcon;
  final String? imageAsset;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
}

/// Riverpod provider managing active page index for promo carousels.
class PromoCarouselPageNotifier extends Notifier<int> {
  static const virtualBase = 10000;

  @override
  int build() => virtualBase;

  void setPage(int page) => state = page;
}

final promoCarouselPageProvider =
    NotifierProvider.autoDispose<PromoCarouselPageNotifier, int>(
  PromoCarouselPageNotifier.new,
);

/// A horizontally-scrolling, auto-advancing, infinite promo carousel with page
/// dots. Each card is swipe-to-dismiss (vertical) and reports dismissals via
/// [onDismiss]. Replaces the single static live-test banner on Home.
class PromoCarousel extends ConsumerStatefulWidget {
  const PromoCarousel({
    super.key,
    required this.banners,
    this.height = 132,
    this.onDismiss,
  });

  final List<PromoBanner> banners;
  final double height;
  final ValueChanged<String>? onDismiss;

  @override
  ConsumerState<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends ConsumerState<PromoCarousel> {
  late final PageController _controller = PageController(
    initialPage: PromoCarouselPageNotifier.virtualBase,
    viewportFraction: 0.92,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _timer?.cancel();
    if (widget.banners.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();
    final page = ref.watch(promoCarouselPageProvider);

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (p) =>
                ref.read(promoCarouselPageProvider.notifier).setPage(p),
            itemBuilder: (context, index) {
              final banner = banners[index % banners.length];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dimens.xs),
                child: Dismissible(
                  key: ValueKey('promo-${banner.id}-$index'),
                  direction: DismissDirection.up,
                  onDismissed: (_) => widget.onDismiss?.call(banner.id),
                  child: _PromoCard(banner: banner),
                ),
              );
            },
          ),
        ),
        if (banners.length > 1) ...[
          SizedBox(height: context.dimens.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (i) {
              final active = page % banners.length == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: context.dimens.xs / 2),
                width: active
                    ? (context.dimens.md + context.dimens.xs / 2)
                    : (context.dimens.sm - 2),
                height: context.dimens.sm - 2,
                decoration: BoxDecoration(
                  color: active ? context.colors.primary : context.colors.divider,
                  borderRadius: BorderRadius.circular(context.dimens.radiusSm),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.banner});

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    final gradient = banner.gradientColors ??
        [context.colors.primary, context.colors.secondary];
    return Semantics(
      label: '${banner.title}, ${banner.subtitle}',
      button: banner.onTap != null,
      child: GestureDetector(
        onTap: banner.onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(context.dimens.radiusLg),
          ),
          padding: EdgeInsets.all(context.dimens.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleMedium?.copyWith(
                        color: context.colors.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: context.dimens.xs),
                    Text(
                      banner.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.dimens.sm),
              _bannerArt(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerArt(BuildContext context) {
    final fallback = Icon(
      banner.fallbackIcon,
      color: context.colors.onPrimary,
      size: context.dimens.iconLg + context.dimens.sm,
    );
    if (banner.imageAsset == null) return fallback;
    final imageDimension = context.dimens.xxl + context.dimens.sm;
    return Image.asset(
      banner.imageAsset!,
      width: imageDimension,
      height: imageDimension,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
