import '../../common/result.dart';
import '../entities/question_bank.dart';

abstract class QuestionBankRepository {
  Future<Result<QuestionBank>> loadQuestionBank();
}
