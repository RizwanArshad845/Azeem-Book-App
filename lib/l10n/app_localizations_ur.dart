// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'عظیم پبلیکیشنز';

  @override
  String get splashBrandName => 'عظیم';

  @override
  String get splashTagline => 'پبلیکیشنز';

  @override
  String get commonNext => 'آگے';

  @override
  String get commonBack => 'پیچھے';

  @override
  String get commonContinue => 'جاری رکھیں';

  @override
  String get commonSkip => 'چھوڑیں';

  @override
  String get commonCancel => 'منسوخ کریں';

  @override
  String get commonConfirm => 'تائید کریں';

  @override
  String get commonRetry => 'دوبارہ کوشش کریں';

  @override
  String get commonComingSoon => 'عنقریب';

  @override
  String get commonRequiredField => 'یہ خانہ ضروری ہے';

  @override
  String get commonErrorGeneric => 'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get commonSave => 'محفوظ کریں';

  @override
  String get commonSearch => 'تلاش کریں';

  @override
  String get commonViewAll => 'سب دیکھیں';

  @override
  String get roleSelectionTitle => 'عظیم پبلیکیشنز میں خوش آمدید';

  @override
  String get roleSelectionSubtitle =>
      'براہ کرم جاری رکھنے کے لیے اپنا کردار منتخب کریں';

  @override
  String get roleStudent => 'طالب علم';

  @override
  String get roleStudentDesc =>
      'امتحانات کی تیاری کریں، ٹیسٹ دیں، پیشرفت دیکھیں';

  @override
  String get roleTeacher => 'استاد';

  @override
  String get roleTeacherDesc =>
      'طلباء کا انتظام کریں، آمدنی دیکھیں، رہنمائی کریں';

  @override
  String get roleSelectRequired =>
      'کوڈ کی درخواست سے پہلے اپنا کردار منتخب کریں۔';

  @override
  String get otpRequestRequired => 'تصدیق سے پہلے تصدیقی کوڈ کی درخواست کریں۔';

  @override
  String get phoneTitle => 'اپنا فون نمبر درج کریں';

  @override
  String get phoneWelcomeTitle => 'عظیم بکس میں خوش آمدید!';

  @override
  String get phoneSubtitle => 'ہم اس نمبر پر تصدیقی کوڈ بھیجیں گے';

  @override
  String get phoneLabel => 'فون نمبر';

  @override
  String get phoneHint => '03001234567';

  @override
  String get phoneInvalid =>
      'ایک درست 11 ہندسوں کا فون نمبر درج کریں جو 03 سے شروع ہو';

  @override
  String get phoneContinueButton => 'کوڈ بھیجیں';

  @override
  String get otpTitle => 'اپنے نمبر کی تصدیق کریں';

  @override
  String otpSubtitle(String phone) {
    return '$phone پر بھیجا گیا 4 ہندسوں کا کوڈ درج کریں';
  }

  @override
  String get otpVerifyButton => 'تصدیق کریں';

  @override
  String get otpIncorrect => 'غلط کوڈ۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get otpTooManyAttempts => 'بہت سی کوششیں۔ دوبارہ شروع ہو رہا ہے...';

  @override
  String get personalInfoTitle => 'ذاتی معلومات';

  @override
  String get personalInfoSubtitle =>
      'اپنے تعلیمی تجربے کو بہتر بنانے میں ہماری مدد کریں';

  @override
  String get personalInfoAcademicSection => 'تعلیمی تفصیلات';

  @override
  String get personalInfoOptionalSection => 'اختیاری';

  @override
  String get nameLabel => 'مکمل نام';

  @override
  String get nameHint => 'مثال: علی رضا';

  @override
  String get cityLabel => 'شہر';

  @override
  String get cityHint => 'مثال: لاہور';

  @override
  String get collegeLabel => 'کالج';

  @override
  String get collegeHint => 'اپنا کالج تلاش کریں';

  @override
  String get classLevelLabel => 'کلاس لیول';

  @override
  String get classCodeLabel => 'ٹیچر کا کلاس کوڈ (اختیاری)';

  @override
  String get classCodeHint => '6 حروف کا کوڈ';

  @override
  String get classCodeNote =>
      'آپ اسے بعد میں اپنے پروفائل سے بھی شامل کر سکتے ہیں';

  @override
  String get studentNameEntryTitle => 'آپ کا نام کیا ہے؟';

  @override
  String get studentNameEntrySubtitle =>
      'اساتذہ اور ایڈمن آپ کو اسی نام سے دیکھیں گے';

  @override
  String get campusSelectTitle => 'اپنا کیمپس منتخب کریں';

  @override
  String get campusSelectSubtitle => 'وہ کیمپس منتخب کریں جس میں آپ داخل ہیں';

  @override
  String get boardClassSelectTitle => 'بورڈ اور کلاس منتخب کریں';

  @override
  String get boardClassSelectSubtitle =>
      'اپنا تعلیمی بورڈ اور موجودہ کلاس منتخب کریں';

  @override
  String get subjectTeacherSelectTitle => 'مضامین اور اساتذہ منتخب کریں';

  @override
  String get subjectTeacherSelectSubtitle =>
      'اپنے مضامین اور مقرر کردہ اساتذہ کا انتخاب کریں';

  @override
  String get teacherSignupTitle => 'ٹیچر رجسٹریشن';

  @override
  String get teacherSignupSubtitle =>
      'ٹیچر کے طور پر رجسٹر ہونے کے لیے اپنی تفصیلات بھریں';

  @override
  String get teacherPendingTitle => 'منظوری کا انتظار';

  @override
  String get teacherPendingMessage =>
      'آپ کی ٹیچر کی درخواست جمع کر دی گئی ہے اور عظیم پبلیکیشنز کے زیر جائزہ ہے۔';

  @override
  String get teacherPendingNote =>
      'ہماری ٹیم کی طرف سے تصدیق کے بعد آپ کو مکمل رسائی مل جائے گی۔';

  @override
  String homeGreeting(String name) {
    return 'السلام علیکم، $name';
  }

  @override
  String get homeDiagnosticTestTitle => 'تشخیصی ٹیسٹ';

  @override
  String get homeDiagnosticTestSubtitle => 'مفت · کمپیوٹر سائنس';

  @override
  String get homeAiGuessPapersTitle => 'اے آئی گیس پیپرز';

  @override
  String get homeAiGuessPapersSubtitle => 'عنقریب';

  @override
  String get homeStudyPlanTitle => 'سٹڈی پلان';

  @override
  String get homeStudyPlanSubtitle => 'عنقریب';

  @override
  String get homeNavHome => 'ہوم';

  @override
  String get homeNavProgress => 'پیشرفت';

  @override
  String get homeNavCart => 'کارٹ';

  @override
  String get homeNavProfile => 'پروفائل';

  @override
  String get subjectPickerTitle => 'مضمون منتخب کریں';

  @override
  String get subjectPickerComputerScience => 'کمپیوٹر سائنس';

  @override
  String get selfAssessmentTitle => 'اپنے اعتماد کی درجہ بندی کریں';

  @override
  String get selfAssessmentSubtitle =>
      'آپ ہر باب میں کتنا اعتماد محسوس کرتے ہیں؟';

  @override
  String get selfAssessmentStartButton => 'ٹیسٹ شروع کریں';

  @override
  String get consentTitle => 'شروع کرنے سے پہلے';

  @override
  String get consentBody => 'اس ٹیسٹ کی سکرین ریکارڈنگ ہوگی۔';

  @override
  String get consentCheckboxLabel => 'میں سمجھتا ہوں اور ریکارڈنگ سے متفق ہوں';

  @override
  String get consentStartButton => 'ٹیسٹ شروع کریں';

  @override
  String get testRecLabel => 'ریکارڈنگ';

  @override
  String testProgressLabel(int current, int total) {
    return 'سوال $current/$total';
  }

  @override
  String get testPreviousButton => 'پچھلا';

  @override
  String get testNextButton => 'اگلا';

  @override
  String get testSubmitButton => 'ٹیسٹ جمع کروائیں';

  @override
  String get testJumpToQuestion => 'سوال پر جائیں';

  @override
  String get testShortAnswerHint => 'اپنا جواب یہاں ٹائپ کریں';

  @override
  String get testExitDialogTitle => 'ٹیسٹ چھوڑیں؟';

  @override
  String get testExitDialogBody =>
      'اگر آپ ابھی چھوڑ دیں گے تو آپ کی پیشرفت ضائع ہو جائے گی۔';

  @override
  String get testExitDialogConfirm => 'چھوڑیں';

  @override
  String get testQuestionTypeMcq => 'کثیر انتخابی سوال';

  @override
  String get testQuestionTypeShortAnswer => 'مختصر جواب';

  @override
  String get testQuestionTypeLongAnswer => 'تفصیلی جواب';

  @override
  String get testPreviewTitle => 'ٹیسٹ کا جائزہ';

  @override
  String testPreviewQuestionCount(int count) {
    return '$count سوالات';
  }

  @override
  String get testPreviewChaptersCovered => 'شامل ابواب';

  @override
  String get testPreviewChaptersUnknown =>
      'اس ٹیسٹ کے لیے باب کی تفصیلات ابھی دستیاب نہیں ہیں۔';

  @override
  String get testPreviewStartButton => 'ٹیسٹ شروع کریں';

  @override
  String get testResultsBreakdownTitle => 'جوابات کی تفصیل';

  @override
  String get testResultsSolutionLabel => 'حل';

  @override
  String get testResultsReattemptButton => 'دوبارہ کوشش کریں';

  @override
  String get resultsTitle => 'آپ کے نتائج';

  @override
  String get resultsOverallReadiness => 'مجموعی تیاری';

  @override
  String get resultsChapterScores => 'باب وار سکور';

  @override
  String get resultsStudyPlanCta => 'ذاتی سٹڈی پلان حاصل کریں';

  @override
  String get resultsReturnHome => 'ہوم پر واپس جائیں';

  @override
  String get cartTitle => 'شاپنگ کارٹ';

  @override
  String get cartEmpty => 'آپ کا کارٹ خالی ہے';

  @override
  String get cartCheckout => 'چیک آؤٹ پر جائیں';

  @override
  String get cartTotal => 'کل رقم';

  @override
  String get checkoutTitle => 'چیک آؤٹ';

  @override
  String get checkoutPaymentMethod => 'ادائیگی کا طریقہ';

  @override
  String get checkoutPayNow => 'ابھی ادائیگی کریں';

  @override
  String get checkoutSuccess => 'خریداری کامیاب رہی!';

  @override
  String get progressTitle => 'آپ کی پیشرفت';

  @override
  String get progressOverall => 'مجموعی سکور';

  @override
  String get progressTestsTaken => 'دیے گئے ٹیسٹ';

  @override
  String get progressViewOverall => 'مجموعی';

  @override
  String get progressViewPerSubject => 'مضمون کے لحاظ سے';

  @override
  String get progressMasteryTitle => 'مجموعی مہارت';

  @override
  String progressMasteryTestsCount(int count) {
    return '$count ٹیسٹ دیے گئے';
  }

  @override
  String get progressSubjectEmpty =>
      'ابھی تک مضمون کے لحاظ سے کوئی ڈیٹا موجود نہیں۔ مختلف مضامین میں ٹیسٹ دیں تاکہ یہاں تفصیل نظر آئے۔';

  @override
  String get progressSubjectAvgScore => 'اوسط سکور';

  @override
  String get progressSubjectWeakChapters => 'کمزور';

  @override
  String get progressSubjectAverageChapters => 'اوسط';

  @override
  String get progressSubjectStrongChapters => 'مضبوط';

  @override
  String progressSubjectTestsCount(int count) {
    return '$count ٹیسٹ';
  }

  @override
  String get teacherOverviewTitle => 'ٹیچر ڈیش بورڈ';

  @override
  String get teacherOverviewStudents => 'شامل شدہ طلباء';

  @override
  String get teacherOverviewEarnings => 'کل آمدنی';

  @override
  String get teacherOverviewQuickActions => 'فوری اقدامات';

  @override
  String get teacherStudentsTitle => 'میرے طلباء';

  @override
  String get teacherEarningsTitle => 'آمدنی اور کمیشن';

  @override
  String get liveTestTitle => 'لائیو ٹیسٹ رجسٹریشن';

  @override
  String get liveTestRegister => 'ابھی رجسٹر ہوں';

  @override
  String get liveTestRegistered => 'رجسٹرڈ';

  @override
  String get notificationsTitle => 'اطلاعات';

  @override
  String get notificationsEmpty => 'کوئی نئی اطلاع نہیں';

  @override
  String get profileTitle => 'پروفائل';

  @override
  String get profileLanguage => 'زبان / Language';

  @override
  String get profileEnglish => 'English';

  @override
  String get profileUrdu => 'اردو (Urdu)';

  @override
  String get profileLogout => 'لاگ آؤٹ';

  @override
  String get profileLogoutConfirmTitle => 'لاگ آؤٹ کریں؟';

  @override
  String get profileLogoutConfirmMessage =>
      'دوبارہ سائن ان کرنے کے لیے آپ کو اپنا فون نمبر دوبارہ تصدیق کرنا ہوگا۔';

  @override
  String get profileDeleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get profileDeleteDialogTitle => 'اکاؤنٹ حذف کریں؟';

  @override
  String get profileDeleteDialogBody =>
      'یہ عمل واپس نہیں ہو سکتا۔ آپ کا تمام ڈیٹا مستقل طور پر ختم ہو جائے گا۔';

  @override
  String get profileDeleteConfirmField => 'تصدیق کے لیے اپنا فون نمبر درج کریں';

  @override
  String get campusLabel => 'کیمپس';

  @override
  String get subjectSelectionTitle => 'آپ کے مضامین';

  @override
  String studentHomeWelcomeName(String name) {
    return 'ہیلو، $name! 👋';
  }

  @override
  String get studentHomeWelcomeSubtitle =>
      'آج پڑھائی جاری رکھنے کے لیے تیار ہیں؟';

  @override
  String get progressEmpty =>
      'ابھی تک کوئی ٹیسٹ نہیں دیا گیا۔ اپنے نتائج دیکھنے کے لیے ہوم ٹیب سے ٹیسٹ دیں۔';

  @override
  String get progressAttempted => 'دیے گئے ٹیسٹ';

  @override
  String get teacherOverviewWelcome => 'خوش آمدید،';

  @override
  String teacherOverviewWelcomeName(String name) {
    return 'خوش آمدید، $name! 👋';
  }

  @override
  String get teacherOverviewWelcomeSubtitle =>
      'آئیے دیکھتے ہیں آپ کے طلباء کی کارکردگی';

  @override
  String get teacherOverviewActualEarnings => 'اصل آمدنی';

  @override
  String get teacherOverviewProjectedEarnings => 'متوقع آمدنی';

  @override
  String get teacherStudentsSearch => 'طلباء تلاش کریں';

  @override
  String get teacherEarningsTotal => 'کل آمدنی';

  @override
  String get liveTestsTitle => 'لائیو ٹیسٹ';

  @override
  String get testListTitle => 'ٹیسٹ';

  @override
  String get testBadgeFree => 'مفت';

  @override
  String get testResultsScore => 'آپ کا سکور';

  @override
  String get otpVerified => 'تصدیق ہو گئی';

  @override
  String get boardClassSelectEmpty =>
      'ابھی تک کوئی بورڈ یا کلاس دستیاب نہیں ہے۔';

  @override
  String get subjectTeacherSelectPrerequisites =>
      'پہلے پیچھے جا کر کیمپس اور بورڈ/کلاس منتخب کریں۔';

  @override
  String get subjectTeacherSelectNoSubjects =>
      'اس بورڈ/کلاس کے لیے ابھی تک کوئی مضمون دستیاب نہیں ہے۔';

  @override
  String get subjectTeacherSelectNoTeachers =>
      'آپ کے کیمپس میں اس مضمون کے لیے ابھی تک کوئی ٹیچر دستیاب نہیں ہے۔';

  @override
  String get subjectTeacherSelectTeacherLabel => 'ٹیچر (اختیاری)';

  @override
  String get subjectTeacherSelectDiscountApplied => 'رعایت لاگو ہو گئی';

  @override
  String get teacherAccountAlreadySetUp =>
      'آپ کا ٹیچر اکاؤنٹ پہلے سے بن چکا ہے۔';

  @override
  String get teacherSignupNameError => 'اپنا نام درج کریں۔';

  @override
  String get teacherSignupCampusError => 'اپنا کیمپس منتخب کریں۔';

  @override
  String get teacherSignupSubjectsError =>
      'کم از کم ایک مضمون منتخب کریں جو آپ پڑھاتے ہیں۔';

  @override
  String get teacherSignupClassesLabel => 'کلاسیں جو آپ پڑھاتے ہیں (اختیاری)';

  @override
  String get teacherSignupClassesEmpty =>
      'ابھی تک کوئی بورڈ/کلاسیں کھلی نہیں ہیں۔';

  @override
  String get teacherSignupSubjectsLabel => 'مضامین جو آپ پڑھاتے ہیں';

  @override
  String get teacherSignupSelectClassFirst => 'پہلے اوپر کلاس منتخب کریں۔';

  @override
  String get teacherSignupNoSubjectsFound =>
      'منتخب کردہ کلاسوں کے لیے کوئی مضمون نہیں ملا۔';

  @override
  String get teacherSignupApproxStudentsLabel =>
      'طلباء کی اندازاً تعداد (اختیاری)';

  @override
  String get teacherSignupSubmitButton => 'منظوری کے لیے جمع کروائیں';

  @override
  String get teacherPendingNotFound =>
      'ہمیں ابھی تک آپ کا ٹیچر پروفائل نہیں ملا۔';

  @override
  String get teacherPendingAccountStatus =>
      'آپ کا اکاؤنٹ ایڈمن کی منظوری کا منتظر ہے۔';

  @override
  String get teacherApprovedAccountStatus =>
      'آپ منظور ہو چکے ہیں! آپ ایپ میں جاری رکھ سکتے ہیں۔';

  @override
  String teacherApprovedNote(String name) {
    return '$name کے لیے منظوری مکمل ہو چکی ہے۔';
  }

  @override
  String get teacherPendingCheckStatus => 'سٹیٹس چیک کریں';

  @override
  String get chapterListTitle => 'ابواب';

  @override
  String get chapterListEmpty =>
      'اس مضمون کے لیے ابھی تک کوئی باب دستیاب نہیں ہے۔';

  @override
  String chapterOrderLabel(int order) {
    return 'باب $order';
  }

  @override
  String get chapterFreeBadge => '2 مفت';

  @override
  String get testKindGuessPaper => 'مضمون وار گیس پیپر';

  @override
  String get testKindSimplePaper => 'مضمون وار پیپر';

  @override
  String get testKindChapterWise => 'باب وار ٹیسٹ';

  @override
  String get testListEmpty => 'اس باب کے لیے ابھی تک کوئی ٹیسٹ دستیاب نہیں ہے۔';

  @override
  String get studentHomeNoSubjects =>
      'ابھی تک کوئی مضمون منتخب نہیں ہوا۔ اپنے مضامین دیکھنے کے لیے آن بورڈنگ مکمل کریں۔';

  @override
  String get liveTestScheduledSingle => 'ایک لائیو ٹیسٹ مقرر ہے';

  @override
  String liveTestScheduledMultiple(int count) {
    return '$count لائیو ٹیسٹ مقرر ہیں';
  }

  @override
  String get profileEmptyFields => 'نام اور فون نمبر خالی نہیں ہو سکتے۔';

  @override
  String get profileUpdatedSuccess => 'پروفائل اپ ڈیٹ ہو گیا۔';

  @override
  String get profileUpdateFailed => 'پروفائل اپ ڈیٹ نہیں ہو سکا۔';

  @override
  String get profileDeleteFailed => 'اکاؤنٹ حذف نہیں ہو سکا۔';

  @override
  String get averageScoreLabel => 'مجموعی اوسط سکور';

  @override
  String testsAttemptedCount(int count) {
    return '$count ٹیسٹ دیے گئے';
  }

  @override
  String get testAnswerLongLabel => 'آپ کا مفصل جواب';

  @override
  String get testAnswerShortLabel => 'آپ کا جواب';

  @override
  String get cartRemoveTooltip => 'ختم کریں';

  @override
  String get checkoutRedirecting =>
      'ادائیگی کے گیٹ وے کی طرف منتقل کیا جا رہا ہے...';

  @override
  String get checkoutFailedMessage =>
      'ادائیگی مکمل نہیں ہو سکی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get checkoutSuccessStatus => 'ادائیگی کامیاب رہی';

  @override
  String get checkoutPendingStatus => 'ادائیگی التواء میں ہے';

  @override
  String get commonDone => 'مکمل';

  @override
  String get testTakingTitle => 'ٹیسٹ';

  @override
  String get testExitDialogStay => 'ٹھہریں';

  @override
  String get testNotPurchasedMessage =>
      'ٹیسٹ شروع کرنے کے لیے آپ کو اسے خریدنا ہوگا۔ اسے انلاک کرنے کے لیے کارٹ میں شامل کریں۔';

  @override
  String get testNoQuestionsFound => 'اس ٹیسٹ کے لیے کوئی سوال نہیں ملا۔';

  @override
  String get testSubmitFailed =>
      'ٹیسٹ جمع نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get testResultsStrongChapters => 'مضبوط ابواب';

  @override
  String get testResultsWeakChapters => 'دوبارہ دہرا نے والے ابواب';

  @override
  String get teacherProfileUnavailable =>
      'آپ کا ٹیچر پروفائل فی الحال دستیاب نہیں ہے۔';

  @override
  String get teacherOverviewNotSetYet => 'ابھی طے نہیں ہوا';

  @override
  String get teacherOverviewNotAvailable => 'ابھی دستیاب نہیں';

  @override
  String get teacherStudentsEmpty =>
      'ابھی تک کوئی طالب علم نہیں ہے۔ جو طلباء آپ کو اپنا ٹیچر منتخب کریں گے وہ یہاں نظر آئیں گے۔';

  @override
  String get teacherStudentsSearchHint => 'نام سے تلاش کریں';

  @override
  String get teacherStudentsSearchNoMatch =>
      'آپ کی تلاش سے کوئی طالب علم مطابقت نہیں رکھتا۔';

  @override
  String get studentProgressDetailTitle => 'طالب علم کی پیشرفت';

  @override
  String get studentProgressDetailEmpty =>
      'اس طالب علم نے ابھی تک کوئی ٹیسٹ نہیں دیا۔';

  @override
  String get teacherEarningsEmpty =>
      'ابھی تک کوئی کمیشن نہیں ہے۔ جیسے ہی آپ کے طلباء کوئی کورس خریدیں گے، آمدنی یہاں نظر آئے گی۔';

  @override
  String teacherEarningsTransactionCount(int count) {
    return '$count لین دین';
  }

  @override
  String get teacherEarningsBreakdownTitle => 'کمیشن کی تفصیل';

  @override
  String get teacherEarningsTriggerPaidPackPurchase => 'پیڈ پیک کی خریداری';

  @override
  String get liveTestsEmpty =>
      'فی الحال کوئی لائیو ٹیسٹ مقرر نہیں ہے۔ بعد میں دوبارہ چیک کریں۔';

  @override
  String get liveTestDateTba => 'لائیو کی تاریخ جلد بتائی جائے گی';

  @override
  String get liveTestEnter => 'داخل ہوں';

  @override
  String liveTestDateFormatted(String date) {
    return 'لائیو تاریخ: $date';
  }

  @override
  String cartItemTestCount(int count) {
    return '$count ٹیسٹ';
  }

  @override
  String chapterListAddToCartButton(String price) {
    return 'کارٹ میں شامل کریں — Rs. $price';
  }

  @override
  String get chapterListPurchasedBadge => 'خریدا جا چکا ہے';

  @override
  String get chapterListAddedToCart => 'کارٹ میں شامل ہو گیا';

  @override
  String get subjectCardOwnedBadge => 'خریدا گیا';

  @override
  String get subjectCardInCartBadge => 'کارٹ میں';

  @override
  String subjectCardAddToCart(String price) {
    return 'Rs. $price';
  }

  @override
  String get subjectCardExploreHint => 'ابواب دیکھیں';

  @override
  String get metaQuestions => 'سوالات';

  @override
  String get metaMinutes => 'منٹ';

  @override
  String get testUnlock => 'کھولیں';

  @override
  String get buyNow => 'ابھی خریدیں';

  @override
  String subjectBundleTitle(String subjectName) {
    return '$subjectName مکمل بنڈل';
  }

  @override
  String subjectBundleDiscount(int percent) {
    return '$percent فیصد رعایت';
  }

  @override
  String buyNowWithPrice(String price) {
    return 'ابھی خریدیں • $price روپے';
  }

  @override
  String get personalizedPracticeTitle => 'ذاتی مشق';

  @override
  String get practiceBankCardTitle => 'پریکٹس سوالات بینک';

  @override
  String get practiceBankCardSubtitle =>
      'اس موضوع کے تمام سوالات بغیر ٹائمر اپنی رفتار سے حل کریں';

  @override
  String attemptsRemaining(int remaining, int total) {
    return '$total میں سے $remaining مفت کوششیں باقی';
  }

  @override
  String get attemptsUpgrade => 'اپ گریڈ';

  @override
  String get practiceHowTitle => 'پریکٹس سوالات بینک کیسے کام کرتا ہے؟';

  @override
  String get practiceBullet1 =>
      'اس موضوع کے تمام ٹیسٹوں کے سوالات کی مشق و دہرائی کریں۔';

  @override
  String get practiceBullet2 =>
      'بغیر کسی ٹائمر یا ٹیسٹ جمع کرائے اپنی رفتار سے سیکھیں۔';

  @override
  String get practiceBullet3 =>
      'کچھ سوالات پہلے دیے گئے ٹیسٹوں سے دہرائے جا سکتے ہیں۔';

  @override
  String get practiceOkayGotIt => 'ٹھیک ہے، سمجھ گیا!';

  @override
  String get attemptsExhaustedTitle => 'آپ کی تمام مفت کوششیں ختم ہو گئیں';

  @override
  String get attemptsExhaustedBody =>
      'مشق جاری رکھنے کے لیے اپ گریڈ کریں۔ ادائیگی کی تصدیق تک ابواب مقفل رہیں گے۔';

  @override
  String get attemptsBlockedMessage =>
      'آپ کی تمام مفت کوششیں ختم ہو گئیں۔ جاری رکھنے کے لیے اپ گریڈ کریں۔';

  @override
  String get scoreCorrect => 'درست';

  @override
  String get scoreWrong => 'غلط';

  @override
  String get scoreTimeTaken => 'لیا گیا وقت';

  @override
  String scoreTimeValue(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get sectionBreakdownTitle => 'سیکشن کی تفصیل';

  @override
  String get reviewAnswersButton => 'جوابات دیکھیں';

  @override
  String get sectionTypeMcq => 'کثیر انتخابی سوالات';

  @override
  String get sectionTypeShort => 'مختصر سوالات';

  @override
  String get sectionTypeLong => 'تفصیلی سوالات';

  @override
  String get reviewAnswersTitle => 'جوابات کا جائزہ';

  @override
  String reviewQuestionNumber(int number) {
    return 'سوال $number';
  }

  @override
  String reviewQuestionOverline(int number, String status) {
    return 'سوال $number • $status';
  }

  @override
  String get statusCorrect => 'درست';

  @override
  String get statusNeedsPractice => 'مزید مشق درکار';

  @override
  String get reviewCorrectAnswerLabel => 'درست جواب';

  @override
  String get commonClose => 'بند کریں';

  @override
  String get coursesFilterAll => 'تمام کورسز';

  @override
  String get progressAllSubjects => 'تمام مضامین';

  @override
  String get progressSubjectFilterLabel => 'مضمون';

  @override
  String get progressAttemptFilterLabel => 'کوشش';

  @override
  String get progressChapterProgressTitle => 'اسباق کی پیشرفت';

  @override
  String attemptNumberLabel(int n) {
    return 'کوشش $n';
  }

  @override
  String get submitTestDialogTitle => 'ٹیسٹ جمع کرائیں؟';

  @override
  String get submitTestDialogBody =>
      'جمع کرانے کے بعد آپ اپنے جوابات تبدیل نہیں کر سکیں گے۔';

  @override
  String get submitTestConfirm => 'جمع کرائیں';

  @override
  String get studentBasicInfoTitle => 'بنیادی معلومات';

  @override
  String get studentBasicInfoHeadline => 'چلیں آپ کو رجسٹر کرتے ہیں';

  @override
  String get studentBasicInfoSubtitle =>
      'اپنا نام اور وہ کیمپس بتائیں جس میں آپ داخل ہیں تاکہ ہم آپ کی تیاری کو بہتر بنا سکیں۔';

  @override
  String get studentAcademicInfoTitle => 'تعلیمی معلومات';

  @override
  String get studentAcademicInfoHeadline => 'آپ کی کلاس اور مضامین';

  @override
  String get studentAcademicInfoSubtitle =>
      'اپنی کلاس منتخب کریں، پھر وہ مضامین چنیں جن کی آپ تیاری کرنا چاہتے ہیں۔';

  @override
  String get studentAcademicInfoClassLabel => 'کلاس';

  @override
  String get studentAcademicInfoGroupLabel => 'گروپ';

  @override
  String get teacherSignupHeadline => 'بطور ٹیچر رجسٹر ہوں';

  @override
  String get teacherSignupAboutYouSection => 'آپ کے بارے میں';

  @override
  String get teacherSignupWhatYouTeachSection => 'آپ کیا پڑھاتے ہیں';

  @override
  String get teacherSignupOptionalSection => 'اختیاری';

  @override
  String get navHome => 'ہوم';

  @override
  String get navCart => 'کارٹ';

  @override
  String get navProgress => 'پیشرفت';

  @override
  String get navNotifications => 'اطلاعات';

  @override
  String get navOverview => 'جائزہ';

  @override
  String get navStudents => 'طلباء';

  @override
  String get navEarnings => 'آمدنی';

  @override
  String get subjectComputerScience => 'کمپیوٹر سائنس';

  @override
  String get subjectPhysics => 'فزکس';

  @override
  String get subjectChemistry => 'کیمسٹری';

  @override
  String get subjectBiology => 'بائیولوجی';

  @override
  String get subjectMathematics => 'ریاضی';

  @override
  String get subjectMath => 'ریاضی';

  @override
  String get subjectEnglish => 'انگریزی';

  @override
  String get subjectUrdu => 'اردو';

  @override
  String get subjectScience => 'سائنس';

  @override
  String get subjectAccounting => 'اصولِ محاسبہ';

  @override
  String get subjectBusinessMath => 'کاروباری ریاضی';

  @override
  String get subjectEconomics => 'معاشیات';

  @override
  String get subjectEducation => 'علمِ تعلیم';

  @override
  String get subjectCivics => 'شہریت';

  @override
  String get promoTeacherDiscountTitle => 'استاد کی رعایتی پیشکش';

  @override
  String get promoTeacherDiscountSubtitle =>
      'تمام مضامین پر 15 فیصد رعایت حاصل کرنے کے لیے اپنے استاد کا کوڈ استعمال کریں';

  @override
  String get promoPracticeBankTitle => 'ذاتی مشق';

  @override
  String get promoPracticeBankSubtitle =>
      'مخصوص اسباق کے سوالیہ بینکوں سے امتحانات کی بہتر تیاری کریں';

  @override
  String get filterCoursesLabel => 'کورسز فلٹر کریں';

  @override
  String get filterAllCourses => 'تمام کورسز';

  @override
  String get filterScienceStream => 'سائنس گروپ';

  @override
  String get filterGeneralStream => 'جنرل گروپ';

  @override
  String get progressAllAttempts => 'تمام کوششیں';

  @override
  String get progressLatestAttempt => 'حالیہ کوشش';

  @override
  String get progressNoChaptersFound => 'اس انتخاب کے لیے کوئی نتائج نہیں ملے۔';

  @override
  String get progressViewResult => 'نتیجہ دیکھیں';

  @override
  String get progressLoadingResult => 'نتائج لوڈ ہو رہے ہیں...';

  @override
  String get progressAttemptSingular => '1 کوشش';

  @override
  String progressAttemptPlural(int count) {
    return '$count کوششیں';
  }
}
