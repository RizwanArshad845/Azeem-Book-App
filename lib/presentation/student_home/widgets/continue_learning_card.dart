import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../../domain/study_activity/entities/last_activity.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../viewmodel/study_activity_viewmodel.dart';

/// Home's primary focus: one tap back into the last opened subject hub,
/// test list or ebook. Renders nothing until something has been recorded,
/// or when the recorded subject isn't among the student's enrolled subjects
/// (e.g. another account used this device).
class ContinueLearningCard extends ConsumerWidget {
  const ContinueLearningCard({super.key});

  void _open(BuildContext context, LastActivity activity, String? name) {
    switch (activity.kind) {
      case LastActivityKind.subjectHub:
        context.push(AppRoutes.subjectHubPath(activity.subjectId), extra: name);
      case LastActivityKind.test:
        final chapterId = activity.chapterId;
        if (chapterId == null) {
          context.push(
            AppRoutes.subjectHubPath(activity.subjectId),
            extra: name,
          );
        } else {
          context.push(
            AppRoutes.studentHomeChapterTests
                .replaceFirst(':subjectId', activity.subjectId)
                .replaceFirst(':chapterId', chapterId),
          );
        }
      case LastActivityKind.ebook:
        context.push(
          activity.offline
              ? AppRoutes.ebookReaderOfflinePath(activity.subjectId)
              : AppRoutes.ebookReaderPath(activity.subjectId),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(lastActivityProvider);
    final subjects = ref.watch(enrolledSubjectsProvider).value;
    if (activity == null || subjects == null) return const SizedBox.shrink();
    final subject = subjects
        .where((s) => s.id == activity.subjectId)
        .firstOrNull;
    if (subject == null) return const SizedBox.shrink();

    final subjectName = context.l10n.localizedSubjectName(subject.name);
    final String title;
    final String subtitle;
    switch (activity.kind) {
      case LastActivityKind.subjectHub:
        title = subjectName;
        subtitle = context.l10n.stuActivitySubject;
      case LastActivityKind.test:
        title = activity.testTitle ?? subjectName;
        subtitle = '${context.l10n.stuActivityTest} · $subjectName';
      case LastActivityKind.ebook:
        final page = ref
            .read(studyActivityRepositoryProvider)
            .getLastEbookPage(activity.subjectId);
        title = subjectName;
        subtitle = page == null
            ? context.l10n.stuActivityEbook
            : context.l10n.stuActivityEbookPage(page);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.dimens.lg,
        context.dimens.lg,
        context.dimens.lg,
        0,
      ),
      child: FadeSlideIn(
        child: _card(context, activity, subject.name, title, subtitle),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    LastActivity activity,
    String rawSubjectName,
    String title,
    String subtitle,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.stuContinueTitle,
            style: context.textStyles.labelLarge?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.dimens.sm),
          Row(
            children: [
              IllustrationThumbnail(
                imageAsset: subjectIllustration(rawSubjectName),
                fallbackIcon: subjectIcon(rawSubjectName),
                size: context.dimens.avatarLg,
              ),
              SizedBox(width: context.dimens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: context.dimens.xs / 2),
                    Row(
                      children: [
                        Icon(
                          switch (activity.kind) {
                            LastActivityKind.subjectHub =>
                              Icons.menu_book_outlined,
                            LastActivityKind.test => Icons.edit_note_rounded,
                            LastActivityKind.ebook =>
                              Icons.auto_stories_outlined,
                          },
                          size: context.dimens.iconSm,
                          color: context.colors.textSecondary,
                        ),
                        SizedBox(width: context.dimens.xs),
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.md),
          AppButton(
            label: context.l10n.stuContinueButton,
            icon: Icons.play_arrow_rounded,
            onPressed: () => _open(context, activity, rawSubjectName),
          ),
        ],
      ),
    );
  }
}
