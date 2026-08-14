import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/diagnostic/entities/self_assessment_ratings.dart';
import 'question_bank_provider.dart';

class SelfAssessmentViewModel extends Notifier<SelfAssessmentRatings> {
  @override
  SelfAssessmentRatings build() {
    final chapters = ref.watch(questionBankProvider).value?.chapters ?? const [];
    return SelfAssessmentRatings(
      ratingsByChapter: {for (final c in chapters) c.chapter: 3},
    );
  }

  void setRating(int chapter, int rating) {
    state = state.copyWith(
      ratingsByChapter: {...state.ratingsByChapter, chapter: rating},
    );
  }
}

final selfAssessmentViewModelProvider =
    NotifierProvider<SelfAssessmentViewModel, SelfAssessmentRatings>(
        SelfAssessmentViewModel.new);
