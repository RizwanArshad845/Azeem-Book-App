import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/press_scale.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/student_cart/usecases/price_for_subject_bundle.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';

String _chapterListPath(String subjectId) =>
    AppRoutes.studentHomeSubjectChapters.replaceFirst(':subjectId', subjectId);

class SubjectCard extends ConsumerWidget {
  const SubjectCard({super.key, required this.subject});

  final Subject subject;

  Future<void> _addToCart(
    
    BuildContext context,
    WidgetRef ref,
    List<Test> tests,
  ) async {
    await ref
        .read(studentCartViewModelProvider.notifier)
        .addSubjectBundle(subject, tests);
    if (!context.mounted) return;
    AppSnackbar.show(context, context.l10n.chapterListAddedToCart);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subject.id) ?? false;
    final tests = ref.watch(testsForSubjectProvider(subject.id)).value;
    final cartState = ref.watch(studentCartViewModelProvider).value;
    final cartItems = cartState?.items;
    final isInCart =
        cartItems != null && cartItems.any((i) => i.subjectId == subject.id);

    return AppCard(
      onTap: () => context.push(_chapterListPath(subject.id)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(context.dimens.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.primary, context.colors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                ),
                child: Icon(
                  subjectIcon(subject.name),
                  color: context.colors.onPrimary,
                  size: context.dimens.iconMd,
                ),
              ),
              if (isOwned)
                StatusBadge(
                  label: context.l10n.subjectCardOwnedBadge,
                  color: context.colors.success,
                )
              else if (isInCart)
                StatusBadge(
                  label: context.l10n.subjectCardInCartBadge,
                  color: context.colors.primary,
                ),
            ],
          ),
          SizedBox(height: context.dimens.xs),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.localizedSubjectName(subject.name),
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: context.dimens.xs / 2),
          if (isOwned)
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.subjectCardExploreHint,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.colors.textSecondary,
                  size: context.dimens.iconSm,
                ),
              ],
            )
          else if (isInCart)
            _SubjectCardButton(
              label: context.l10n.subjectCardInCartBadge,
              icon: Icons.shopping_bag_outlined,
              isOutlined: true,
              onPressed: () => context.push(AppRoutes.studentCart),
            )
          else if (tests != null && tests.isNotEmpty)
            _SubjectCardButton(
              label: context.l10n.subjectCardAddToCart(
                priceForSubjectBundle(tests).toStringAsFixed(0),
              ),
              icon: Icons.add_shopping_cart,
              onPressed: () => _addToCart(context, ref, tests),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.subjectCardExploreHint,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.colors.textSecondary,
                  size: context.dimens.iconSm,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SubjectCardButton extends StatefulWidget {
  const _SubjectCardButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isOutlined = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isOutlined;

  @override
  State<_SubjectCardButton> createState() => _SubjectCardButtonState();
}

class _SubjectCardButtonState extends State<_SubjectCardButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _scaleAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.0, end: 0.92)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.92, end: 1.08)
          .chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.08, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 25,
    ),
  ]).animate(_pulseController);

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pulseController.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return PressScale(
      haptic: true,
      scale: 0.96,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: widget.isOutlined
                ? null
                : LinearGradient(
                    colors: [context.colors.primary, context.colors.secondary],
                  ),
            color: widget.isOutlined
                ? context.colors.primary.withValues(alpha: 0.12)
                : null,
            borderRadius: BorderRadius.circular(context.dimens.radiusSm + 2),
            border: widget.isOutlined
                ? Border.all(
                    color: context.colors.primary.withValues(alpha: 0.3),
                  )
                : null,
            boxShadow: widget.isOutlined
                ? null
                : [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: BorderRadius.circular(context.dimens.radiusSm + 2),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.dimens.xs + 1,
                  horizontal: context.dimens.sm,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Row(
                    key: ValueKey<String>('${widget.label}_${widget.isOutlined}'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: context.dimens.iconSm,
                        color: widget.isOutlined
                            ? context.colors.primary
                            : context.colors.onPrimary,
                      ),
                      SizedBox(width: context.dimens.xs),
                      Flexible(
                        child: Text(
                          widget.label,
                          style: context.textStyles.labelSmall?.copyWith(
                            color: widget.isOutlined
                                ? context.colors.primary
                                : context.colors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
