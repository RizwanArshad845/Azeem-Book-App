// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Azeem Publications';

  @override
  String get splashBrandName => 'AZEEM';

  @override
  String get splashTagline => 'PUBLICATIONS';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonRequiredField => 'This field is required';

  @override
  String get commonErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonViewAll => 'View All';

  @override
  String get roleSelectionTitle => 'Welcome to Azeem Publications';

  @override
  String get roleSelectionSubtitle => 'Please select your role to continue';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleStudentDesc => 'Prepare for exams, take tests, track progress';

  @override
  String get roleTeacher => 'Teacher';

  @override
  String get roleTeacherDesc =>
      'Manage students, track earnings, guide learning';

  @override
  String get roleSelectRequired =>
      'Please select a role before requesting an OTP.';

  @override
  String get otpRequestRequired => 'Please request an OTP before verifying.';

  @override
  String get phoneTitle => 'Enter your phone number';

  @override
  String get phoneWelcomeTitle => 'Welcome to Azeem Books!';

  @override
  String get phoneSubtitle => 'We\'ll send a verification code to this number';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '03001234567';

  @override
  String get phoneInvalid =>
      'Enter a valid 11-digit phone number starting with 03';

  @override
  String get phoneContinueButton => 'Send code';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the 4-digit code sent to $phone';
  }

  @override
  String get otpVerifyButton => 'Verify';

  @override
  String get otpIncorrect => 'Incorrect code. Please try again.';

  @override
  String get otpTooManyAttempts => 'Too many attempts. Restarting...';

  @override
  String otpResendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get otpResendCode => 'Resend Code';

  @override
  String get otpResendLimitWarning =>
      'You\'ve reached the resend limit for this session. Please wait before trying again.';

  @override
  String get personalInfoTitle => 'Personal Information';

  @override
  String get personalInfoSubtitle =>
      'Help us personalize your learning experience';

  @override
  String get personalInfoAcademicSection => 'Academic Details';

  @override
  String get personalInfoOptionalSection => 'Optional';

  @override
  String get nameLabel => 'Full name';

  @override
  String get nameHint => 'e.g. Ali Raza';

  @override
  String get cityLabel => 'City';

  @override
  String get cityHint => 'e.g. Lahore';

  @override
  String get collegeLabel => 'College';

  @override
  String get collegeHint => 'Search for your college';

  @override
  String get classLevelLabel => 'Class level';

  @override
  String get classCodeLabel => 'Teacher\'s class code (optional)';

  @override
  String get classCodeHint => '6-character code';

  @override
  String get classCodeNote => 'You can add this later from your profile';

  @override
  String get studentNameEntryTitle => 'What\'s your name?';

  @override
  String get studentNameEntrySubtitle =>
      'This is how teachers and admins will see you';

  @override
  String get campusSelectTitle => 'Select Your Campus';

  @override
  String get campusSelectSubtitle => 'Choose the campus you are enrolled in';

  @override
  String get boardClassSelectTitle => 'Select Board & Class';

  @override
  String get boardClassSelectSubtitle =>
      'Select your education board and current class';

  @override
  String get subjectTeacherSelectTitle => 'Select Subjects & Teachers';

  @override
  String get subjectTeacherSelectSubtitle =>
      'Choose your subjects and assigned teachers';

  @override
  String get teacherSignupTitle => 'Teacher Onboarding';

  @override
  String get teacherSignupSubtitle =>
      'Fill in your details to register as a teacher';

  @override
  String get teacherPendingTitle => 'Pending Approval';

  @override
  String get teacherPendingMessage =>
      'Your teacher application has been submitted and is currently under review by Azeem Publications.';

  @override
  String get teacherPendingNote =>
      'You will receive full access once your credentials are verified by our team.';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeDiagnosticTestTitle => 'Diagnostic Test';

  @override
  String get homeDiagnosticTestSubtitle => 'Free · Computer Science';

  @override
  String get homeAiGuessPapersTitle => 'AI Guess Papers';

  @override
  String get homeAiGuessPapersSubtitle => 'Coming soon';

  @override
  String get homeStudyPlanTitle => 'Study Plan';

  @override
  String get homeStudyPlanSubtitle => 'Coming soon';

  @override
  String get homeNavHome => 'Home';

  @override
  String get homeNavProgress => 'Progress';

  @override
  String get homeNavCart => 'Cart';

  @override
  String get homeNavProfile => 'Profile';

  @override
  String get subjectPickerTitle => 'Choose a subject';

  @override
  String get subjectPickerComputerScience => 'Computer Science';

  @override
  String get selfAssessmentTitle => 'Rate your confidence';

  @override
  String get selfAssessmentSubtitle =>
      'How confident do you feel in each chapter?';

  @override
  String get selfAssessmentStartButton => 'Start Test';

  @override
  String get consentTitle => 'Before you start';

  @override
  String get consentBody =>
      'This test will be screen-recorded for plagiarism review.';

  @override
  String get consentCheckboxLabel => 'I understand and agree to be recorded';

  @override
  String get consentStartButton => 'Start Test';

  @override
  String get testRecLabel => 'REC';

  @override
  String testProgressLabel(int current, int total) {
    return 'Q $current/$total';
  }

  @override
  String get testPreviousButton => 'Previous';

  @override
  String get testNextButton => 'Next';

  @override
  String get testSubmitButton => 'Submit Test';

  @override
  String get testJumpToQuestion => 'Jump to question';

  @override
  String get testShortAnswerHint => 'Type your answer here';

  @override
  String get testExitDialogTitle => 'Leave test?';

  @override
  String get testExitDialogBody =>
      'Your progress will be lost if you leave now.';

  @override
  String get testExitDialogConfirm => 'Leave';

  @override
  String get testQuestionTypeMcq => 'Multiple choice';

  @override
  String get testQuestionTypeShortAnswer => 'Short answer';

  @override
  String get testQuestionTypeLongAnswer => 'Long answer';

  @override
  String get testPreviewTitle => 'Test preview';

  @override
  String testPreviewQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get testPreviewChaptersCovered => 'Chapters covered';

  @override
  String get testPreviewChaptersUnknown =>
      'Chapter details aren\'t available for this test yet.';

  @override
  String get testPreviewStartButton => 'Start test';

  @override
  String get testResultsBreakdownTitle => 'Answer breakdown';

  @override
  String get testResultsSolutionLabel => 'Solution';

  @override
  String get testResultsReattemptButton => 'Reattempt test';

  @override
  String get resultsTitle => 'Your Results';

  @override
  String get resultsOverallReadiness => 'Overall Readiness';

  @override
  String get resultsChapterScores => 'Chapter-wise Scores';

  @override
  String get resultsStudyPlanCta => 'Get personalized study plan';

  @override
  String get resultsReturnHome => 'Return to Home';

  @override
  String get cartTitle => 'Shopping Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartCheckout => 'Proceed to Checkout';

  @override
  String get cartTotal => 'Total Amount';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutPaymentMethod => 'Payment Method';

  @override
  String get checkoutPayNow => 'Pay Now';

  @override
  String get checkoutSuccess => 'Purchase Successful!';

  @override
  String get progressTitle => 'Your Progress';

  @override
  String get progressOverall => 'Overall Score';

  @override
  String get progressTestsTaken => 'Tests Taken';

  @override
  String get progressViewOverall => 'Overall';

  @override
  String get progressViewPerSubject => 'Per Subject';

  @override
  String get progressMasteryTitle => 'Overall Mastery';

  @override
  String progressMasteryTestsCount(int count) {
    return '$count tests attempted';
  }

  @override
  String get progressSubjectEmpty =>
      'No per-subject data yet. Attempt tests across different subjects to see a breakdown here.';

  @override
  String get progressSubjectAvgScore => 'Avg. score';

  @override
  String get progressSubjectWeakChapters => 'Weak';

  @override
  String get progressSubjectAverageChapters => 'Average';

  @override
  String get progressSubjectStrongChapters => 'Strong';

  @override
  String progressSubjectTestsCount(int count) {
    return '$count tests';
  }

  @override
  String get teacherOverviewTitle => 'Teacher Dashboard';

  @override
  String get teacherHomeTitle => 'Home';

  @override
  String get teacherOverviewStudents => 'Students Onboarded';

  @override
  String get teacherOverviewEarnings => 'Total Earnings';

  @override
  String get teacherOverviewQuickActions => 'Quick Actions';

  @override
  String get teacherStudentsTitle => 'My Students';

  @override
  String get teacherEarningsTitle => 'Earnings';

  @override
  String get liveTestTitle => 'Live Test Registration';

  @override
  String get liveTestRegister => 'Register Now';

  @override
  String get liveTestRegistered => 'Registered';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No new notifications';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLanguage => 'Language / زبان';

  @override
  String get profileEnglish => 'English';

  @override
  String get profileUrdu => 'اردو (Urdu)';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileLogoutConfirmTitle => 'Log out?';

  @override
  String get profileLogoutConfirmMessage =>
      'You\'ll need to verify your phone number again to sign back in.';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileDeleteDialogTitle => 'Delete Account?';

  @override
  String get profileDeleteDialogBody =>
      'This action cannot be undone. All your data will be permanently removed.';

  @override
  String profileDeleteConfirmField(String phone) {
    return 'Type your phone number ($phone) to delete your account';
  }

  @override
  String get campusLabel => 'Campus';

  @override
  String get subjectSelectionTitle => 'Your subjects';

  @override
  String get onboardingReviewTitle => 'Review Details';

  @override
  String get onboardingReviewHeadline => 'Review Your Details';

  @override
  String get onboardingReviewSubtitle =>
      'Make sure everything looks right before you continue.';

  @override
  String get onboardingReviewNoTeacher => 'No teacher assigned';

  @override
  String studentHomeWelcomeName(String name) {
    return 'Hi, $name! 👋';
  }

  @override
  String get studentHomeWelcomeSubtitle => 'Ready to keep the streak going?';

  @override
  String get progressEmpty =>
      'No attempted tests yet. Take a test from the Home tab to see your progress here.';

  @override
  String get progressAttempted => 'Attempted tests';

  @override
  String get teacherOverviewWelcome => 'Welcome back,';

  @override
  String teacherOverviewWelcomeName(String name) {
    return 'Welcome back, $name! 👋';
  }

  @override
  String get teacherOverviewWelcomeSubtitle =>
      'Here\'s how your students are doing';

  @override
  String get teacherOverviewActualEarnings => 'Actual earnings';

  @override
  String get teacherOverviewProjectedEarnings => 'Projected earnings';

  @override
  String get teacherStudentsSearch => 'Search students';

  @override
  String get teacherEarningsTotal => 'Total earnings';

  @override
  String get liveTestsTitle => 'Live Tests';

  @override
  String get testListTitle => 'Tests';

  @override
  String get testBadgeFree => 'Free';

  @override
  String get testResultsScore => 'Your score';

  @override
  String get otpVerified => 'Verified';

  @override
  String get boardClassSelectEmpty => 'No board/classes are available yet.';

  @override
  String get subjectTeacherSelectPrerequisites =>
      'Go back and choose a campus and board/class first.';

  @override
  String get subjectTeacherSelectNoSubjects =>
      'No subjects are available for this board/class yet.';

  @override
  String get subjectTeacherSelectNoTeachers =>
      'No teachers available at your campus for this subject yet.';

  @override
  String get subjectTeacherSelectTeacherLabel => 'Teacher (optional)';

  @override
  String get subjectTeacherSelectDiscountApplied => 'Discount applied';

  @override
  String get teacherAccountAlreadySetUp =>
      'Your teacher account is already set up.';

  @override
  String get teacherSignupNameError => 'Enter your name.';

  @override
  String get teacherSignupCampusError => 'Select your campus.';

  @override
  String get teacherSignupSubjectsError =>
      'Select at least one subject you teach.';

  @override
  String get teacherSignupClassesLabel => 'Classes you teach';

  @override
  String get teacherSignupClassesEmpty => 'No board/classes are open yet.';

  @override
  String get teacherSignupSubjectsLabel => 'Subjects you teach';

  @override
  String get teacherSignupSelectClassFirst => 'Select a class above first.';

  @override
  String get teacherSignupNoSubjectsFound =>
      'No subjects found for the selected classes.';

  @override
  String get teacherSignupApproxStudentsLabel =>
      'Number of students you teach (optional)';

  @override
  String get teacherSignupSubmitButton => 'Submit for approval';

  @override
  String get teacherPendingNotFound =>
      'We couldn\'t find your teacher profile yet.';

  @override
  String get teacherPendingAccountStatus =>
      'Your account is pending Admin approval.';

  @override
  String get teacherApprovedAccountStatus =>
      'You\'re approved! You can continue into the app.';

  @override
  String teacherApprovedNote(String name) {
    return 'Approval is complete for $name.';
  }

  @override
  String get teacherPendingCheckStatus => 'Check status';

  @override
  String get chapterListTitle => 'Chapters';

  @override
  String get chapterListEmpty =>
      'No chapters are available for this subject yet.';

  @override
  String chapterOrderLabel(int order) {
    return 'Chapter $order';
  }

  @override
  String get chapterFreeBadge => '2 free';

  @override
  String get testKindGuessPaper => 'Subject-wise guess paper';

  @override
  String get testKindSimplePaper => 'Subject-wise paper';

  @override
  String get testKindChapterWise => 'Chapter-wise test';

  @override
  String get testListEmpty => 'No tests are available for this chapter yet.';

  @override
  String get studentHomeNoSubjects =>
      'No subjects selected yet. Complete onboarding to see your subjects here.';

  @override
  String get liveTestScheduledSingle => 'A live test is scheduled';

  @override
  String liveTestScheduledMultiple(int count) {
    return '$count live tests are scheduled';
  }

  @override
  String get profileEmptyFields => 'Name and phone number cannot be empty.';

  @override
  String get profileUpdatedSuccess => 'Profile updated.';

  @override
  String get profileUpdateFailed => 'Could not update profile.';

  @override
  String get profileDeleteFailed => 'Could not delete account.';

  @override
  String get averageScoreLabel => 'Overall average score';

  @override
  String testsAttemptedCount(int count) {
    return '$count tests attempted';
  }

  @override
  String get testAnswerLongLabel => 'Your detailed answer';

  @override
  String get testAnswerShortLabel => 'Your answer';

  @override
  String get cartRemoveTooltip => 'Remove';

  @override
  String get checkoutRedirecting => 'Redirecting to payment gateway...';

  @override
  String get checkoutFailedMessage =>
      'Payment could not be completed. Please try again.';

  @override
  String get checkoutSuccessStatus => 'Payment successful';

  @override
  String get checkoutPendingStatus => 'Payment pending';

  @override
  String get commonDone => 'Done';

  @override
  String get testTakingTitle => 'Test';

  @override
  String get testExitDialogStay => 'Stay';

  @override
  String get testNotPurchasedMessage =>
      'You need to purchase this test before you can attempt it. Add it to your cart from the test list to unlock it.';

  @override
  String get testNoQuestionsFound => 'No questions found for this test.';

  @override
  String get testGradingInProgressMessage => 'Grading your answers…';

  @override
  String get testSubmitFailed =>
      'Could not submit your test. Please try again.';

  @override
  String get testResultsStrongChapters => 'Strong chapters';

  @override
  String get testResultsWeakChapters => 'Chapters to review';

  @override
  String get teacherProfileUnavailable =>
      'Your teacher profile is not available right now.';

  @override
  String get teacherOverviewNotSetYet => 'Not set yet';

  @override
  String get teacherOverviewNotAvailable => 'Not available yet';

  @override
  String get teacherStudentsEmpty =>
      'No students yet. Students who select you as their subject teacher will show up here.';

  @override
  String get teacherStudentsSearchHint => 'Search by name';

  @override
  String get teacherStudentsSearchNoMatch => 'No students match your search.';

  @override
  String get studentProgressDetailTitle => 'Student progress';

  @override
  String get studentProgressDetailEmpty =>
      'No test attempts yet for this student.';

  @override
  String get teacherEarningsEmpty =>
      'No earnings yet. Earnings show up here as soon as your students purchase a paid pack.';

  @override
  String teacherEarningsTransactionCount(int count) {
    return '$count transactions';
  }

  @override
  String get teacherEarningsBreakdownTitle => 'Earnings breakdown';

  @override
  String get teacherEarningsTriggerPaidPackPurchase => 'Paid pack purchases';

  @override
  String get liveTestsEmpty =>
      'No live tests are scheduled right now. Admin schedules these occasionally — check back later.';

  @override
  String get liveTestDateTba => 'Live date to be announced';

  @override
  String get liveTestEnter => 'Enter';

  @override
  String liveTestDateFormatted(String date) {
    return 'Live on $date';
  }

  @override
  String cartItemTestCount(int count) {
    return '$count tests';
  }

  @override
  String chapterListAddToCartButton(String price) {
    return 'Add to cart — Rs. $price';
  }

  @override
  String get chapterListPurchasedBadge => 'Purchased';

  @override
  String get chapterListAddedToCart => 'Added to cart';

  @override
  String get subjectCardOwnedBadge => 'Owned';

  @override
  String get subjectCardInCartBadge => 'In Cart';

  @override
  String subjectCardAddToCart(String price) {
    return 'Rs. $price';
  }

  @override
  String get subjectCardAddToCartGeneric => 'Add to Cart';

  @override
  String get subjectCardExploreHint => 'Explore chapters';

  @override
  String get metaQuestions => 'ques';

  @override
  String get metaMinutes => 'min';

  @override
  String get testUnlock => 'Unlock';

  @override
  String get buyNow => 'Buy Now';

  @override
  String subjectBundleTitle(String subjectName) {
    return '$subjectName Full Bundle';
  }

  @override
  String subjectBundleDiscount(int percent) {
    return '$percent% OFF';
  }

  @override
  String buyNowWithPrice(String price) {
    return 'Buy Now • Rs. $price';
  }

  @override
  String get personalizedPracticeTitle => 'Personalized Practice';

  @override
  String get practiceBankCardTitle => 'Practice Question Bank';

  @override
  String get practiceBankCardSubtitle =>
      'Practice all questions of this topic at your own pace, no timer';

  @override
  String attemptsRemaining(int remaining, int total) {
    return '$remaining of $total free attempts left';
  }

  @override
  String get attemptsUpgrade => 'Upgrade';

  @override
  String get practiceHowTitle => 'How Practice Question Bank works?';

  @override
  String get practiceBullet1 =>
      'Practice & revise questions from all tests of this topic.';

  @override
  String get practiceBullet2 =>
      'Learn at your pace without any timer or test submission.';

  @override
  String get practiceBullet3 =>
      'Some questions might repeat from tests you\'ve already taken.';

  @override
  String get practiceOkayGotIt => 'Okay, Got it!';

  @override
  String get attemptsExhaustedTitle => 'You\'ve used all free attempts';

  @override
  String get attemptsExhaustedBody =>
      'Upgrade to keep practicing. Chapters stay locked until your payment is confirmed.';

  @override
  String get attemptsBlockedMessage =>
      'You\'ve used all your free attempts. Upgrade to continue.';

  @override
  String get scoreCorrect => 'Correct';

  @override
  String get scoreWrong => 'Wrong';

  @override
  String get scoreTimeTaken => 'Time Taken';

  @override
  String scoreTimeValue(int minutes) {
    return '${minutes}m';
  }

  @override
  String get sectionBreakdownTitle => 'Section Breakdown';

  @override
  String get reviewAnswersButton => 'Review Answers';

  @override
  String get sectionTypeMcq => 'MCQs';

  @override
  String get sectionTypeShort => 'Short Questions';

  @override
  String get sectionTypeLong => 'Long Questions';

  @override
  String get reviewAnswersTitle => 'Review Answers';

  @override
  String reviewQuestionNumber(int number) {
    return 'QUESTION $number';
  }

  @override
  String reviewQuestionOverline(int number, String status) {
    return 'QUESTION $number • $status';
  }

  @override
  String get statusCorrect => 'Correct';

  @override
  String get statusNeedsPractice => 'Needs Practice';

  @override
  String get reviewCorrectAnswerLabel => 'Correct answer';

  @override
  String get commonClose => 'Close';

  @override
  String get coursesFilterAll => 'All Courses';

  @override
  String get progressAllSubjects => 'All subjects';

  @override
  String get progressSubjectFilterLabel => 'Subject';

  @override
  String get progressAttemptFilterLabel => 'Attempt';

  @override
  String get progressChapterProgressTitle => 'Chapter progress';

  @override
  String attemptNumberLabel(int n) {
    return 'Attempt $n';
  }

  @override
  String get submitTestDialogTitle => 'Submit test?';

  @override
  String get submitTestDialogBody =>
      'You won\'t be able to change your answers after submitting.';

  @override
  String get submitTestConfirm => 'Submit';

  @override
  String get studentBasicInfoTitle => 'Basic Info';

  @override
  String get studentBasicInfoHeadline => 'Let\'s get you set up';

  @override
  String get studentBasicInfoSubtitle =>
      'Tell us your name and the campus you\'re enrolled in so we can personalize your test prep.';

  @override
  String get studentAcademicInfoTitle => 'Academic Info';

  @override
  String get studentAcademicInfoHeadline => 'Your class & subjects';

  @override
  String get studentAcademicInfoSubtitle =>
      'Choose your class, then pick the subjects you want to prepare for.';

  @override
  String get studentAcademicInfoClassLabel => 'Class';

  @override
  String get studentAcademicInfoGroupLabel => 'Group';

  @override
  String get teacherSignupHeadline => 'Register as a teacher';

  @override
  String get teacherSignupAboutYouSection => 'About you';

  @override
  String get teacherSignupWhatYouTeachSection => 'What you teach';

  @override
  String get teacherSignupOptionalSection => 'Optional';

  @override
  String get navHome => 'Home';

  @override
  String get navCart => 'Cart';

  @override
  String get navProgress => 'Progress';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navOverview => 'Overview';

  @override
  String get navStudents => 'Students';

  @override
  String get navEarnings => 'Earnings';

  @override
  String get subjectComputerScience => 'Computer Science';

  @override
  String get subjectPhysics => 'Physics';

  @override
  String get subjectChemistry => 'Chemistry';

  @override
  String get subjectBiology => 'Biology';

  @override
  String get subjectMathematics => 'Mathematics';

  @override
  String get subjectMath => 'Math';

  @override
  String get subjectEnglish => 'English';

  @override
  String get subjectUrdu => 'Urdu';

  @override
  String get subjectScience => 'Science';

  @override
  String get subjectAccounting => 'Principles of Accounting';

  @override
  String get subjectBusinessMath => 'Business Mathematics';

  @override
  String get subjectEconomics => 'Economics';

  @override
  String get subjectEducation => 'Education';

  @override
  String get subjectCivics => 'Civics';

  @override
  String get promoTeacherDiscountTitle => 'Teacher Referral Offer';

  @override
  String get promoTeacherDiscountSubtitle =>
      'Use your teacher code to get 15% discount on all subjects';

  @override
  String get promoPracticeBankTitle => 'Personalized Practice';

  @override
  String get promoPracticeBankSubtitle =>
      'Sharpen exam prep with targeted chapter question banks';

  @override
  String get progressAllAttempts => 'All Attempts';

  @override
  String get progressLatestAttempt => 'Latest Attempt';

  @override
  String get progressNoChaptersFound =>
      'No chapter attempts found for this selection.';

  @override
  String get progressViewResult => 'View Result';

  @override
  String get progressLoadingResult => 'Loading results...';

  @override
  String get progressAttemptSingular => '1 attempt';

  @override
  String progressAttemptPlural(int count) {
    return '$count attempts';
  }

  @override
  String get teacherSignupSummaryTitle => 'Review Registration';

  @override
  String get teacherSignupSummaryName => 'Full Name';

  @override
  String get teacherSignupSummaryCampus => 'Campus';

  @override
  String get teacherSignupSummaryClasses => 'Classes';

  @override
  String get teacherSignupSummarySubjects => 'Subjects';

  @override
  String get teacherSignupSummaryStudents => 'Declared Students';

  @override
  String teacherWelcomeBack(String name) {
    return 'Welcome back, $name 👋';
  }

  @override
  String get teacherActualEarnings => 'Actual Earnings';

  @override
  String get teacherProjectedEarnings => 'Projected Earnings';

  @override
  String get teacherCommissionAndEarnings => 'Total Earnings';

  @override
  String get teacherPerStudentRate => 'Rs. 500 / Student';

  @override
  String teacherUnlockUpTo(String amount) {
    return 'Unlock up to $amount more!';
  }

  @override
  String teacherDeclaredStudentsDesc(
    int declared,
    int onboarded,
    int remaining,
  ) {
    return 'Based on your ~$declared declared students ($onboarded joined, $remaining remaining).';
  }

  @override
  String teacherGoalOnboarded(int onboarded, int declared) {
    return '$onboarded of $declared onboarded';
  }

  @override
  String get teacherQuickActions => 'Quick Actions';

  @override
  String teacherStudentsRoster(int count) {
    return 'Students ($count)';
  }

  @override
  String teacherStudentsRosterSub(int paid, int free) {
    return '$paid Paid • $free Free';
  }

  @override
  String get teacherEarningsLedger => 'Earnings Ledger';

  @override
  String get teacherEarningsLedgerSub => 'View transactions';

  @override
  String get teacherShareReferral => 'Share Referral';

  @override
  String get teacherShareReferralSub => 'Invite students';

  @override
  String get teacherRecentActivity => 'Recent Activity';

  @override
  String get teacherAllStudents => 'All Students';

  @override
  String get teacherActivePaid => 'Active (Paid)';

  @override
  String get teacherFreeUnpaid => 'Free (Unpaid)';

  @override
  String get teacherCommissionEarned => '+Rs. 500 Earned';

  @override
  String get teacherBundleNotPurchased => 'Bundle not purchased yet';

  @override
  String get teacherViewProgress => 'View Progress';

  @override
  String get teacherSortRecentlyJoined => 'Recently Joined';

  @override
  String get teacherSortTopPerformers => 'Top Test Performers';

  @override
  String get teacherSortAlphabetical => 'Alphabetical (A-Z)';

  @override
  String get teacherAllCampuses => 'All Campuses';

  @override
  String get teacherSearchHint => 'Search by student name or phone...';

  @override
  String get teacherProfileCampusesTaught => 'Campuses & Institutions';

  @override
  String get teacherProfileClassesTaught => 'Classes Taught';

  @override
  String get teacherProfileSubjectsTaught => 'Subjects Taught';

  @override
  String get teacherProfileDeclaredReach => 'Declared Student Reach';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsClearAll => 'Clear all';

  @override
  String get notificationsClearConfirmTitle => 'Clear All Notifications?';

  @override
  String get notificationsClearConfirmMessage =>
      'Are you sure you want to remove all notifications from your feed?';

  @override
  String get teacherNavOverview => 'Overview';

  @override
  String get teacherNavStudents => 'Students';

  @override
  String get teacherNavEarnings => 'Earnings';

  @override
  String get homeNavNotifications => 'Notifications';

  @override
  String get teacherVerifyNewPhoneTitle => 'Verify New Phone Number';

  @override
  String teacherVerifyPhoneOtpSentMessage(String phone) {
    return 'A 4-digit verification code has been sent to $phone.';
  }

  @override
  String get teacherOtpCodeLabel => '4-Digit OTP Code';

  @override
  String get teacherOtpTestHint => 'Enter the code we sent you';

  @override
  String get teacherOtpEnterCodeError => 'Please enter the verification code.';

  @override
  String get teacherOtpInvalidCodeError =>
      'Invalid verification code. Please try again.';

  @override
  String get teacherVerifiedBadge => 'Azeem Verified Faculty';

  @override
  String get teacherDefaultCampusFallback => 'Bahawalpur Campus';

  @override
  String teacherStudentsEnrolledCount(int count) {
    return '~$count Students Enrolled';
  }

  @override
  String teacherPurchasesCount(int count) {
    return '$count Purchases';
  }

  @override
  String get teacherCommissionHistory => 'Earnings History';

  @override
  String teacherEarningsShowingRange(int start, int end, int total) {
    return 'Showing $start–$end of $total records';
  }

  @override
  String get teacherProjectedSimulatorTitle => 'Projected Earnings Simulator';

  @override
  String get teacherPerPackRate => 'Rs. 500/pack';

  @override
  String get teacherTotalProjectedEarnings => 'Total Projected Earnings';

  @override
  String teacherSimulatorPrompt(int count) {
    return 'If $count more of your remaining declared students buy a test pack:';
  }

  @override
  String get teacherZeroStudentsLabel => '0 Students';

  @override
  String teacherAllRemainingStudents(int count) {
    return 'All $count Remaining Students';
  }

  @override
  String get teacherGoalReachedMessage =>
      '🎉 Goal reached! All declared students are currently onboarded.';

  @override
  String teacherEarningsRecordSubtitle(String name) {
    return '$name • Test Bundle';
  }

  @override
  String get teacherStudentPackPurchaseFallback => 'Student Pack Purchase';

  @override
  String get commonNoOptionsAvailable => 'No options available.';

  @override
  String get commonClear => 'Clear';

  @override
  String teacherSignupSummaryStudentsCount(int count) {
    return '$count students';
  }

  @override
  String get teacherSignupSummaryNotSpecified => 'Not specified (Optional)';

  @override
  String get commonNoneSelected => 'None selected';

  @override
  String get teacherReferralShareText =>
      'Join Azeem Publications App and choose me as your teacher to access verified board test packs!';

  @override
  String get teacherReferralLinkCopied =>
      'Teacher invite link copied to clipboard!';

  @override
  String get teacherRecentActivityEmpty => 'No recent activity yet.';

  @override
  String timeAgoMinutes(int count) {
    return '${count}m ago';
  }

  @override
  String timeAgoHours(int count) {
    return '${count}h ago';
  }

  @override
  String timeAgoDays(int count) {
    return '${count}d ago';
  }

  @override
  String get studentProgressNoAttemptsTitle => 'No Test Attempts Yet';

  @override
  String get studentProgressNoAttemptsBody =>
      'This student has not submitted any chapter tests yet.';

  @override
  String studentEnrolledWithYouLabel(String subjects) {
    return 'Enrolled with you in: $subjects';
  }

  @override
  String get studentGeneralEnrolledFallback => 'General Enrolled';

  @override
  String get commonSort => 'Sort';

  @override
  String teacherStudentsShowingRange(int start, int end, int total) {
    return 'Showing $start–$end of $total students';
  }

  @override
  String commonPageOfTotal(int page, int total) {
    return 'Page $page / $total';
  }
}
