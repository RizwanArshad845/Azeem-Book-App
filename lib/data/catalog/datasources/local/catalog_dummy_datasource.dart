import '../../../../domain/catalog/entities/question.dart';
import '../../../../domain/catalog/entities/test.dart';
import '../../../../domain/common/result.dart';
import '../../models/board_class_dto.dart';
import '../../models/chapter_dto.dart';
import '../../models/question_dto.dart';
import '../../models/subject_dto.dart';
import '../../models/test_dto.dart';

/// In-memory dummy catalog data, structurally identical to what the real
/// API will eventually return (project_spec.md §6.1). Every method
/// simulates network latency via [Future.delayed] so viewmodels exercise
/// the same `AsyncValue` loading states they will against the real API.
abstract class CatalogDummyDataSource {
  Future<Result<List<BoardClassDto>>> getBoardClasses();

  Future<Result<List<SubjectDto>>> getSubjects(String boardClassId);

  Future<Result<List<ChapterDto>>> getChapters(String subjectId);

  Future<Result<List<TestDto>>> getTests({String? subjectId, String? chapterId});

  Future<Result<List<QuestionDto>>> getQuestions(String testId);
}

class CatalogDummyDataSourceImpl implements CatalogDummyDataSource {
  CatalogDummyDataSourceImpl() {
    _seed();
  }

  static const _latency = Duration(milliseconds: 400);

  final List<BoardClassDto> _boardClasses = [];
  final List<SubjectDto> _subjects = [];
  final List<ChapterDto> _chapters = [];
  final List<TestDto> _tests = [];
  final List<QuestionDto> _questions = [];

  int _testCounter = 0;

  @override
  Future<Result<List<BoardClassDto>>> getBoardClasses() async {
    await Future.delayed(_latency);
    return Success(List.unmodifiable(_boardClasses));
  }

  @override
  Future<Result<List<SubjectDto>>> getSubjects(String boardClassId) async {
    await Future.delayed(_latency);
    return Success(
      _subjects.where((s) => s.boardClassId == boardClassId).toList(),
    );
  }

  @override
  Future<Result<List<ChapterDto>>> getChapters(String subjectId) async {
    await Future.delayed(_latency);
    final chapters = _chapters.where((c) => c.subjectId == subjectId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return Success(chapters);
  }

  @override
  Future<Result<List<TestDto>>> getTests({
    String? subjectId,
    String? chapterId,
  }) async {
    await Future.delayed(_latency);
    final tests = _tests.where((t) {
      if (chapterId != null) return t.chapterId == chapterId;
      if (subjectId != null) return t.subjectId == subjectId;
      return true;
    }).toList();
    return Success(tests);
  }

  @override
  Future<Result<List<QuestionDto>>> getQuestions(String testId) async {
    await Future.delayed(_latency);
    return Success(_questions.where((q) => q.testId == testId).toList());
  }

  // ---------------------------------------------------------------------
  // Seed data
  // ---------------------------------------------------------------------

  void _seed() {
    _boardClasses.addAll(const [
      BoardClassDto(id: 'bc-premed', name: 'FSc Pre-Medical', isEnabled: true),
      BoardClassDto(
        id: 'bc-preeng',
        name: 'FSc Pre-Engineering',
        isEnabled: true,
      ),
      BoardClassDto(id: 'bc-matric', name: 'Matric', isEnabled: false),
    ]);

    // FSc Pre-Medical subjects.
    _buildSubject(
      subjectId: 'subj-pm-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-premed',
      chapterTitles: const [
        'Measurements',
        'Vectors and Equilibrium',
        'Motion and Force',
        'Work and Energy',
        'Circular Motion',
        'Fluid Dynamics',
      ],
    );
    _buildSubject(
      subjectId: 'subj-pm-chem',
      subjectName: 'Chemistry',
      boardClassId: 'bc-premed',
      chapterTitles: const [
        'Basic Concepts of Chemistry',
        'Experimental Techniques in Chemistry',
        'Gases',
        'Liquids and Solids',
        'Atomic Structure',
        'Chemical Bonding',
      ],
    );
    _buildSubject(
      subjectId: 'subj-pm-bio',
      subjectName: 'Biology',
      boardClassId: 'bc-premed',
      chapterTitles: const [
        'Introduction to Biology',
        'Biological Molecules',
        'Enzymes',
        'Cell Structure and Function',
        'Cell Cycle',
        'Variety of Life',
      ],
    );
    _buildSubject(
      subjectId: 'subj-pm-eng',
      subjectName: 'English',
      boardClassId: 'bc-premed',
      chapterTitles: const [
        'Grammar and Composition',
        'Comprehension Passages',
        'Translation (Urdu to English)',
        'Letter and Application Writing',
        'Precis Writing',
      ],
    );

    // FSc Pre-Engineering subjects.
    _buildSubject(
      subjectId: 'subj-pe-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-preeng',
      chapterTitles: const [
        'Measurements',
        'Vectors and Equilibrium',
        'Motion and Force',
        'Work and Energy',
        'Circular Motion',
        'Fluid Dynamics',
      ],
    );
    _buildSubject(
      subjectId: 'subj-pe-chem',
      subjectName: 'Chemistry',
      boardClassId: 'bc-preeng',
      chapterTitles: const [
        'Basic Concepts of Chemistry',
        'Experimental Techniques in Chemistry',
        'Gases',
        'Liquids and Solids',
        'Atomic Structure',
        'Chemical Bonding',
      ],
    );
    _buildSubject(
      subjectId: 'subj-pe-math',
      subjectName: 'Mathematics',
      boardClassId: 'bc-preeng',
      chapterTitles: const [
        'Number Systems',
        'Sets, Functions and Groups',
        'Matrices and Determinants',
        'Quadratic Equations',
        'Partial Fractions',
        'Sequences and Series',
      ],
    );
    _buildSubject(
      subjectId: 'subj-pe-cs',
      subjectName: 'Computer Science',
      boardClassId: 'bc-preeng',
      chapterTitles: const [
        'Introduction to Computer',
        'Computer Architecture',
        'Data Representation',
        'Number Systems and Boolean Algebra',
        'Programming Fundamentals',
      ],
    );

    // Admin schedules live tests occasionally, not continuously: exactly 3
    // tests across the whole dataset are flagged live, with a near-future
    // liveDate.
    _markLiveTests(const {
      'subj-pm-phy-ch1-test1': 5,
      'subj-pe-math-ch3-test1': 9,
      'subj-pm-chem-ch5-test2': 14,
    });
  }

  void _buildSubject({
    required String subjectId,
    required String subjectName,
    required String boardClassId,
    required List<String> chapterTitles,
  }) {
    _subjects.add(
      SubjectDto(id: subjectId, name: subjectName, boardClassId: boardClassId),
    );

    for (var i = 0; i < chapterTitles.length; i++) {
      final order = i + 1;
      final chapterTitle = chapterTitles[i];
      final chapterId = '$subjectId-ch$order';
      _chapters.add(
        ChapterDto(
          id: chapterId,
          subjectId: subjectId,
          title: chapterTitle,
          order: order,
        ),
      );

      // 2-3 tests per chapter; kinds rotate per chapter so the mix of
      // subjectWiseGuessPaper / subjectWiseSimplePaper / chapterWise
      // varies across the dataset.
      final testCount = order.isOdd ? 3 : 2;
      final kinds = _kindsForChapter(order);

      // "First chapter free" rule: for order == 1, exactly 2 tests are
      // free samples; every other chapter's tests are all non-free.
      final freeSampleBudget = order == 1 ? 2 : 0;
      var freeSamplesAssigned = 0;

      for (var t = 0; t < testCount; t++) {
        final kind = kinds[t % kinds.length];
        final testId = '$chapterId-test${t + 1}';
        final isFreeSample = freeSamplesAssigned < freeSampleBudget;
        if (isFreeSample) freeSamplesAssigned++;

        final test = TestDto(
          id: testId,
          title: _testTitle(subjectName, chapterTitle, kind, t + 1),
          kind: kind,
          boardClassId: boardClassId,
          subjectId: subjectId,
          chapterId: kind == TestKind.chapterWise ? chapterId : null,
          isFreeSample: isFreeSample,
          createdByAdminId: 'admin-1',
          createdAt: DateTime.now().subtract(Duration(days: 20 + _testCounter)),
        );
        _testCounter++;
        _tests.add(test);
        _buildQuestions(test, chapterId, chapterTitle);
      }
    }
  }

  List<TestKind> _kindsForChapter(int order) {
    const base = [
      TestKind.chapterWise,
      TestKind.subjectWiseSimplePaper,
      TestKind.subjectWiseGuessPaper,
    ];
    final shift = (order - 1) % base.length;
    return [...base.sublist(shift), ...base.sublist(0, shift)];
  }

  String _testTitle(
    String subjectName,
    String chapterTitle,
    TestKind kind,
    int index,
  ) {
    switch (kind) {
      case TestKind.chapterWise:
        return '$subjectName - $chapterTitle - Chapter Test $index';
      case TestKind.subjectWiseSimplePaper:
        return '$subjectName - Simple Paper $index ($chapterTitle focus)';
      case TestKind.subjectWiseGuessPaper:
        return '$subjectName - Guess Paper $index ($chapterTitle focus)';
    }
  }

  void _buildQuestions(TestDto test, String chapterId, String chapterTitle) {
    // 5-8 questions per test, deterministically varied by test index.
    final questionCount = 5 + (_testCounter % 4);

    for (var i = 0; i < questionCount; i++) {
      final questionId = '${test.id}-q${i + 1}';
      final slot = i % 5;

      if (slot < 3) {
        // Majority mcq (3 out of every 5 questions).
        final correctIndex = (i + _testCounter) % 4;
        _questions.add(
          QuestionDto(
            id: questionId,
            testId: test.id,
            chapterId: chapterId,
            type: QuestionType.mcq,
            questionText:
                'Q${i + 1}. Which statement correctly describes a key '
                'concept from "$chapterTitle"?',
            options: [
              '$chapterTitle - concept A',
              '$chapterTitle - concept B',
              '$chapterTitle - concept C',
              '$chapterTitle - concept D',
            ],
            correctOptionIndex: correctIndex,
          ),
        );
      } else if (slot == 3) {
        _questions.add(
          QuestionDto(
            id: questionId,
            testId: test.id,
            chapterId: chapterId,
            type: QuestionType.shortAnswer,
            questionText:
                'Q${i + 1}. Briefly explain a key idea from "$chapterTitle".',
            expectedAnswer:
                'A concise explanation covering the core definition and '
                'one example from "$chapterTitle".',
          ),
        );
      } else {
        _questions.add(
          QuestionDto(
            id: questionId,
            testId: test.id,
            chapterId: chapterId,
            type: QuestionType.longAnswer,
            questionText:
                'Q${i + 1}. Describe in detail the concepts covered in '
                '"$chapterTitle" with relevant examples.',
            expectedAnswer:
                'A detailed answer covering definitions, '
                'derivations/examples, and real-world applications '
                'relevant to "$chapterTitle".',
          ),
        );
      }
    }
  }

  void _markLiveTests(Map<String, int> testIdToDaysFromNow) {
    for (final entry in testIdToDaysFromNow.entries) {
      final index = _tests.indexWhere((t) => t.id == entry.key);
      if (index == -1) continue;
      _tests[index] = _tests[index].copyWith(
        isLive: true,
        liveDate: DateTime.now().add(Duration(days: entry.value)),
      );
    }
  }
}
