import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/hub_action_card.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/youtube_logo.dart';
import '../../../domain/catalog/entities/ebook.dart';
import '../../ebook_reader/viewmodel/offline_ebook_viewmodel.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_home/view/chapter_list_view.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';
import '../widgets/ebook_options_sheet.dart';

/// What a subject offers, as three big cards — Video Lectures, Online Test
/// and Ebook — opened from a subject card on Student Home. Lectures and
/// tests lead into the chapter list (in the matching mode); the ebook card
/// opens the read-online / save-offline sheet.
class SubjectHubView extends ConsumerWidget {
  const SubjectHubView({super.key, required this.subjectId, this.subjectName});

  final String subjectId;
  final String? subjectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name =
        subjectName ?? ref.watch(subjectByIdProvider(subjectId)).value?.name;
    final title = name != null
        ? context.l10n.localizedSubjectName(name)
        : context.l10n.chapterListTitle;

    void openChapters(ChapterListMode mode) => context.push(
      AppRoutes.subjectChaptersPath(subjectId, mode: mode.name),
      extra: name,
    );

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.dimens.lg),
          children: [
            FadeSlideIn(
              child: Row(
                children: [
                  IllustrationThumbnail(
                    imageAsset: name == null ? null : subjectIllustration(name),
                    fallbackIcon: subjectIcon(name ?? ''),
                    size: context.dimens.avatarLg,
                  ),
                  SizedBox(width: context.dimens.md),
                  Expanded(
                    child: Text(
                      context.l10n.subjectHubSubtitle,
                      style: context.textStyles.titleMedium?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.dimens.lg),
            Row(
              children: [
                Expanded(
                  child: FadeSlideIn(
                    delay: const Duration(milliseconds: 80),
                    child: AspectRatio(
                      aspectRatio: 0.95,
                      child: HubActionCard(
                        leading: const YoutubeLogo(),
                        title: context.l10n.hubVideoLectures,
                        hint: context.l10n.hubVideoLecturesHint,
                        onTap: () => openChapters(ChapterListMode.video),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.dimens.md),
                Expanded(
                  child: FadeSlideIn(
                    delay: const Duration(milliseconds: 160),
                    child: AspectRatio(
                      aspectRatio: 0.95,
                      child: HubActionCard(
                        leading: _IconTile(
                          icon: Icons.edit_note_rounded,
                          color: context.colors.primary,
                        ),
                        title: context.l10n.hubOnlineTest,
                        hint: context.l10n.hubOnlineTestHint,
                        onTap: () => openChapters(ChapterListMode.test),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimens.md),
            FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: AspectRatio(
                aspectRatio: 2.2,
                child: _EbookCard(subjectId: subjectId, title: title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ebook card: status-aware (locked / coming soon / processing / ready /
/// saved offline / downloading). Status logic carried over from the retired
/// subject actions sheet.
class _EbookCard extends ConsumerWidget {
  const _EbookCard({required this.subjectId, required this.title});

  final String subjectId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedAsync = ref.watch(purchasedSubjectIdsProvider);
    final isPurchaseStatusLoading =
        purchasedAsync.isLoading && !purchasedAsync.hasValue;
    final isOwned = purchasedAsync.value?.contains(subjectId) ?? false;

    // Purchase status is known client-side and treated as authoritative for
    // "locked" — the ebook endpoint is only queried once a subject is owned
    // (its not-purchased response is inconsistent server-side: 403 or 404).
    final ebookAsync =
        isOwned ? ref.watch(ebookForSubjectProvider(subjectId)) : null;
    // Watched regardless of ownership: with no network the purchase list may
    // be unavailable, and a saved copy must still open. (Online, the
    // provider itself wipes copies the server no longer grants.)
    final saved = ref.watch(offlineEbookProvider(subjectId)).value;
    final progress = ref.watch(ebookDownloadViewModelProvider(subjectId));

    final isLoadingFirstFetch = isPurchaseStatusLoading ||
        (ebookAsync != null && ebookAsync.isLoading && !ebookAsync.hasValue);
    final access = ebookAsync?.value;
    final ebook = access is EbookAvailable ? access.ebook : null;
    final isReady = ebook?.status == EbookStatus.ready;
    final isProcessing = ebook?.status == EbookStatus.pending ||
        ebook?.status == EbookStatus.processing;
    final isLocked =
        (!isPurchaseStatusLoading && !isOwned) || access is EbookLocked;
    final isNotUploaded = access is EbookNotUploaded;
    final hasOfflineCopy = saved != null;

    final Widget? badge;
    if (progress != null) {
      badge = null;
    } else if (hasOfflineCopy) {
      badge = StatusBadge(
        label: context.l10n.hubSavedOfflineBadge,
        color: context.colors.success,
      );
    } else if (isLocked) {
      badge = Icon(Icons.lock_rounded, color: context.colors.textSecondary);
    } else if (isNotUploaded) {
      badge = StatusBadge(
        label: context.l10n.commonComingSoon,
        color: context.colors.textSecondary,
      );
    } else if (isProcessing) {
      badge = StatusBadge(
        label: context.l10n.ebookBannerProcessing,
        color: context.colors.warning,
      );
    } else {
      badge = null;
    }

    final VoidCallback? onTap;
    if (isReady || hasOfflineCopy) {
      onTap = () => EbookOptionsSheet.show(
        context: context,
        subjectId: subjectId,
        title: title,
        canReadOnline: isReady,
      );
    } else if (isLocked) {
      onTap = () => AppSnackbar.show(context, context.l10n.ebookLockedMessage);
    } else {
      onTap = null;
    }

    return HubActionCard(
      leading: _IconTile(
        icon: Icons.menu_book_rounded,
        color: isLocked
            ? context.colors.textSecondary
            : context.colors.secondary,
      ),
      badge: badge,
      title: context.l10n.hubEbook,
      hint: progress != null
          ? context.l10n.ebookDownloading((progress * 100).round())
          : context.l10n.hubEbookHint,
      trailing: isLoadingFirstFetch || progress != null
          ? SizedBox(
              width: context.dimens.iconSm,
              height: context.dimens.iconSm,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress,
                color: context.colors.textSecondary,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

/// Rounded tinted tile holding a large icon — the hub's non-photo card art.
class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = context.dimens.xxl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.dimens.radiusMd),
      ),
      child: Icon(icon, color: color, size: context.dimens.iconLg),
    );
  }
}
