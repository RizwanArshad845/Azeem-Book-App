import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import 'subject_actions_sheet.dart';

String _chapterListPath(String subjectId) =>
    AppRoutes.studentHomeSubjectChapters.replaceFirst(':subjectId', subjectId);

class SubjectCard extends ConsumerWidget {
  const SubjectCard({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subject.id) ?? false;
    final cartState = ref.watch(studentCartViewModelProvider).value;
    final cartItems = cartState?.items;
    final isInCart =
        cartItems != null && cartItems.any((i) => i.subjectId == subject.id);

    return AppCard(
      onTap: () => SubjectActionsSheet.show(
        context: context,
        subjectId: subject.id,
        subjectName: subject.name,
        chapterListPath: _chapterListPath(subject.id),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IllustrationThumbnail(
                imageAsset: subjectIllustration(subject.name),
                fallbackIcon: subjectIcon(subject.name),
                size: 48,
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
