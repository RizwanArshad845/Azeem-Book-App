import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../ebook_reader/viewmodel/offline_ebook_viewmodel.dart';

/// "How do you want to read?" sheet for a subject's ebook: read online,
/// save for offline reading (with live download progress), or — once saved
/// — read offline / remove the download.
class EbookOptionsSheet extends ConsumerWidget {
  const EbookOptionsSheet({
    super.key,
    required this.subjectId,
    required this.canReadOnline,
    required this.title,
  });

  final String subjectId;
  final String title;

  /// Ebook is ready and reachable right now (needed to read online or to
  /// start a download).
  final bool canReadOnline;

  static void show({
    required BuildContext context,
    required String subjectId,
    required String title,
    required bool canReadOnline,
  }) {
    AppBottomSheet.show<void>(
      context: context,
      title: title,
      child: EbookOptionsSheet(
        subjectId: subjectId,
        canReadOnline: canReadOnline,
        title: title,
      ),
    );
  }

  Future<void> _download(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(ebookDownloadViewModelProvider(subjectId).notifier)
        .download(title: title);
    if (!context.mounted) return;
    AppSnackbar.show(
      context,
      ok ? context.l10n.ebookDownloadDone : context.l10n.ebookDownloadFailed,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(offlineEbookProvider(subjectId)).value;
    final progress = ref.watch(ebookDownloadViewModelProvider(subjectId));

    void open(String path) {
      Navigator.of(context).pop();
      context.push(path);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetOption(
          icon: Icons.wifi_rounded,
          title: context.l10n.ebookReadOnline,
          subtitle: context.l10n.ebookReadOnlineHint,
          onTap: canReadOnline
              ? () => open(AppRoutes.ebookReaderPath(subjectId))
              : null,
        ),
        SizedBox(height: context.dimens.sm),
        if (saved != null) ...[
          _SheetOption(
            icon: Icons.offline_pin_rounded,
            title: context.l10n.ebookReadOffline,
            subtitle: context.l10n.ebookOfflineSaved,
            color: context.colors.success,
            onTap: () => open(AppRoutes.ebookReaderOfflinePath(subjectId)),
          ),
          SizedBox(height: context.dimens.sm),
          _SheetOption(
            icon: Icons.delete_outline_rounded,
            title: context.l10n.ebookRemoveDownload,
            color: context.colors.error,
            onTap: () => ref
                .read(ebookDownloadViewModelProvider(subjectId).notifier)
                .remove(),
          ),
        ] else
          _SheetOption(
            icon: Icons.download_rounded,
            title: context.l10n.ebookSaveOffline,
            subtitle: progress == null
                ? context.l10n.ebookSaveOfflineHint
                : context.l10n.ebookDownloading((progress * 100).round()),
            onTap: canReadOnline && progress == null
                ? () => _download(context, ref)
                : null,
            footer: progress == null
                ? null
                : LinearProgressIndicator(
                    value: progress,
                    color: context.colors.primary,
                    backgroundColor: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(context.dimens.xs),
                  ),
          ),
      ],
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.color,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? color;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final accent = enabled
        ? (color ?? context.colors.primary)
        : context.colors.textSecondary;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: accent),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textStyles.bodyLarge?.copyWith(
                        color: enabled ? null : context.colors.textSecondary,
                      ),
                    ),
                    if (subtitle case final subtitle?)
                      Text(
                        subtitle,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (footer case final footer?) ...[
            SizedBox(height: context.dimens.sm),
            footer,
          ],
        ],
      ),
    );
  }
}
