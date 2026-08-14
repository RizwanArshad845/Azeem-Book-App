import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/question_bank/entities/question_bank.dart';

/// The repository caches the parsed asset after the first load, so watching
/// this provider from multiple screens (self-assessment, test, results)
/// does not re-read/re-parse the JSON each time.
final questionBankProvider = FutureProvider<QuestionBank>((ref) async {
  final repo = ref.watch(questionBankRepositoryProvider);
  final result = await repo.loadQuestionBank();
  return result.when(
    success: (data) => data,
    failure: (failure) => throw Exception(failure.message),
  );
});
