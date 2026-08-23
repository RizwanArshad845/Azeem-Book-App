import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
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

class _SubjectCardButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.dimens.radiusSm + 2),
        child: Ink(
          padding: EdgeInsets.symmetric(
            vertical: context.dimens.xs + 1,
            horizontal: context.dimens.sm,
          ),
          decoration: BoxDecoration(
            gradient: isOutlined
                ? null
                : LinearGradient(
                    colors: [context.colors.primary, context.colors.secondary],
                  ),
            color: isOutlined
                ? context.colors.primary.withValues(alpha: 0.12)
                : null,
            borderRadius: BorderRadius.circular(context.dimens.radiusSm + 2),
            border: isOutlined
                ? Border.all(
                    color: context.colors.primary.withValues(alpha: 0.3),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: context.dimens.iconSm,
                color: isOutlined
                    ? context.colors.primary
                    : context.colors.onPrimary,
              ),
              SizedBox(width: context.dimens.xs),
              Flexible(
                child: Text(
                  label,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: isOutlined
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
    );
  }
}
