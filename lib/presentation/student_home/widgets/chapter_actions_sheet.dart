import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../domain/catalog/entities/chapter.dart';

/// "More options" sheet for a single chapter card, listing "Attempt Test"
/// (always) and "Watch Video" (only when `Chapter.youtubeUrl` is set).
class ChapterActionsSheet extends StatelessWidget {
  const ChapterActionsSheet({
    super.key,
    required this.chapter,
    required this.testListPath,
  });

  final Chapter chapter;
  final String testListPath;

  static void show({
    required BuildContext context,
    required Chapter chapter,
    required String testListPath,
  }) {
    AppBottomSheet.show<void>(
      context: context,
      title: chapter.title,
      child: ChapterActionsSheet(
        chapter: chapter,
        testListPath: testListPath,
      ),
    );
  }

  Future<void> _watchVideo(BuildContext context) async {
    final url = chapter.youtubeUrl;
    if (url == null) return;
    Navigator.of(context).pop();
    final uri = Uri.tryParse(url);
    final launched =
        uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppSnackbar.show(context, context.l10n.chapterVideoOpenError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          onTap: () {
            Navigator.of(context).pop();
            context.push(testListPath);
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
        if (chapter.youtubeUrl != null) ...[
          SizedBox(height: context.dimens.sm),
          AppCard(
            onTap: () => _watchVideo(context),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline, color: context.colors.primary),
                SizedBox(width: context.dimens.sm),
                Expanded(
                  child: Text(
                    context.l10n.chapterActionWatchVideo,
                    style: context.textStyles.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
