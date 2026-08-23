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
  String get phoneCountryCode => '+92';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '3XX XXXXXXX';

  @override
  String get phoneInvalid => 'Enter a valid 10-digit phone number';

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
  String get teacherOverviewTitle => 'Teacher Dashboard';

  @override
  String get teacherOverviewStudents => 'Students Onboarded';

  @override
  String get teacherOverviewEarnings => 'Total Earnings';

  @override
  String get teacherOverviewQuickActions => 'Quick Actions';

  @override
  String get teacherStudentsTitle => 'My Students';

  @override
  String get teacherEarningsTitle => 'Earnings & Commission';

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
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileDeleteDialogTitle => 'Delete Account?';

  @override
  String get profileDeleteDialogBody =>
      'This action cannot be undone. All your data will be permanently removed.';

  @override
  String get campusLabel => 'Campus';

  @override
  String get subjectSelectionTitle => 'Your subjects';

  @override
  String get progressEmpty =>
      'No attempted tests yet. Take a test from the Home tab to see your progress here.';

  @override
  String get progressAttempted => 'Attempted tests';

  @override
  String get teacherOverviewWelcome => 'Welcome back,';

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
  String get teacherSignupClassesLabel => 'Classes you teach (optional)';

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
      'Approx. number of students (optional)';

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
      'No commissions yet. Earnings show up here as soon as your students purchase a paid pack.';

  @override
  String teacherEarningsTransactionCount(int count) {
    return '$count transactions';
  }

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
  String get teacherSignupStep1Title => 'Personal & Campus Info';

  @override
  String get teacherSignupStep1Subtitle =>
      'Enter your name and the campus you\'re associated with.';

  @override
  String get teacherSignupStep2Title => 'Teaching Scope';

  @override
  String get teacherSignupStep2Subtitle =>
      'Select your classes and the subjects you instruct.';

  @override
  String get teacherSignupStep3Title => 'Student Reach';

  @override
  String get teacherSignupStep3Subtitle =>
      'Optionally let us know roughly how many students you teach.';

  @override
  String get teacherSignupClassesRequiredLabel =>
      'Classes you teach * (Select 1 or more)';

  @override
  String get teacherSignupSubjectsRequiredLabel =>
      'Subjects you teach * (Select 1 or more)';

  @override
  String get teacherSignupClassesRequiredError =>
      'Please select at least one class.';

  @override
  String get teacherSignupSubjectsRequiredError =>
      'Please select at least one subject.';

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
  String get teacherSignupNextTeaching => 'Continue to Teaching Info';

  @override
  String get teacherSignupNextStudents => 'Continue to Student Info';

  @override
  String get teacherSignupStep4Title => 'Review Registration';

  @override
  String get teacherSignupStep4Subtitle =>
      'Please verify your details before submitting for approval.';
}
