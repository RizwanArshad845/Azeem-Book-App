import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// A lightweight shimmer skeleton block (no external package). Animates a
/// moving highlight across a rounded placeholder. Compose several into list /
/// card skeletons for loading states on Home, Progress and Test Result.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius,
    this.shape = BoxShape.rectangle,
  });

  const Skeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = null,
        shape = BoxShape.circle;

  final double? width;
  final double height;
  final double? radius;
  final BoxShape shape;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.surfaceVariant;
    final highlight = context.colors.divider;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle
                ? null
                : BorderRadius.circular(widget.radius ?? context.dimens.radiusSm),
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - t), 0),
              end: Alignment(1 - 2 * (1 - t), 0),
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}

/// A stack of card-shaped skeleton rows for list loading states.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 4, this.itemHeight = 84});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: context.dimens.sm + 4),
          child: Row(
            children: [
              Skeleton(
                width: itemHeight * 0.75,
                height: itemHeight * 0.75,
                radius: context.dimens.radiusMd,
              ),
              SizedBox(width: context.dimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: double.infinity, height: 14),
                    SizedBox(height: context.dimens.sm),
                    Skeleton(width: 140, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
