import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../../domain/ebook_offline/entities/offline_ebook.dart';
import '../offline_reader_presence.dart';
import '../viewmodel/offline_ebook_viewmodel.dart';

/// Every ebook saved on this device. Works with no connection (local storage
/// only), so it's the screen the offline overlay's "My downloaded books" card
/// opens; also reachable from the student profile while online.
/// Tap a book to read it; swipe it away to remove the download.
class DownloadedBooksView extends ConsumerStatefulWidget {
  const DownloadedBooksView({super.key});

  @override
  ConsumerState<DownloadedBooksView> createState() =>
      _DownloadedBooksViewState();
}

class _DownloadedBooksViewState extends ConsumerState<DownloadedBooksView>
    with OfflineSafeScreen {
  Future<bool> _confirmRemove(OfflineEbook book) async {
    final ok = await confirmDialog(
      context,
      title: context.l10n.ebookRemoveDownload,
      message: context.l10n.downloadsRemoveMessage,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.ebookRemoveDownload,
      isDestructive: true,
    );
    if (ok != true) return false;
    await ref
        .read(ebookDownloadViewModelProvider(book.subjectId).notifier)
        .remove();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(savedOfflineEbooksProvider);
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.downloadsTitle)),
      body: AsyncValueWidget<List<OfflineEbook>>(
        value: books,
        data: (items) {
          if (items.isEmpty) {
            return EmptyStateView(
              icon: Icons.download_for_offline_outlined,
              message: context.l10n.downloadsEmpty,
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(context.dimens.md),
            itemCount: items.length + 1,
            separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
            itemBuilder: (context, i) {
              if (i == items.length) {
                return Padding(
                  padding: EdgeInsets.only(top: context.dimens.sm),
                  child: Text(
                    context.l10n.downloadsSwipeHint,
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                );
              }
              final book = items[i];
              return FadeSlideIn(
                delay: Duration(milliseconds: 40 * i.clamp(0, 8)),
                child: Dismissible(
                  key: ValueKey(book.subjectId),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmRemove(book),
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.dimens.lg,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(
                        context.dimens.radiusLg,
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: context.colors.error,
                    ),
                  ),
                  child: _BookRow(book: book),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({required this.book});

  final OfflineEbook book;

  @override
  Widget build(BuildContext context) {
    final title = book.title.isEmpty
        ? context.l10n.hubEbook
        : context.l10n.localizedSubjectName(book.title);
    return AppCard(
      onTap: () => context.push(AppRoutes.ebookReaderOfflinePath(book.subjectId)),
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
                  title,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.dimens.xs),
                Text(
                  context.l10n.downloadsPages(book.pageCount),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.colors.primary),
        ],
      ),
    );
  }
}
