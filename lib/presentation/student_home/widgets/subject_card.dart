import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';

String _chapterListPath(String subjectId) =>
    AppRoutes.studentHomeSubjectChapters.replaceFirst(':subjectId', subjectId);

class SubjectCard extends ConsumerWidget {
  const SubjectCard({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subject.id) ?? false;

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
                  color: context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: context.colors.primary,
                  size: context.dimens.iconMd,
                ),
              ),
              if (isOwned)
                StatusBadge(
                  label: context.l10n.subjectCardOwnedBadge,
                  color: context.colors.success,
                ),
            ],
          ),
          SizedBox(height: context.dimens.xs),
          Text(
            subject.name,
            style: context.textStyles.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
