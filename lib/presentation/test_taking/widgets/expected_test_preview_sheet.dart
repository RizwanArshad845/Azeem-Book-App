import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../domain/catalog/entities/test.dart';

/// Chapters covered + question count for a [Test], resolved on demand from
/// its questions' `chapterId`s — project_spec.md §9.2 has no denormalized
/// "chapters covered" list on `Test` itself.
class _ExpectedTestPreview {
  const _ExpectedTestPreview({
    required this.chapterTitles,
    required this.questionCount,
  });

  final List<String> chapterTitles;
  final int questionCount;
}

final _expectedTestPreviewProvider =
    FutureProvider.family<_ExpectedTestPreview, Test>((ref, test) async {
      final questionsResult = await ref.read(getQuestionsUseCaseProvider)(
        test.id,
      );
      final questions = questionsResult.when(
        success: (qs) => qs,
        failure: (failure) => throw failure,
      );

      final chapterIds = {for (final q in questions) q.chapterId};

      final chaptersResult = await ref.read(getChaptersUseCaseProvider)(
        test.subjectId,
      );
      final chapterTitles = chaptersResult.when(
        success: (chapters) => [
          for (final chapter in chapters)
            if (chapterIds.contains(chapter.id)) chapter.title,
        ],
        failure: (_) => const <String>[],
      );

      return _ExpectedTestPreview(
        chapterTitles: chapterTitles,
        questionCount: questions.length,
      );
    });

/// Expected-test-preview bottom sheet (CLAUDE.md §5 "View expected test
/// preview option prior to attempt") — shown before a student commits to
/// starting a [Test]: chapters covered and total question count.
///
/// No time-limit row: neither `Test` nor `TestAttempt` (project_spec.md
/// §9.2) model a duration field — the 30-minute Phase-1 default lives only
/// as a constant inside `TestTakingViewModel`, not on either entity, so it
/// isn't surfaced here rather than inventing a field.
class ExpectedTestPreviewSheet extends ConsumerWidget {
  const ExpectedTestPreviewSheet({super.key, required this.test});

  final Test test;

  /// Shows the preview sheet; resolves to `true` if the student tapped
  /// "Start test" (the caller should then navigate into the attempt),
  /// `null`/`false` if they dismissed it instead.
  static Future<bool?> show(BuildContext context, Test test) {
    return AppBottomSheet.show<bool>(
      context: context,
      title: context.l10n.testPreviewTitle,
      child: ExpectedTestPreviewSheet(test: test),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_expectedTestPreviewProvider(test));

    return AsyncValueWidget<_ExpectedTestPreview>(
      value: async,
      onRetry: () => ref.invalidate(_expectedTestPreviewProvider(test)),
      data: (preview) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: context.colors.primary,
                size: context.dimens.iconMd,
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: Text(
                  context.l10n.testPreviewQuestionCount(
                    preview.questionCount,
                  ),
                  style: context.textStyles.bodyLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.lg),
          Text(
            context.l10n.testPreviewChaptersCovered,
            style: context.textStyles.titleSmall,
          ),
          SizedBox(height: context.dimens.sm),
          if (preview.chapterTitles.isEmpty)
            Text(
              context.l10n.testPreviewChaptersUnknown,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            )
          else
            Wrap(
              spacing: context.dimens.sm,
              runSpacing: context.dimens.sm,
              children: [
                for (final title in preview.chapterTitles)
                  Chip(
                    avatar: Icon(
                      Icons.menu_book,
                      size: context.dimens.iconSm,
                    ),
                    label: Text(title),
                  ),
              ],
            ),
          SizedBox(height: context.dimens.xl),
          AppPrimaryButton(
            label: context.l10n.testPreviewStartButton,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
