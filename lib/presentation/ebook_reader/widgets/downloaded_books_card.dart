import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/offline_ebook_viewmodel.dart';

/// The offline screen's single e-book entry point: "My downloaded books ·
/// N books ready to read offline ›". Opens the downloads list. With nothing
/// downloaded it isn't tappable and explains how to save one; teachers (no
/// ebooks) see nothing.
///
/// Navigates via the router directly because the offline screen sits above
/// the router's navigator, so `context.push` has no `GoRouter` to find.
class DownloadedBooksCard extends ConsumerWidget {
  const DownloadedBooksCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStudent =
        ref.watch(currentUserProvider)?.role == UserRole.student;
    final count = ref.watch(savedOfflineEbooksProvider).value?.length ?? 0;
    if (!isStudent && count == 0) return const SizedBox.shrink();

    final colors = context.colors;
    final dimens = context.dimens;
    final hasBooks = count > 0;

    return AppCard(
      onTap: hasBooks
          ? () => ref.read(goRouterProvider).push(AppRoutes.downloads)
          : null,
      child: Row(
        children: [
          Container(
            width: dimens.avatarMd,
            height: dimens.avatarMd,
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(dimens.radiusMd),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: colors.secondary,
              size: dimens.iconMd,
            ),
          ),
          SizedBox(width: dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.downloadsTitle,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: dimens.xs),
                Text(
                  hasBooks
                      ? context.l10n.downloadsCardSubtitle(count)
                      : context.l10n.downloadsNoneYet,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: hasBooks ? colors.success : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (hasBooks)
            Icon(Icons.chevron_right_rounded, color: colors.primary),
        ],
      ),
    );
  }
}
