import '../../../../domain/catalog/entities/question.dart';
import '../../../../domain/catalog/entities/test.dart';
import '../../../../domain/common/result.dart';
import '../../models/board_class_dto.dart';
import '../../models/chapter_dto.dart';
import '../../models/class_level_dto.dart';
import '../../models/question_dto.dart';
import '../../models/subject_dto.dart';
import '../../models/test_dto.dart';

/// In-memory dummy catalog data, structurally identical to what the real
/// API will eventually return (project_spec.md §6.1). Every method
/// simulates network latency via [Future.delayed] so viewmodels exercise
/// the same `AsyncValue` loading states they will against the real API.
abstract class CatalogDummyDataSource {
  Future<Result<List<ClassLevelDto>>> getClassLevels();

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

  final List<ClassLevelDto> _classLevels = [];
  final List<BoardClassDto> _boardClasses = [];
  final List<SubjectDto> _subjects = [];
  final List<ChapterDto> _chapters = [];
  final List<TestDto> _tests = [];
  final List<QuestionDto> _questions = [];

  int _testCounter = 0;

  @override
  Future<Result<List<ClassLevelDto>>> getClassLevels() async {
    await Future.delayed(_latency);
    return Success(List.unmodifiable(_classLevels));
  }

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

  /// Class levels are the coarse grade axis ("9th"..."12th"); `BoardClass`
  /// leaves nest under them and either represent the class level directly
  /// (9th/10th, which don't split) or a group within it (11th/12th's
  /// Pre-Medical/Pre-Engineering split) — see project_spec.md §9.2
  /// `ClassLevel` prose for the full rationale.
  static const _premedChapterTitles = <String, List<String>>{
    'Physics': [
      'Measurements',
      'Vectors and Equilibrium',
      'Motion and Force',
      'Work and Energy',
      'Circular Motion',
      'Fluid Dynamics',
    ],
    'Chemistry': [
      'Basic Concepts of Chemistry',
      'Experimental Techniques in Chemistry',
      'Gases',
      'Liquids and Solids',
      'Atomic Structure',
      'Chemical Bonding',
    ],
    'Biology': [
      'Introduction to Biology',
      'Biological Molecules',
      'Enzymes',
      'Cell Structure and Function',
      'Cell Cycle',
      'Variety of Life',
    ],
    'English': [
      'Grammar and Composition',
      'Comprehension Passages',
      'Translation (Urdu to English)',
      'Letter and Application Writing',
      'Precis Writing',
    ],
  };

  static const _preengChapterTitles = <String, List<String>>{
    'Physics': [
      'Measurements',
      'Vectors and Equilibrium',
      'Motion and Force',
      'Work and Energy',
      'Circular Motion',
      'Fluid Dynamics',
    ],
    'Chemistry': [
      'Basic Concepts of Chemistry',
      'Experimental Techniques in Chemistry',
      'Gases',
      'Liquids and Solids',
      'Atomic Structure',
      'Chemical Bonding',
    ],
    'Mathematics': [
      'Number Systems',
      'Sets, Functions and Groups',
      'Matrices and Determinants',
      'Quadratic Equations',
      'Partial Fractions',
      'Sequences and Series',
    ],
    'Computer Science': [
      'Introduction to Computer',
      'Computer Architecture',
      'Data Representation',
      'Number Systems and Boolean Algebra',
      'Programming Fundamentals',
    ],
  };

  /// Minimal placeholder subject set for 9th/10th/Matric — no existing
  /// content for these grades yet, so a short demo chapter list per subject
  /// is enough to exercise the flow end-to-end.
  static const _lowerGradeChapterTitles = <String, List<String>>{
    'Math': ['Real Numbers', 'Algebraic Expressions', 'Linear Equations', 'Geometry Basics'],
    'Science': ['Matter and its States', 'Force and Motion', 'Energy', 'The Living World'],
    'English': ['Grammar Basics', 'Reading Comprehension', 'Essay Writing'],
    'Urdu': ['Grammar (Qawaid)', 'Nasr (Prose)', 'Nazm (Poetry)'],
  };

  /// Minimal placeholder subject set for the new 11th/12th "I.Com" stream
  /// (CLAUDE.md's strict stream list).
  static const _icomChapterTitles = <String, List<String>>{
    'Principles of Accounting': [
      'Introduction to Accounting',
      'Journal and Ledger',
      'Trial Balance',
      'Financial Statements',
    ],
    'Business Mathematics': [
      'Ratio and Proportion',
      'Interest and Annuities',
      'Linear Equations',
    ],
    'Economics': [
      'Basic Concepts of Economics',
      'Demand and Supply',
      'Money and Banking',
    ],
  };

  /// Minimal placeholder subject set for the new 11th/12th "F.A" stream.
  static const _faChapterTitles = <String, List<String>>{
    'Education': [
      'Introduction to Education',
      'Aims of Education',
      'Methods of Teaching',
    ],
    'Civics': [
      'Citizenship',
      'Fundamental Rights',
      'Local Government',
    ],
    'English': [
      'Grammar and Composition',
      'Comprehension Passages',
      'Essay Writing',
    ],
  };

  /// Minimal placeholder subject set for the new 11th/12th "I.C.S" stream.
  static const _icsChapterTitles = <String, List<String>>{
    'Computer Science': [
      'Introduction to Computer',
      'Number Systems',
      'Programming Fundamentals',
      'Data Structures Basics',
    ],
    'Mathematics': [
      'Number Systems',
      'Sets, Functions and Groups',
      'Matrices and Determinants',
    ],
    'Physics': [
      'Measurements',
      'Vectors and Equilibrium',
      'Motion and Force',
    ],
  };

  void _seed() {
    // Class list is strictly 9th, Matric, 1st year, 2nd year (all selectable,
    // no "Coming soon"). "10th" is removed entirely as a class level; its
    // `bc-10` board class + subjects remain seeded but are unreachable from
    // the selector. `cl-11`/`cl-12` ids kept as-is to avoid churn elsewhere;
    // only their display `name` is "1st year"/"2nd year".
    _classLevels.addAll(const [
      ClassLevelDto(id: 'cl-9', name: '9th', isEnabled: true),
      ClassLevelDto(id: 'cl-matric', name: 'Matric', isEnabled: true),
      ClassLevelDto(id: 'cl-11', name: '1st year', isEnabled: true),
      ClassLevelDto(id: 'cl-12', name: '2nd year', isEnabled: true),
    ]);

    _boardClasses.addAll(const [
      BoardClassDto(
        id: 'bc-9',
        name: '9th',
        classLevelId: 'cl-9',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-10',
        name: '10th',
        classLevelId: 'cl-10',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-11-premed',
        name: 'Pre-Medical',
        classLevelId: 'cl-11',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-11-preeng',
        name: 'Pre-Engineering',
        classLevelId: 'cl-11',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-11-icom',
        name: 'I.Com',
        classLevelId: 'cl-11',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-11-fa',
        name: 'F.A',
        classLevelId: 'cl-11',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-11-ics',
        name: 'I.C.S',
        classLevelId: 'cl-11',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-12-premed',
        name: 'Pre-Medical',
        classLevelId: 'cl-12',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-12-preeng',
        name: 'Pre-Engineering',
        classLevelId: 'cl-12',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-12-icom',
        name: 'I.Com',
        classLevelId: 'cl-12',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-12-fa',
        name: 'F.A',
        classLevelId: 'cl-12',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-12-ics',
        name: 'I.C.S',
        classLevelId: 'cl-12',
        isEnabled: true,
      ),
      BoardClassDto(
        id: 'bc-matric',
        name: 'Matric',
        classLevelId: 'cl-matric',
        isEnabled: true,
      ),
    ]);

    // 11th/12th Pre-Medical subjects — identical content duplicated per
    // board-class leaf (subject ids are unique per leaf since
    // `getSubjects(boardClassId)` filters by `SubjectDto.boardClassId`).
    _buildSubject(
      subjectId: 'subj-11pm-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-11-premed',
      chapterTitles: _premedChapterTitles['Physics']!,
    );
    _buildSubject(
      subjectId: 'subj-11pm-chem',
      subjectName: 'Chemistry',
      boardClassId: 'bc-11-premed',
      chapterTitles: _premedChapterTitles['Chemistry']!,
    );
    _buildSubject(
      subjectId: 'subj-11pm-bio',
      subjectName: 'Biology',
      boardClassId: 'bc-11-premed',
      chapterTitles: _premedChapterTitles['Biology']!,
    );
    _buildSubject(
      subjectId: 'subj-11pm-eng',
      subjectName: 'English',
      boardClassId: 'bc-11-premed',
      chapterTitles: _premedChapterTitles['English']!,
    );

    _buildSubject(
      subjectId: 'subj-12pm-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-12-premed',
      chapterTitles: _premedChapterTitles['Physics']!,
    );
    _buildSubject(
      subjectId: 'subj-12pm-chem',
      subjectName: 'Chemistry',
      boardClassId: 'bc-12-premed',
      chapterTitles: _premedChapterTitles['Chemistry']!,
    );
    _buildSubject(
      subjectId: 'subj-12pm-bio',
      subjectName: 'Biology',
      boardClassId: 'bc-12-premed',
      chapterTitles: _premedChapterTitles['Biology']!,
    );
    _buildSubject(
      subjectId: 'subj-12pm-eng',
      subjectName: 'English',
      boardClassId: 'bc-12-premed',
      chapterTitles: _premedChapterTitles['English']!,
    );

    // 11th/12th Pre-Engineering subjects — identical content duplicated per
    // board-class leaf.
    _buildSubject(
      subjectId: 'subj-11pe-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-11-preeng',
      chapterTitles: _preengChapterTitles['Physics']!,
    );
    _buildSubject(
      subjectId: 'subj-11pe-chem',
      subjectName: 'Chemistry',
      boardClassId: 'bc-11-preeng',
      chapterTitles: _preengChapterTitles['Chemistry']!,
    );
    _buildSubject(
      subjectId: 'subj-11pe-math',
      subjectName: 'Mathematics',
      boardClassId: 'bc-11-preeng',
      chapterTitles: _preengChapterTitles['Mathematics']!,
    );
    _buildSubject(
      subjectId: 'subj-11pe-cs',
      subjectName: 'Computer Science',
      boardClassId: 'bc-11-preeng',
      chapterTitles: _preengChapterTitles['Computer Science']!,
    );

    _buildSubject(
      subjectId: 'subj-12pe-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-12-preeng',
      chapterTitles: _preengChapterTitles['Physics']!,
    );
    _buildSubject(
      subjectId: 'subj-12pe-chem',
      subjectName: 'Chemistry',
      boardClassId: 'bc-12-preeng',
      chapterTitles: _preengChapterTitles['Chemistry']!,
    );
    _buildSubject(
      subjectId: 'subj-12pe-math',
      subjectName: 'Mathematics',
      boardClassId: 'bc-12-preeng',
      chapterTitles: _preengChapterTitles['Mathematics']!,
    );
    _buildSubject(
      subjectId: 'subj-12pe-cs',
      subjectName: 'Computer Science',
      boardClassId: 'bc-12-preeng',
      chapterTitles: _preengChapterTitles['Computer Science']!,
    );

    // 11th/12th I.Com subjects — identical content duplicated per
    // board-class leaf.
    _buildSubject(
      subjectId: 'subj-11icom-acc',
      subjectName: 'Principles of Accounting',
      boardClassId: 'bc-11-icom',
      chapterTitles: _icomChapterTitles['Principles of Accounting']!,
    );
    _buildSubject(
      subjectId: 'subj-11icom-math',
      subjectName: 'Business Mathematics',
      boardClassId: 'bc-11-icom',
      chapterTitles: _icomChapterTitles['Business Mathematics']!,
    );
    _buildSubject(
      subjectId: 'subj-11icom-eco',
      subjectName: 'Economics',
      boardClassId: 'bc-11-icom',
      chapterTitles: _icomChapterTitles['Economics']!,
    );

    _buildSubject(
      subjectId: 'subj-12icom-acc',
      subjectName: 'Principles of Accounting',
      boardClassId: 'bc-12-icom',
      chapterTitles: _icomChapterTitles['Principles of Accounting']!,
    );
    _buildSubject(
      subjectId: 'subj-12icom-math',
      subjectName: 'Business Mathematics',
      boardClassId: 'bc-12-icom',
      chapterTitles: _icomChapterTitles['Business Mathematics']!,
    );
    _buildSubject(
      subjectId: 'subj-12icom-eco',
      subjectName: 'Economics',
      boardClassId: 'bc-12-icom',
      chapterTitles: _icomChapterTitles['Economics']!,
    );

    // 11th/12th F.A subjects — identical content duplicated per
    // board-class leaf.
    _buildSubject(
      subjectId: 'subj-11fa-edu',
      subjectName: 'Education',
      boardClassId: 'bc-11-fa',
      chapterTitles: _faChapterTitles['Education']!,
    );
    _buildSubject(
      subjectId: 'subj-11fa-civ',
      subjectName: 'Civics',
      boardClassId: 'bc-11-fa',
      chapterTitles: _faChapterTitles['Civics']!,
    );
    _buildSubject(
      subjectId: 'subj-11fa-eng',
      subjectName: 'English',
      boardClassId: 'bc-11-fa',
      chapterTitles: _faChapterTitles['English']!,
    );

    _buildSubject(
      subjectId: 'subj-12fa-edu',
      subjectName: 'Education',
      boardClassId: 'bc-12-fa',
      chapterTitles: _faChapterTitles['Education']!,
    );
    _buildSubject(
      subjectId: 'subj-12fa-civ',
      subjectName: 'Civics',
      boardClassId: 'bc-12-fa',
      chapterTitles: _faChapterTitles['Civics']!,
    );
    _buildSubject(
      subjectId: 'subj-12fa-eng',
      subjectName: 'English',
      boardClassId: 'bc-12-fa',
      chapterTitles: _faChapterTitles['English']!,
    );

    // 11th/12th I.C.S subjects — identical content duplicated per
    // board-class leaf.
    _buildSubject(
      subjectId: 'subj-11ics-cs',
      subjectName: 'Computer Science',
      boardClassId: 'bc-11-ics',
      chapterTitles: _icsChapterTitles['Computer Science']!,
    );
    _buildSubject(
      subjectId: 'subj-11ics-math',
      subjectName: 'Mathematics',
      boardClassId: 'bc-11-ics',
      chapterTitles: _icsChapterTitles['Mathematics']!,
    );
    _buildSubject(
      subjectId: 'subj-11ics-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-11-ics',
      chapterTitles: _icsChapterTitles['Physics']!,
    );

    _buildSubject(
      subjectId: 'subj-12ics-cs',
      subjectName: 'Computer Science',
      boardClassId: 'bc-12-ics',
      chapterTitles: _icsChapterTitles['Computer Science']!,
    );
    _buildSubject(
      subjectId: 'subj-12ics-math',
      subjectName: 'Mathematics',
      boardClassId: 'bc-12-ics',
      chapterTitles: _icsChapterTitles['Mathematics']!,
    );
    _buildSubject(
      subjectId: 'subj-12ics-phy',
      subjectName: 'Physics',
      boardClassId: 'bc-12-ics',
      chapterTitles: _icsChapterTitles['Physics']!,
    );

    // 9th/10th subjects — minimal placeholder content (no group split).
    _buildSubject(
      subjectId: 'subj-9-math',
      subjectName: 'Math',
      boardClassId: 'bc-9',
      chapterTitles: _lowerGradeChapterTitles['Math']!,
    );
    _buildSubject(
      subjectId: 'subj-9-sci',
      subjectName: 'Science',
      boardClassId: 'bc-9',
      chapterTitles: _lowerGradeChapterTitles['Science']!,
    );
    _buildSubject(
      subjectId: 'subj-9-eng',
      subjectName: 'English',
      boardClassId: 'bc-9',
      chapterTitles: _lowerGradeChapterTitles['English']!,
    );
    _buildSubject(
      subjectId: 'subj-9-urdu',
      subjectName: 'Urdu',
      boardClassId: 'bc-9',
      chapterTitles: _lowerGradeChapterTitles['Urdu']!,
    );

    _buildSubject(
      subjectId: 'subj-10-math',
      subjectName: 'Math',
      boardClassId: 'bc-10',
      chapterTitles: _lowerGradeChapterTitles['Math']!,
    );
    _buildSubject(
      subjectId: 'subj-10-sci',
      subjectName: 'Science',
      boardClassId: 'bc-10',
      chapterTitles: _lowerGradeChapterTitles['Science']!,
    );
    _buildSubject(
      subjectId: 'subj-10-eng',
      subjectName: 'English',
      boardClassId: 'bc-10',
      chapterTitles: _lowerGradeChapterTitles['English']!,
    );
    _buildSubject(
      subjectId: 'subj-10-urdu',
      subjectName: 'Urdu',
      boardClassId: 'bc-10',
      chapterTitles: _lowerGradeChapterTitles['Urdu']!,
    );

    // Matric subjects — minimal placeholder content (no group split), same
    // demo chapter list as 9th/10th.
    _buildSubject(
      subjectId: 'subj-matric-math',
      subjectName: 'Math',
      boardClassId: 'bc-matric',
      chapterTitles: _lowerGradeChapterTitles['Math']!,
    );
    _buildSubject(
      subjectId: 'subj-matric-sci',
      subjectName: 'Science',
      boardClassId: 'bc-matric',
      chapterTitles: _lowerGradeChapterTitles['Science']!,
    );
    _buildSubject(
      subjectId: 'subj-matric-eng',
      subjectName: 'English',
      boardClassId: 'bc-matric',
      chapterTitles: _lowerGradeChapterTitles['English']!,
    );
    _buildSubject(
      subjectId: 'subj-matric-urdu',
      subjectName: 'Urdu',
      boardClassId: 'bc-matric',
      chapterTitles: _lowerGradeChapterTitles['Urdu']!,
    );

    // Admin schedules live tests occasionally, not continuously: exactly 3
    // tests across the whole dataset are flagged live, with a near-future
    // liveDate. Two under bc-11-premed, one under bc-12-preeng (arbitrary
    // choice — just needs to stay "exactly 3 live tests total").
    _markLiveTests(const {
      'subj-11pm-phy-ch1-test1': 5,
      'subj-11pm-chem-ch5-test2': 14,
      'subj-12pe-math-ch3-test1': 9,
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

        // Denormalize stats from the questions just seeded for this test so
        // list cards / result screen can render count, duration and marks
        // without loading every question.
        final testQuestions = _questions.where((q) => q.testId == testId);
        final totalMarks = testQuestions.fold<int>(0, (sum, q) => sum + q.marks);
        final index = _tests.indexWhere((t) => t.id == testId);
        _tests[index] = _tests[index].copyWith(
          questionCount: testQuestions.length,
          totalMarks: totalMarks,
          // ~2 minutes per mark, rounded up to a tidy multiple of 5, min 10.
          durationMinutes: ((totalMarks * 2 / 5).ceil() * 5).clamp(10, 240).toInt(),
        );
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
            marks: 1,
            solutionExplanation:
                'The correct answer relates to "$chapterTitle" because it '
                'reflects the core definition covered in that chapter — '
                'review the "$chapterTitle" notes for the full reasoning.',
          ),
        );
      } else if (slot == 3) {
        _questions.add(
          QuestionDto(
            id: questionId,
            testId: test.id,
            chapterId: chapterId,
            type: QuestionType.shortAnswer,
            marks: 2,
            questionText:
                'Q${i + 1}. Briefly explain a key idea from "$chapterTitle".',
            expectedAnswer:
                'A concise explanation covering the core definition and '
                'one example from "$chapterTitle".',
            solutionExplanation:
                'A strong answer relates to "$chapterTitle" because it '
                'names the core definition and gives one concrete example '
                'from that chapter.',
          ),
        );
      } else {
        _questions.add(
          QuestionDto(
            id: questionId,
            testId: test.id,
            chapterId: chapterId,
            type: QuestionType.longAnswer,
            marks: 5,
            questionText:
                'Q${i + 1}. Describe in detail the concepts covered in '
                '"$chapterTitle" with relevant examples.',
            expectedAnswer:
                'A detailed answer covering definitions, '
                'derivations/examples, and real-world applications '
                'relevant to "$chapterTitle".',
            solutionExplanation:
                'A complete answer relates to "$chapterTitle" because it '
                'walks through the definitions, derivations/examples, and '
                'real-world applications expected for that chapter.',
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
