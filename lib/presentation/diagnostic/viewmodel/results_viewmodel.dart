import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/riverpod_providers.dart';
import '../../../domain/diagnostic/entities/results_summary.dart';
import 'question_bank_provider.dart';
import 'self_assessment_viewmodel.dart';
import 'test_viewmodel.dart';

final resultsProvider = FutureProvider<ResultsSummary>((ref) async {
  final questionBank = await ref.watch(questionBankProvider.future);
  final session = ref.watch(testViewModelProvider);
  final selfAssessment = ref.watch(selfAssessmentViewModelProvider);
  final calculateResults = ref.read(calculateResultsUseCaseProvider);

  return calculateResults(
    session: session,
    selfAssessment: selfAssessment,
    chapters: questionBank.chapters,
    selfAssessmentWeight: AppConfig.selfAssessmentWeight,
    testScoreWeight: AppConfig.testScoreWeight,
  );
});
