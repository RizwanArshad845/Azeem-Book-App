import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';
import '../viewmodel/offline_ebook_viewmodel.dart';

/// Offline-screen section: "While you wait, read offline" with the student's
/// downloaded ebooks, each opening the offline reader. With no downloads, a
/// student instead sees a tip on how to save one; teachers see nothing.
/// Navigates via the router directly because the offline screen sits above
/// the router's navigator.
class SavedEbooksShortcut extends ConsumerWidget {
  const SavedEbooksShortcut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStudent = ref.watch(currentStudentProvider) != null;
    final usable = ref.watch(savedOfflineEbooksProvider).value ?? const [];
    if (!isStudent && usable.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: context.dimens.xl),
      child: usable.isEmpty
          ? _Tip(text: context.l10n.offlineSavedEbooksTip)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      color: context.colors.secondary,
                      size: context.dimens.iconMd,
                    ),
                    SizedBox(width: context.dimens.sm),
                    Expanded(
                      child: Text(
                        context.l10n.offlineSavedEbooksTitle,
                        style: context.textStyles.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.dimens.sm),
                for (final book in usable) ...[
                  AppCard(
                    onTap: () => ref
                        .read(goRouterProvider)
                        .push(AppRoutes.ebookReaderOfflinePath(book.subjectId)),
                    child: Row(
                      children: [
                        IllustrationThumbnail(
                          imageAsset: book.title.isEmpty
                              ? null
                              : subjectIllustration(book.title),
                          fallbackIcon: subjectIcon(book.title),
                          size: context.dimens.avatarMd,
                        ),
                        SizedBox(width: context.dimens.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title.isEmpty
                                    ? context.l10n.hubEbook
                                    : context.l10n.localizedSubjectName(
                                        book.title,
                                      ),
                                style: context.textStyles.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                context.l10n.ebookReadOffline,
                                style: context.textStyles.bodySmall?.copyWith(
                                  color: context.colors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.menu_book_rounded,
                          color: context.colors.primary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.dimens.sm),
                ],
              ],
            ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.dimens.md),
      decoration: BoxDecoration(
        color: context.colors.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(context.dimens.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: context.colors.secondary,
            size: context.dimens.iconMd,
          ),
          SizedBox(width: context.dimens.sm),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
