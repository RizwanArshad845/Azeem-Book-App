import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../../core/constants/app_assets.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/question_bank/entities/question_bank.dart';
import '../../../domain/question_bank/repositories/question_bank_repository.dart';
import '../models/question_bank_dto.dart';

class QuestionBankRepositoryImpl implements QuestionBankRepository {
  QuestionBank? _cached;

  @override
  Future<Result<QuestionBank>> loadQuestionBank() async {
    final cached = _cached;
    if (cached != null) return Success(cached);

    try {
      final jsonString = await rootBundle.loadString(AppAssets.questionBankJson);
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final entity = QuestionBankDto.fromJson(decoded).toEntity();
      _cached = entity;
      return Success(entity);
    } on FormatException catch (e) {
      return ResultFailure(ParsingFailure(e.message));
    } catch (e) {
      return ResultFailure(AssetLoadFailure(e.toString()));
    }
  }
}
