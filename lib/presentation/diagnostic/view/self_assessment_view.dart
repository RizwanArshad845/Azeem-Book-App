import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../viewmodel/question_bank_provider.dart';
import '../viewmodel/self_assessment_viewmodel.dart';
import '../widgets/chapter_confidence_slider.dart';

class SelfAssessmentView extends ConsumerWidget {
  const SelfAssessmentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionBankAsync = ref.watch(questionBankProvider);
    final ratings = ref.watch(selfAssessmentViewModelProvider);
    final notifier = ref.read(selfAssessmentViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.selfAssessmentTitle)),
      body: questionBankAsync.when(
        data: (questionBank) => Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.selfAssessmentSubtitle,
                style: TextStyle(color: context.colors.textSecondary),
              ),
              SizedBox(height: context.dimens.md),
              Expanded(
                child: ListView.builder(
                  itemCount: questionBank.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = questionBank.chapters[index];
                    return ChapterConfidenceSlider(
                      title: chapter.title,
                      rating: ratings.ratingsByChapter[chapter.chapter] ?? 3,
                      onChanged: (value) => notifier.setRating(chapter.chapter, value),
                    );
                  },
                ),
              ),
              AppButton(
                label: context.l10n.selfAssessmentStartButton,
                onPressed: () => context.push(AppRoutes.diagnosticConsent),
              ),
            ],
          ),
        ),
        loading: () => const LoadingIndicator(),
        error: (_, _) => Center(child: Text(context.l10n.commonErrorGeneric)),
      ),
    );
  }
}
