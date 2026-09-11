import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/ebook.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../viewmodel/student_home_viewmodel.dart';

/// "What do you want to do" sheet for a tapped Subject card on Student Home,
/// listing "Attempt Test" (always, leads into the chapter list) and
/// "Read Ebook" (status-aware, mirroring the retired `EbookBannerCard`) —
/// same `AppBottomSheet` + `AppCard` row pattern as `ChapterActionsSheet`.
class SubjectActionsSheet extends ConsumerWidget {
  const SubjectActionsSheet({
    super.key,
    required this.subjectId,
    required this.chapterListPath,
  });

  final String subjectId;
  final String chapterListPath;

  static void show({
    required BuildContext context,
    required String subjectId,
    required String subjectName,
    required String chapterListPath,
  }) {
    AppBottomSheet.show<void>(
      context: context,
      title: subjectName,
      child: SubjectActionsSheet(
        subjectId: subjectId,
        chapterListPath: chapterListPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedAsync = ref.watch(purchasedSubjectIdsProvider);
    final isPurchaseStatusLoading =
        purchasedAsync.isLoading && !purchasedAsync.hasValue;
    final isOwned = purchasedAsync.value?.contains(subjectId) ?? false;

    // The ebook-not-purchased response isn't consistent server-side (some
    // subjects 403 "not purchased", others 404 "no ebook uploaded" even
    // when also unpurchased) — purchase status is already known
    // client-side, so it's checked first and treated as authoritative for
    // "locked" rather than relying on which error code comes back. The
    // ebook endpoint is only queried at all once a subject is owned.
    final ebookAsync =
        isOwned ? ref.watch(ebookForSubjectProvider(subjectId)) : null;
    // Mirrors EbookBannerCard: only the genuinely-first fetch (no cached
    // value yet) gets a neutral row, so a `ready` ebook doesn't flash
    // "Coming soon" for a frame before the real status arrives.
    final isLoadingFirstFetch = isPurchaseStatusLoading ||
        (ebookAsync != null && ebookAsync.isLoading && !ebookAsync.hasValue);
    final access = ebookAsync?.value;
    final ebook = access is EbookAvailable ? access.ebook : null;
    final isReady = ebook?.status == EbookStatus.ready;
    final isProcessing =
        ebook?.status == EbookStatus.pending ||
        ebook?.status == EbookStatus.processing;
    // Locked either because the subject isn't owned (the common case,
    // resolved without ever hitting the ebook endpoint), or — as a
    // fallback for a stale purchase cache — because the backend still
    // came back 403 for a subject believed to be owned.
    final isLocked = (!isPurchaseStatusLoading && !isOwned) ||
        access is EbookLocked;
    final isNotUploaded = access is EbookNotUploaded;

    final ebookLabel = isLoadingFirstFetch || !isProcessing
        ? context.l10n.ebookBannerTitle
        : context.l10n.ebookBannerProcessing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          onTap: () {
            Navigator.of(context).pop();
            context.push(chapterListPath);
          },
          child: Row(
            children: [
              Icon(Icons.quiz_outlined, color: context.colors.primary),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: Text(
                  context.l10n.chapterActionAttemptTest,
                  style: context.textStyles.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.dimens.sm),
        AppCard(
          onTap: isReady
              ? () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.ebookReaderPath(subjectId));
                }
              : isLocked
                  ? () {
                      Navigator.of(context).pop();
                      AppSnackbar.show(context, context.l10n.ebookLockedMessage);
                    }
                  : null,
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    color: isReady
                        ? context.colors.primary
                        : context.colors.textSecondary,
                  ),
                  if (isLocked)
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.textSecondary,
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 10,
                          color: context.colors.surface,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: Text(
                  ebookLabel,
                  style: context.textStyles.bodyLarge?.copyWith(
                    color: isReady ? null : context.colors.textSecondary,
                  ),
                ),
              ),
              if (isLoadingFirstFetch)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.textSecondary,
                  ),
                )
              else if (isNotUploaded)
                StatusBadge(
                  label: context.l10n.commonComingSoon,
                  color: context.colors.textSecondary,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
