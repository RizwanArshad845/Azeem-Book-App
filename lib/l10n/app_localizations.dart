import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Azeem Publications'**
  String get appTitle;

  /// No description provided for @splashBrandName.
  ///
  /// In en, this message translates to:
  /// **'AZEEM'**
  String get splashBrandName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'PUBLICATIONS'**
  String get splashTagline;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get commonRequiredField;

  /// No description provided for @commonErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonErrorGeneric;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// No description provided for @commonAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get commonAssign;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @roleSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get roleSelectionTitle;

  /// No description provided for @roleSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please select your role to continue'**
  String get roleSelectionSubtitle;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @roleStudentDesc.
  ///
  /// In en, this message translates to:
  /// **'Prepare for exams, take tests, track progress'**
  String get roleStudentDesc;

  /// No description provided for @roleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get roleTeacher;

  /// No description provided for @roleTeacherDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage students, track earnings, guide learning'**
  String get roleTeacherDesc;

  /// No description provided for @roleSelectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a role before requesting an OTP.'**
  String get roleSelectRequired;

  /// No description provided for @otpRequestRequired.
  ///
  /// In en, this message translates to:
  /// **'Please request an OTP before verifying.'**
  String get otpRequestRequired;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboardingTitle;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneTitle;

  /// No description provided for @phoneWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Azeem Books!'**
  String get phoneWelcomeTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification code to this number'**
  String get phoneSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'03001234567'**
  String get phoneHint;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 11-digit phone number starting with 03'**
  String get phoneInvalid;

  /// No description provided for @phoneContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get phoneContinueButton;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerifyButton;

  /// No description provided for @otpIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Please try again.'**
  String get otpIncorrect;

  /// No description provided for @otpTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Restarting...'**
  String get otpTooManyAttempts;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String otpResendIn(String time);

  /// No description provided for @otpResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get otpResendCode;

  /// No description provided for @otpResendLimitWarning.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the resend limit for this session. Please wait before trying again.'**
  String get otpResendLimitWarning;

  /// No description provided for @personalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoTitle;

  /// No description provided for @personalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your learning experience'**
  String get personalInfoSubtitle;

  /// No description provided for @personalInfoAcademicSection.
  ///
  /// In en, this message translates to:
  /// **'Academic Details'**
  String get personalInfoAcademicSection;

  /// No description provided for @personalInfoOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get personalInfoOptionalSection;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ali Raza'**
  String get nameHint;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lahore'**
  String get cityHint;

  /// No description provided for @collegeLabel.
  ///
  /// In en, this message translates to:
  /// **'College'**
  String get collegeLabel;

  /// No description provided for @collegeHint.
  ///
  /// In en, this message translates to:
  /// **'Search for your college'**
  String get collegeHint;

  /// No description provided for @classLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Class level'**
  String get classLevelLabel;

  /// No description provided for @classCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher\'s class code (optional)'**
  String get classCodeLabel;

  /// No description provided for @classCodeHint.
  ///
  /// In en, this message translates to:
  /// **'6-character code'**
  String get classCodeHint;

  /// No description provided for @classCodeNote.
  ///
  /// In en, this message translates to:
  /// **'You can add this later from your profile'**
  String get classCodeNote;

  /// No description provided for @studentNameEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get studentNameEntryTitle;

  /// No description provided for @studentNameEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is how teachers and admins will see you'**
  String get studentNameEntrySubtitle;

  /// No description provided for @campusSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Your Campus'**
  String get campusSelectTitle;

  /// No description provided for @campusSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the campus you are enrolled in'**
  String get campusSelectSubtitle;

  /// No description provided for @boardClassSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Board & Class'**
  String get boardClassSelectTitle;

  /// No description provided for @boardClassSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your education board and current class'**
  String get boardClassSelectSubtitle;

  /// No description provided for @subjectTeacherSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Subjects & Teachers'**
  String get subjectTeacherSelectTitle;

  /// No description provided for @subjectTeacherSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your subjects and assigned teachers'**
  String get subjectTeacherSelectSubtitle;

  /// No description provided for @teacherSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Onboarding'**
  String get teacherSignupTitle;

  /// No description provided for @teacherSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to register as a teacher'**
  String get teacherSignupSubtitle;

  /// No description provided for @teacherPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get teacherPendingTitle;

  /// No description provided for @teacherPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your teacher application has been submitted and is currently under review by Azeem Publications.'**
  String get teacherPendingMessage;

  /// No description provided for @teacherPendingNote.
  ///
  /// In en, this message translates to:
  /// **'You will receive full access once your credentials are verified by our team.'**
  String get teacherPendingNote;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeDiagnosticTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Test'**
  String get homeDiagnosticTestTitle;

  /// No description provided for @homeDiagnosticTestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free · Computer Science'**
  String get homeDiagnosticTestSubtitle;

  /// No description provided for @homeAiGuessPapersTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Guess Papers'**
  String get homeAiGuessPapersTitle;

  /// No description provided for @homeAiGuessPapersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get homeAiGuessPapersSubtitle;

  /// No description provided for @homeStudyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Plan'**
  String get homeStudyPlanTitle;

  /// No description provided for @homeStudyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get homeStudyPlanSubtitle;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get homeNavProgress;

  /// No description provided for @homeNavCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get homeNavCart;

  /// No description provided for @homeNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeNavProfile;

  /// No description provided for @subjectPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a subject'**
  String get subjectPickerTitle;

  /// No description provided for @subjectPickerComputerScience.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get subjectPickerComputerScience;

  /// No description provided for @selfAssessmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate your confidence'**
  String get selfAssessmentTitle;

  /// No description provided for @selfAssessmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How confident do you feel in each chapter?'**
  String get selfAssessmentSubtitle;

  /// No description provided for @selfAssessmentStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get selfAssessmentStartButton;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In en, this message translates to:
  /// **'This test will be screen-recorded for plagiarism review.'**
  String get consentBody;

  /// No description provided for @consentCheckboxLabel.
  ///
  /// In en, this message translates to:
  /// **'I understand and agree to be recorded'**
  String get consentCheckboxLabel;

  /// No description provided for @consentStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get consentStartButton;

  /// No description provided for @testRecLabel.
  ///
  /// In en, this message translates to:
  /// **'REC'**
  String get testRecLabel;

  /// No description provided for @testProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Q {current}/{total}'**
  String testProgressLabel(int current, int total);

  /// No description provided for @testPreviousButton.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get testPreviousButton;

  /// No description provided for @testNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get testNextButton;

  /// No description provided for @testSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Test'**
  String get testSubmitButton;

  /// No description provided for @testJumpToQuestion.
  ///
  /// In en, this message translates to:
  /// **'Jump to question'**
  String get testJumpToQuestion;

  /// No description provided for @testShortAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here'**
  String get testShortAnswerHint;

  /// No description provided for @testExitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave test?'**
  String get testExitDialogTitle;

  /// No description provided for @testExitDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be lost if you leave now.'**
  String get testExitDialogBody;

  /// No description provided for @testExitDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get testExitDialogConfirm;

  /// No description provided for @testQuestionTypeMcq.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice'**
  String get testQuestionTypeMcq;

  /// No description provided for @testQuestionTypeShortAnswer.
  ///
  /// In en, this message translates to:
  /// **'Short answer'**
  String get testQuestionTypeShortAnswer;

  /// No description provided for @testQuestionTypeLongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Long answer'**
  String get testQuestionTypeLongAnswer;

  /// No description provided for @testPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Test preview'**
  String get testPreviewTitle;

  /// No description provided for @testPreviewQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String testPreviewQuestionCount(int count);

  /// No description provided for @testPreviewChaptersCovered.
  ///
  /// In en, this message translates to:
  /// **'Chapters covered'**
  String get testPreviewChaptersCovered;

  /// No description provided for @testPreviewChaptersUnknown.
  ///
  /// In en, this message translates to:
  /// **'Chapter details aren\'t available for this test yet.'**
  String get testPreviewChaptersUnknown;

  /// No description provided for @testPreviewStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get testPreviewStartButton;

  /// No description provided for @testResultsBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer breakdown'**
  String get testResultsBreakdownTitle;

  /// No description provided for @testResultsSolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get testResultsSolutionLabel;

  /// No description provided for @testResultsReattemptButton.
  ///
  /// In en, this message translates to:
  /// **'Reattempt test'**
  String get testResultsReattemptButton;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Results'**
  String get resultsTitle;

  /// No description provided for @resultsOverallReadiness.
  ///
  /// In en, this message translates to:
  /// **'Overall Readiness'**
  String get resultsOverallReadiness;

  /// No description provided for @resultsChapterScores.
  ///
  /// In en, this message translates to:
  /// **'Chapter-wise Scores'**
  String get resultsChapterScores;

  /// No description provided for @resultsStudyPlanCta.
  ///
  /// In en, this message translates to:
  /// **'Get personalized study plan'**
  String get resultsStudyPlanCta;

  /// No description provided for @resultsReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get resultsReturnHome;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get cartCheckout;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get cartTotal;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get checkoutPayNow;

  /// No description provided for @checkoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase Successful!'**
  String get checkoutSuccess;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get progressTitle;

  /// No description provided for @progressOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get progressOverall;

  /// No description provided for @progressTestsTaken.
  ///
  /// In en, this message translates to:
  /// **'Tests Taken'**
  String get progressTestsTaken;

  /// No description provided for @progressViewOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get progressViewOverall;

  /// No description provided for @progressViewPerSubject.
  ///
  /// In en, this message translates to:
  /// **'Per Subject'**
  String get progressViewPerSubject;

  /// No description provided for @progressMasteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall Mastery'**
  String get progressMasteryTitle;

  /// No description provided for @progressMasteryTestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tests attempted'**
  String progressMasteryTestsCount(int count);

  /// No description provided for @progressSubjectEmpty.
  ///
  /// In en, this message translates to:
  /// **'No per-subject data yet. Attempt tests across different subjects to see a breakdown here.'**
  String get progressSubjectEmpty;

  /// No description provided for @progressSubjectAvgScore.
  ///
  /// In en, this message translates to:
  /// **'Avg. score'**
  String get progressSubjectAvgScore;

  /// No description provided for @progressSubjectWeakChapters.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get progressSubjectWeakChapters;

  /// No description provided for @progressSubjectAverageChapters.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get progressSubjectAverageChapters;

  /// No description provided for @progressSubjectStrongChapters.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get progressSubjectStrongChapters;

  /// No description provided for @progressSubjectTestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tests'**
  String progressSubjectTestsCount(int count);

  /// No description provided for @teacherOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacherOverviewTitle;

  /// No description provided for @teacherHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get teacherHomeTitle;

  /// No description provided for @teacherOverviewStudents.
  ///
  /// In en, this message translates to:
  /// **'Students Onboarded'**
  String get teacherOverviewStudents;

  /// No description provided for @teacherOverviewEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get teacherOverviewEarnings;

  /// No description provided for @teacherOverviewQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get teacherOverviewQuickActions;

  /// No description provided for @teacherStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Students'**
  String get teacherStudentsTitle;

  /// No description provided for @teacherEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get teacherEarningsTitle;

  /// No description provided for @liveTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Test Registration'**
  String get liveTestTitle;

  /// No description provided for @liveTestRegister.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get liveTestRegister;

  /// No description provided for @liveTestRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get liveTestRegistered;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get notificationsEmpty;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language / زبان'**
  String get profileLanguage;

  /// No description provided for @profileEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileEnglish;

  /// No description provided for @profileUrdu.
  ///
  /// In en, this message translates to:
  /// **'اردو (Urdu)'**
  String get profileUrdu;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to verify your phone number again to sign back in.'**
  String get profileLogoutConfirmMessage;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get profileDeleteDialogTitle;

  /// No description provided for @profileDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently removed.'**
  String get profileDeleteDialogBody;

  /// No description provided for @profileDeleteConfirmField.
  ///
  /// In en, this message translates to:
  /// **'Type your phone number ({phone}) to delete your account'**
  String profileDeleteConfirmField(String phone);

  /// No description provided for @campusLabel.
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get campusLabel;

  /// No description provided for @subjectSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your subjects'**
  String get subjectSelectionTitle;

  /// No description provided for @onboardingReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Details'**
  String get onboardingReviewTitle;

  /// No description provided for @onboardingReviewHeadline.
  ///
  /// In en, this message translates to:
  /// **'Review Your Details'**
  String get onboardingReviewHeadline;

  /// No description provided for @onboardingReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure everything looks right before you continue.'**
  String get onboardingReviewSubtitle;

  /// No description provided for @onboardingReviewNoTeacher.
  ///
  /// In en, this message translates to:
  /// **'No teacher assigned'**
  String get onboardingReviewNoTeacher;

  /// No description provided for @studentHomeWelcomeName.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}! 👋'**
  String studentHomeWelcomeName(String name);

  /// No description provided for @studentHomeWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to keep the streak going?'**
  String get studentHomeWelcomeSubtitle;

  /// No description provided for @progressEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attempted tests yet. Take a test from the Home tab to see your progress here.'**
  String get progressEmpty;

  /// No description provided for @progressAttempted.
  ///
  /// In en, this message translates to:
  /// **'Attempted tests'**
  String get progressAttempted;

  /// No description provided for @teacherOverviewWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get teacherOverviewWelcome;

  /// No description provided for @teacherOverviewWelcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}! 👋'**
  String teacherOverviewWelcomeName(String name);

  /// No description provided for @teacherOverviewWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s how your students are doing'**
  String get teacherOverviewWelcomeSubtitle;

  /// No description provided for @teacherOverviewActualEarnings.
  ///
  /// In en, this message translates to:
  /// **'Actual earnings'**
  String get teacherOverviewActualEarnings;

  /// No description provided for @teacherOverviewProjectedEarnings.
  ///
  /// In en, this message translates to:
  /// **'Projected earnings'**
  String get teacherOverviewProjectedEarnings;

  /// No description provided for @teacherStudentsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search students'**
  String get teacherStudentsSearch;

  /// No description provided for @teacherEarningsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total earnings'**
  String get teacherEarningsTotal;

  /// No description provided for @liveTestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Tests'**
  String get liveTestsTitle;

  /// No description provided for @testListTitle.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get testListTitle;

  /// No description provided for @testBadgeFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get testBadgeFree;

  /// No description provided for @testResultsScore.
  ///
  /// In en, this message translates to:
  /// **'Your score'**
  String get testResultsScore;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get otpVerified;

  /// No description provided for @boardClassSelectEmpty.
  ///
  /// In en, this message translates to:
  /// **'No board/classes are available yet.'**
  String get boardClassSelectEmpty;

  /// No description provided for @subjectTeacherSelectPrerequisites.
  ///
  /// In en, this message translates to:
  /// **'Go back and choose a campus and board/class first.'**
  String get subjectTeacherSelectPrerequisites;

  /// No description provided for @subjectTeacherSelectNoSubjects.
  ///
  /// In en, this message translates to:
  /// **'No subjects are available for this board/class yet.'**
  String get subjectTeacherSelectNoSubjects;

  /// No description provided for @subjectTeacherSelectNoTeachers.
  ///
  /// In en, this message translates to:
  /// **'No teachers available at your campus for this subject yet.'**
  String get subjectTeacherSelectNoTeachers;

  /// No description provided for @subjectTeacherSelectTeacherLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher (optional)'**
  String get subjectTeacherSelectTeacherLabel;

  /// No description provided for @subjectTeacherSelectDiscountApplied.
  ///
  /// In en, this message translates to:
  /// **'Discount applied'**
  String get subjectTeacherSelectDiscountApplied;

  /// No description provided for @assignTeacherSelfStudyTitle.
  ///
  /// In en, this message translates to:
  /// **'Self-study (No Teacher)'**
  String get assignTeacherSelfStudyTitle;

  /// No description provided for @assignTeacherSelfStudySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study independently without campus teacher discount'**
  String get assignTeacherSelfStudySubtitle;

  /// No description provided for @assignTeacherCampusTeacherLabel.
  ///
  /// In en, this message translates to:
  /// **'Campus Teacher'**
  String get assignTeacherCampusTeacherLabel;

  /// No description provided for @assignTeacherSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Teacher assigned successfully'**
  String get assignTeacherSavedSuccess;

  /// No description provided for @assignTeacherSetSelfStudy.
  ///
  /// In en, this message translates to:
  /// **'Set to self-study'**
  String get assignTeacherSetSelfStudy;

  /// No description provided for @chapterAssignedTeacherFallback.
  ///
  /// In en, this message translates to:
  /// **'Assigned Teacher'**
  String get chapterAssignedTeacherFallback;

  /// No description provided for @chapterSelfStudyLabel.
  ///
  /// In en, this message translates to:
  /// **'Self-study (No teacher)'**
  String get chapterSelfStudyLabel;

  /// No description provided for @teacherAccountAlreadySetUp.
  ///
  /// In en, this message translates to:
  /// **'Your teacher account is already set up.'**
  String get teacherAccountAlreadySetUp;

  /// No description provided for @teacherSignupNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get teacherSignupNameError;

  /// No description provided for @teacherSignupCampusError.
  ///
  /// In en, this message translates to:
  /// **'Select your campus.'**
  String get teacherSignupCampusError;

  /// No description provided for @teacherSignupSubjectsError.
  ///
  /// In en, this message translates to:
  /// **'Select at least one subject you teach.'**
  String get teacherSignupSubjectsError;

  /// No description provided for @teacherSignupClassesLabel.
  ///
  /// In en, this message translates to:
  /// **'Classes you teach'**
  String get teacherSignupClassesLabel;

  /// No description provided for @teacherSignupClassesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No board/classes are open yet.'**
  String get teacherSignupClassesEmpty;

  /// No description provided for @teacherSignupSubjectsLabel.
  ///
  /// In en, this message translates to:
  /// **'Subjects you teach'**
  String get teacherSignupSubjectsLabel;

  /// No description provided for @teacherSignupSelectClassFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a class above first.'**
  String get teacherSignupSelectClassFirst;

  /// No description provided for @teacherSignupNoSubjectsFound.
  ///
  /// In en, this message translates to:
  /// **'No subjects found for the selected classes.'**
  String get teacherSignupNoSubjectsFound;

  /// No description provided for @teacherSignupApproxStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of students you teach (optional)'**
  String get teacherSignupApproxStudentsLabel;

  /// No description provided for @teacherSignupSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit for approval'**
  String get teacherSignupSubmitButton;

  /// No description provided for @teacherPendingNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find your teacher profile yet.'**
  String get teacherPendingNotFound;

  /// No description provided for @teacherPendingAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending Admin approval.'**
  String get teacherPendingAccountStatus;

  /// No description provided for @teacherApprovedAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'You\'re approved! You can continue into the app.'**
  String get teacherApprovedAccountStatus;

  /// No description provided for @teacherApprovedNote.
  ///
  /// In en, this message translates to:
  /// **'Approval is complete for {name}.'**
  String teacherApprovedNote(String name);

  /// No description provided for @teacherPendingCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'Check status'**
  String get teacherPendingCheckStatus;

  /// No description provided for @teacherPendingStillPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your registration is pending approval.'**
  String get teacherPendingStillPendingMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @chapterListTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapterListTitle;

  /// No description provided for @chapterListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No chapters are available for this subject yet.'**
  String get chapterListEmpty;

  /// No description provided for @chapterOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter {order}'**
  String chapterOrderLabel(int order);

  /// No description provided for @chapterFreeBadge.
  ///
  /// In en, this message translates to:
  /// **'2 free'**
  String get chapterFreeBadge;

  /// No description provided for @chapterActionAttemptTest.
  ///
  /// In en, this message translates to:
  /// **'Attempt Test'**
  String get chapterActionAttemptTest;

  /// No description provided for @chapterActionWatchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get chapterActionWatchVideo;

  /// No description provided for @chapterVideoOpenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the video. Please try again.'**
  String get chapterVideoOpenError;

  /// No description provided for @ebookBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Ebook'**
  String get ebookBannerTitle;

  /// No description provided for @ebookBannerProcessing.
  ///
  /// In en, this message translates to:
  /// **'Ebook processing…'**
  String get ebookBannerProcessing;

  /// No description provided for @ebookLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Purchase this subject to access the ebook.'**
  String get ebookLockedMessage;

  /// No description provided for @ebookReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Ebook'**
  String get ebookReaderTitle;

  /// No description provided for @ebookGoToPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Go to page'**
  String get ebookGoToPageTitle;

  /// No description provided for @ebookGoToPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page number'**
  String get ebookGoToPageLabel;

  /// No description provided for @ebookGoToPageButton.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get ebookGoToPageButton;

  /// No description provided for @ebookGoToPageInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a page between 1 and {total}'**
  String ebookGoToPageInvalid(int total);

  /// No description provided for @testKindGuessPaper.
  ///
  /// In en, this message translates to:
  /// **'Subject-wise guess paper'**
  String get testKindGuessPaper;

  /// No description provided for @testKindSimplePaper.
  ///
  /// In en, this message translates to:
  /// **'Subject-wise paper'**
  String get testKindSimplePaper;

  /// No description provided for @testKindChapterWise.
  ///
  /// In en, this message translates to:
  /// **'Chapter-wise test'**
  String get testKindChapterWise;

  /// No description provided for @testListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tests are available for this chapter yet.'**
  String get testListEmpty;

  /// No description provided for @studentHomeNoSubjects.
  ///
  /// In en, this message translates to:
  /// **'No subjects selected yet. Complete onboarding to see your subjects here.'**
  String get studentHomeNoSubjects;

  /// No description provided for @liveTestScheduledSingle.
  ///
  /// In en, this message translates to:
  /// **'A live test is scheduled'**
  String get liveTestScheduledSingle;

  /// No description provided for @liveTestScheduledMultiple.
  ///
  /// In en, this message translates to:
  /// **'{count} live tests are scheduled'**
  String liveTestScheduledMultiple(int count);

  /// No description provided for @profileEmptyFields.
  ///
  /// In en, this message translates to:
  /// **'Name and phone number cannot be empty.'**
  String get profileEmptyFields;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update profile.'**
  String get profileUpdateFailed;

  /// No description provided for @profileDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete account.'**
  String get profileDeleteFailed;

  /// No description provided for @averageScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall average score'**
  String get averageScoreLabel;

  /// No description provided for @testsAttemptedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tests attempted'**
  String testsAttemptedCount(int count);

  /// No description provided for @testAnswerLongLabel.
  ///
  /// In en, this message translates to:
  /// **'Your detailed answer'**
  String get testAnswerLongLabel;

  /// No description provided for @testAnswerShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get testAnswerShortLabel;

  /// No description provided for @cartRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cartRemoveTooltip;

  /// No description provided for @checkoutRedirecting.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to payment gateway...'**
  String get checkoutRedirecting;

  /// No description provided for @checkoutFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment could not be completed. Please try again.'**
  String get checkoutFailedMessage;

  /// No description provided for @checkoutSuccessStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get checkoutSuccessStatus;

  /// No description provided for @checkoutPendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get checkoutPendingStatus;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @testTakingTitle.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testTakingTitle;

  /// No description provided for @testLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading test...'**
  String get testLoadingMessage;

  /// No description provided for @testExitDialogStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get testExitDialogStay;

  /// No description provided for @testNotPurchasedMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to purchase this test before you can attempt it. Add it to your cart from the test list to unlock it.'**
  String get testNotPurchasedMessage;

  /// No description provided for @testNoQuestionsFound.
  ///
  /// In en, this message translates to:
  /// **'No questions found for this test.'**
  String get testNoQuestionsFound;

  /// No description provided for @testGradingInProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Grading your answers…'**
  String get testGradingInProgressMessage;

  /// No description provided for @testSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit your test. Please try again.'**
  String get testSubmitFailed;

  /// No description provided for @testResultsStrongChapters.
  ///
  /// In en, this message translates to:
  /// **'Strong chapters'**
  String get testResultsStrongChapters;

  /// No description provided for @testResultsWeakChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters to review'**
  String get testResultsWeakChapters;

  /// No description provided for @teacherProfileUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Your teacher profile is not available right now.'**
  String get teacherProfileUnavailable;

  /// No description provided for @teacherOverviewNotSetYet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get teacherOverviewNotSetYet;

  /// No description provided for @teacherOverviewNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get teacherOverviewNotAvailable;

  /// No description provided for @teacherStudentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No students yet. Students who select you as their subject teacher will show up here.'**
  String get teacherStudentsEmpty;

  /// No description provided for @teacherStudentsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get teacherStudentsSearchHint;

  /// No description provided for @teacherStudentsSearchNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No students match your search.'**
  String get teacherStudentsSearchNoMatch;

  /// No description provided for @studentProgressDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Student progress'**
  String get studentProgressDetailTitle;

  /// No description provided for @studentProgressDetailEmpty.
  ///
  /// In en, this message translates to:
  /// **'No test attempts yet for this student.'**
  String get studentProgressDetailEmpty;

  /// No description provided for @teacherEarningsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No earnings yet. Earnings show up here as soon as your students purchase a paid pack.'**
  String get teacherEarningsEmpty;

  /// No description provided for @teacherEarningsTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String teacherEarningsTransactionCount(int count);

  /// No description provided for @teacherEarningsBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings breakdown'**
  String get teacherEarningsBreakdownTitle;

  /// No description provided for @teacherEarningsTriggerPaidPackPurchase.
  ///
  /// In en, this message translates to:
  /// **'Paid pack purchases'**
  String get teacherEarningsTriggerPaidPackPurchase;

  /// No description provided for @liveTestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No live tests are scheduled right now. Admin schedules these occasionally — check back later.'**
  String get liveTestsEmpty;

  /// No description provided for @liveTestDateTba.
  ///
  /// In en, this message translates to:
  /// **'Live date to be announced'**
  String get liveTestDateTba;

  /// No description provided for @liveTestEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get liveTestEnter;

  /// No description provided for @liveTestDateFormatted.
  ///
  /// In en, this message translates to:
  /// **'Live on {date}'**
  String liveTestDateFormatted(String date);

  /// No description provided for @cartItemTestCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tests'**
  String cartItemTestCount(int count);

  /// No description provided for @chapterListAddToCartButton.
  ///
  /// In en, this message translates to:
  /// **'Add to cart — Rs. {price}'**
  String chapterListAddToCartButton(String price);

  /// No description provided for @chapterListPurchasedBadge.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get chapterListPurchasedBadge;

  /// No description provided for @chapterListAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get chapterListAddedToCart;

  /// No description provided for @subjectCardOwnedBadge.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get subjectCardOwnedBadge;

  /// No description provided for @subjectCardInCartBadge.
  ///
  /// In en, this message translates to:
  /// **'In Cart'**
  String get subjectCardInCartBadge;

  /// No description provided for @subjectCardAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Rs. {price}'**
  String subjectCardAddToCart(String price);

  /// No description provided for @subjectCardAddToCartGeneric.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get subjectCardAddToCartGeneric;

  /// No description provided for @subjectCardExploreHint.
  ///
  /// In en, this message translates to:
  /// **'Explore chapters'**
  String get subjectCardExploreHint;

  /// No description provided for @metaQuestions.
  ///
  /// In en, this message translates to:
  /// **'ques'**
  String get metaQuestions;

  /// No description provided for @metaMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get metaMinutes;

  /// No description provided for @testUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get testUnlock;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @subjectBundleTitle.
  ///
  /// In en, this message translates to:
  /// **'{subjectName} Full Bundle'**
  String subjectBundleTitle(String subjectName);

  /// No description provided for @subjectBundleDiscount.
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String subjectBundleDiscount(int percent);

  /// No description provided for @buyNowWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Buy Now • Rs. {price}'**
  String buyNowWithPrice(String price);

  /// No description provided for @personalizedPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized Practice'**
  String get personalizedPracticeTitle;

  /// No description provided for @practiceBankCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Question Bank'**
  String get practiceBankCardTitle;

  /// No description provided for @practiceBankCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice all questions of this topic at your own pace, no timer'**
  String get practiceBankCardSubtitle;

  /// No description provided for @attemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} free attempts left'**
  String attemptsRemaining(int remaining, int total);

  /// No description provided for @attemptsUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get attemptsUpgrade;

  /// No description provided for @practiceHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How Practice Question Bank works?'**
  String get practiceHowTitle;

  /// No description provided for @practiceBullet1.
  ///
  /// In en, this message translates to:
  /// **'Practice & revise questions from all tests of this topic.'**
  String get practiceBullet1;

  /// No description provided for @practiceBullet2.
  ///
  /// In en, this message translates to:
  /// **'Learn at your pace without any timer or test submission.'**
  String get practiceBullet2;

  /// No description provided for @practiceBullet3.
  ///
  /// In en, this message translates to:
  /// **'Some questions might repeat from tests you\'ve already taken.'**
  String get practiceBullet3;

  /// No description provided for @practiceOkayGotIt.
  ///
  /// In en, this message translates to:
  /// **'Okay, Got it!'**
  String get practiceOkayGotIt;

  /// No description provided for @attemptsExhaustedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all free attempts'**
  String get attemptsExhaustedTitle;

  /// No description provided for @attemptsExhaustedBody.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to keep practicing. Chapters stay locked until your payment is confirmed.'**
  String get attemptsExhaustedBody;

  /// No description provided for @attemptsBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your free attempts. Upgrade to continue.'**
  String get attemptsBlockedMessage;

  /// No description provided for @scoreCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get scoreCorrect;

  /// No description provided for @scoreWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get scoreWrong;

  /// No description provided for @scoreTimeTaken.
  ///
  /// In en, this message translates to:
  /// **'Time Taken'**
  String get scoreTimeTaken;

  /// No description provided for @scoreTimeValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String scoreTimeValue(int minutes);

  /// No description provided for @sectionBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Section Breakdown'**
  String get sectionBreakdownTitle;

  /// No description provided for @reviewAnswersButton.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswersButton;

  /// No description provided for @sectionTypeMcq.
  ///
  /// In en, this message translates to:
  /// **'MCQs'**
  String get sectionTypeMcq;

  /// No description provided for @sectionTypeShort.
  ///
  /// In en, this message translates to:
  /// **'Short Questions'**
  String get sectionTypeShort;

  /// No description provided for @sectionTypeLong.
  ///
  /// In en, this message translates to:
  /// **'Long Questions'**
  String get sectionTypeLong;

  /// No description provided for @reviewAnswersTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswersTitle;

  /// No description provided for @reviewQuestionNumber.
  ///
  /// In en, this message translates to:
  /// **'QUESTION {number}'**
  String reviewQuestionNumber(int number);

  /// No description provided for @reviewQuestionOverline.
  ///
  /// In en, this message translates to:
  /// **'QUESTION {number} • {status}'**
  String reviewQuestionOverline(int number, String status);

  /// No description provided for @statusCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get statusCorrect;

  /// No description provided for @statusNeedsPractice.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice'**
  String get statusNeedsPractice;

  /// No description provided for @reviewCorrectAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get reviewCorrectAnswerLabel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @coursesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get coursesFilterAll;

  /// No description provided for @progressAllSubjects.
  ///
  /// In en, this message translates to:
  /// **'All subjects'**
  String get progressAllSubjects;

  /// No description provided for @progressSubjectFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get progressSubjectFilterLabel;

  /// No description provided for @progressAttemptFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Attempt'**
  String get progressAttemptFilterLabel;

  /// No description provided for @progressChapterProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter progress'**
  String get progressChapterProgressTitle;

  /// No description provided for @attemptNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Attempt {n}'**
  String attemptNumberLabel(int n);

  /// No description provided for @submitTestDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit test?'**
  String get submitTestDialogTitle;

  /// No description provided for @submitTestDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to change your answers after submitting.'**
  String get submitTestDialogBody;

  /// No description provided for @submitTestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitTestConfirm;

  /// No description provided for @studentBasicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get studentBasicInfoTitle;

  /// No description provided for @studentBasicInfoHeadline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you set up'**
  String get studentBasicInfoHeadline;

  /// No description provided for @studentBasicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us your name and the campus you\'re enrolled in so we can personalize your test prep.'**
  String get studentBasicInfoSubtitle;

  /// No description provided for @studentAcademicInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Academic Info'**
  String get studentAcademicInfoTitle;

  /// No description provided for @studentAcademicInfoHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your class & subjects'**
  String get studentAcademicInfoHeadline;

  /// No description provided for @studentAcademicInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your class, then pick the subjects you want to prepare for.'**
  String get studentAcademicInfoSubtitle;

  /// No description provided for @studentAcademicInfoClassLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get studentAcademicInfoClassLabel;

  /// No description provided for @studentAcademicInfoGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get studentAcademicInfoGroupLabel;

  /// No description provided for @teacherSignupHeadline.
  ///
  /// In en, this message translates to:
  /// **'Register as a teacher'**
  String get teacherSignupHeadline;

  /// No description provided for @teacherSignupAboutYouSection.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get teacherSignupAboutYouSection;

  /// No description provided for @teacherSignupWhatYouTeachSection.
  ///
  /// In en, this message translates to:
  /// **'What you teach'**
  String get teacherSignupWhatYouTeachSection;

  /// No description provided for @teacherSignupOptionalSection.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get teacherSignupOptionalSection;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get navStudents;

  /// No description provided for @navEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navEarnings;

  /// No description provided for @subjectComputerScience.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get subjectComputerScience;

  /// No description provided for @subjectPhysics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get subjectPhysics;

  /// No description provided for @subjectChemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get subjectChemistry;

  /// No description provided for @subjectBiology.
  ///
  /// In en, this message translates to:
  /// **'Biology'**
  String get subjectBiology;

  /// No description provided for @subjectMathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get subjectMathematics;

  /// No description provided for @subjectMath.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get subjectMath;

  /// No description provided for @subjectEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get subjectEnglish;

  /// No description provided for @subjectUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get subjectUrdu;

  /// No description provided for @subjectScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get subjectScience;

  /// No description provided for @subjectAccounting.
  ///
  /// In en, this message translates to:
  /// **'Principles of Accounting'**
  String get subjectAccounting;

  /// No description provided for @subjectBusinessMath.
  ///
  /// In en, this message translates to:
  /// **'Business Mathematics'**
  String get subjectBusinessMath;

  /// No description provided for @subjectEconomics.
  ///
  /// In en, this message translates to:
  /// **'Economics'**
  String get subjectEconomics;

  /// No description provided for @subjectEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get subjectEducation;

  /// No description provided for @subjectCivics.
  ///
  /// In en, this message translates to:
  /// **'Civics'**
  String get subjectCivics;

  /// No description provided for @promoTeacherDiscountTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Referral Offer'**
  String get promoTeacherDiscountTitle;

  /// No description provided for @promoTeacherDiscountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your teacher code to get 15% discount on all subjects'**
  String get promoTeacherDiscountSubtitle;

  /// No description provided for @promoPracticeBankTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized Practice'**
  String get promoPracticeBankTitle;

  /// No description provided for @promoPracticeBankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sharpen exam prep with targeted chapter question banks'**
  String get promoPracticeBankSubtitle;

  /// No description provided for @progressAllAttempts.
  ///
  /// In en, this message translates to:
  /// **'All Attempts'**
  String get progressAllAttempts;

  /// No description provided for @progressLatestAttempt.
  ///
  /// In en, this message translates to:
  /// **'Latest Attempt'**
  String get progressLatestAttempt;

  /// No description provided for @progressNoChaptersFound.
  ///
  /// In en, this message translates to:
  /// **'No chapter attempts found for this selection.'**
  String get progressNoChaptersFound;

  /// No description provided for @progressViewResult.
  ///
  /// In en, this message translates to:
  /// **'View Result'**
  String get progressViewResult;

  /// No description provided for @progressLoadingResult.
  ///
  /// In en, this message translates to:
  /// **'Loading results...'**
  String get progressLoadingResult;

  /// No description provided for @progressAttemptSingular.
  ///
  /// In en, this message translates to:
  /// **'1 attempt'**
  String get progressAttemptSingular;

  /// No description provided for @progressAttemptPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} attempts'**
  String progressAttemptPlural(int count);

  /// No description provided for @teacherSignupSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Registration'**
  String get teacherSignupSummaryTitle;

  /// No description provided for @teacherSignupSummaryName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get teacherSignupSummaryName;

  /// No description provided for @teacherSignupSummaryCampus.
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get teacherSignupSummaryCampus;

  /// No description provided for @teacherSignupSummaryClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get teacherSignupSummaryClasses;

  /// No description provided for @teacherSignupSummarySubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get teacherSignupSummarySubjects;

  /// No description provided for @teacherSignupSummaryStudents.
  ///
  /// In en, this message translates to:
  /// **'Declared Students'**
  String get teacherSignupSummaryStudents;

  /// No description provided for @teacherWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name} 👋'**
  String teacherWelcomeBack(String name);

  /// No description provided for @teacherActualEarnings.
  ///
  /// In en, this message translates to:
  /// **'Actual Earnings'**
  String get teacherActualEarnings;

  /// No description provided for @teacherProjectedEarnings.
  ///
  /// In en, this message translates to:
  /// **'Projected Earnings'**
  String get teacherProjectedEarnings;

  /// No description provided for @teacherCommissionAndEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get teacherCommissionAndEarnings;

  /// No description provided for @teacherPerStudentRate.
  ///
  /// In en, this message translates to:
  /// **'Rs. 500 / Student'**
  String get teacherPerStudentRate;

  /// No description provided for @teacherUnlockUpTo.
  ///
  /// In en, this message translates to:
  /// **'Unlock up to {amount} more!'**
  String teacherUnlockUpTo(String amount);

  /// No description provided for @teacherDeclaredStudentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Based on your ~{declared} declared students ({onboarded} joined, {remaining} remaining).'**
  String teacherDeclaredStudentsDesc(
    int declared,
    int onboarded,
    int remaining,
  );

  /// No description provided for @teacherGoalOnboarded.
  ///
  /// In en, this message translates to:
  /// **'{onboarded} of {declared} onboarded'**
  String teacherGoalOnboarded(int onboarded, int declared);

  /// No description provided for @teacherQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get teacherQuickActions;

  /// No description provided for @teacherStudentsRoster.
  ///
  /// In en, this message translates to:
  /// **'Students ({count})'**
  String teacherStudentsRoster(int count);

  /// No description provided for @teacherStudentsRosterSub.
  ///
  /// In en, this message translates to:
  /// **'{paid} Paid • {free} Free'**
  String teacherStudentsRosterSub(int paid, int free);

  /// No description provided for @teacherEarningsLedger.
  ///
  /// In en, this message translates to:
  /// **'Earnings Ledger'**
  String get teacherEarningsLedger;

  /// No description provided for @teacherEarningsLedgerSub.
  ///
  /// In en, this message translates to:
  /// **'View transactions'**
  String get teacherEarningsLedgerSub;

  /// No description provided for @teacherShareReferral.
  ///
  /// In en, this message translates to:
  /// **'Share Referral'**
  String get teacherShareReferral;

  /// No description provided for @teacherShareReferralSub.
  ///
  /// In en, this message translates to:
  /// **'Invite students'**
  String get teacherShareReferralSub;

  /// No description provided for @teacherRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get teacherRecentActivity;

  /// No description provided for @teacherAllStudents.
  ///
  /// In en, this message translates to:
  /// **'All Students'**
  String get teacherAllStudents;

  /// No description provided for @teacherActivePaid.
  ///
  /// In en, this message translates to:
  /// **'Active (Paid)'**
  String get teacherActivePaid;

  /// No description provided for @teacherFreeUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Free (Unpaid)'**
  String get teacherFreeUnpaid;

  /// No description provided for @teacherCommissionEarned.
  ///
  /// In en, this message translates to:
  /// **'+Rs. 500 Earned'**
  String get teacherCommissionEarned;

  /// No description provided for @teacherBundleNotPurchased.
  ///
  /// In en, this message translates to:
  /// **'Bundle not purchased yet'**
  String get teacherBundleNotPurchased;

  /// No description provided for @teacherViewProgress.
  ///
  /// In en, this message translates to:
  /// **'View Progress'**
  String get teacherViewProgress;

  /// No description provided for @teacherSortRecentlyJoined.
  ///
  /// In en, this message translates to:
  /// **'Recently Joined'**
  String get teacherSortRecentlyJoined;

  /// No description provided for @teacherSortTopPerformers.
  ///
  /// In en, this message translates to:
  /// **'Top Test Performers'**
  String get teacherSortTopPerformers;

  /// No description provided for @teacherSortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical (A-Z)'**
  String get teacherSortAlphabetical;

  /// No description provided for @teacherAllCampuses.
  ///
  /// In en, this message translates to:
  /// **'All Campuses'**
  String get teacherAllCampuses;

  /// No description provided for @teacherSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by student name or phone...'**
  String get teacherSearchHint;

  /// No description provided for @teacherProfileCampusesTaught.
  ///
  /// In en, this message translates to:
  /// **'Campuses & Institutions'**
  String get teacherProfileCampusesTaught;

  /// No description provided for @teacherProfileClassesTaught.
  ///
  /// In en, this message translates to:
  /// **'Classes Taught'**
  String get teacherProfileClassesTaught;

  /// No description provided for @teacherProfileSubjectsTaught.
  ///
  /// In en, this message translates to:
  /// **'Subjects Taught'**
  String get teacherProfileSubjectsTaught;

  /// No description provided for @teacherProfileDeclaredReach.
  ///
  /// In en, this message translates to:
  /// **'Declared Student Reach'**
  String get teacherProfileDeclaredReach;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get notificationsClearAll;

  /// No description provided for @notificationsClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Notifications?'**
  String get notificationsClearConfirmTitle;

  /// No description provided for @notificationsClearConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all notifications from your feed?'**
  String get notificationsClearConfirmMessage;

  /// No description provided for @teacherNavOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get teacherNavOverview;

  /// No description provided for @teacherNavStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get teacherNavStudents;

  /// No description provided for @teacherNavEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get teacherNavEarnings;

  /// No description provided for @homeNavNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNavNotifications;

  /// No description provided for @teacherVerifyNewPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify New Phone Number'**
  String get teacherVerifyNewPhoneTitle;

  /// No description provided for @teacherVerifyPhoneOtpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit verification code has been sent to {phone}.'**
  String teacherVerifyPhoneOtpSentMessage(String phone);

  /// No description provided for @teacherOtpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-Digit OTP Code'**
  String get teacherOtpCodeLabel;

  /// No description provided for @teacherOtpTestHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent you'**
  String get teacherOtpTestHint;

  /// No description provided for @teacherOtpEnterCodeError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code.'**
  String get teacherOtpEnterCodeError;

  /// No description provided for @teacherOtpInvalidCodeError.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code. Please try again.'**
  String get teacherOtpInvalidCodeError;

  /// No description provided for @teacherVerifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Azeem Verified Faculty'**
  String get teacherVerifiedBadge;

  /// No description provided for @studentVerifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Azeem Verified Student'**
  String get studentVerifiedBadge;

  /// No description provided for @teacherDefaultCampusFallback.
  ///
  /// In en, this message translates to:
  /// **'Bahawalpur Campus'**
  String get teacherDefaultCampusFallback;

  /// No description provided for @teacherStudentsEnrolledCount.
  ///
  /// In en, this message translates to:
  /// **'~{count} Students Enrolled'**
  String teacherStudentsEnrolledCount(int count);

  /// No description provided for @teacherPurchasesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Purchases'**
  String teacherPurchasesCount(int count);

  /// No description provided for @teacherCommissionHistory.
  ///
  /// In en, this message translates to:
  /// **'Earnings History'**
  String get teacherCommissionHistory;

  /// No description provided for @teacherEarningsShowingRange.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}–{end} of {total} records'**
  String teacherEarningsShowingRange(int start, int end, int total);

  /// No description provided for @teacherProjectedSimulatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Projected Earnings Simulator'**
  String get teacherProjectedSimulatorTitle;

  /// No description provided for @teacherPerPackRate.
  ///
  /// In en, this message translates to:
  /// **'Rs. 500/pack'**
  String get teacherPerPackRate;

  /// No description provided for @teacherTotalProjectedEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Projected Earnings'**
  String get teacherTotalProjectedEarnings;

  /// No description provided for @teacherSimulatorPrompt.
  ///
  /// In en, this message translates to:
  /// **'If {count} more of your remaining declared students buy a test pack:'**
  String teacherSimulatorPrompt(int count);

  /// No description provided for @teacherZeroStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'0 Students'**
  String get teacherZeroStudentsLabel;

  /// No description provided for @teacherAllRemainingStudents.
  ///
  /// In en, this message translates to:
  /// **'All {count} Remaining Students'**
  String teacherAllRemainingStudents(int count);

  /// No description provided for @teacherGoalReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 Goal reached! All declared students are currently onboarded.'**
  String get teacherGoalReachedMessage;

  /// No description provided for @teacherEarningsRecordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name} • Test Bundle'**
  String teacherEarningsRecordSubtitle(String name);

  /// No description provided for @teacherStudentPackPurchaseFallback.
  ///
  /// In en, this message translates to:
  /// **'Student Pack Purchase'**
  String get teacherStudentPackPurchaseFallback;

  /// No description provided for @commonNoOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No options available.'**
  String get commonNoOptionsAvailable;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @teacherSignupSummaryStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String teacherSignupSummaryStudentsCount(int count);

  /// No description provided for @teacherSignupSummaryNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified (Optional)'**
  String get teacherSignupSummaryNotSpecified;

  /// No description provided for @commonNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'None selected'**
  String get commonNoneSelected;

  /// No description provided for @teacherReferralShareText.
  ///
  /// In en, this message translates to:
  /// **'Join Azeem Publications App and choose me as your teacher to access verified board test packs!'**
  String get teacherReferralShareText;

  /// No description provided for @teacherReferralLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Teacher invite link copied to clipboard!'**
  String get teacherReferralLinkCopied;

  /// No description provided for @teacherRecentActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recent activity yet.'**
  String get teacherRecentActivityEmpty;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeAgoMinutes(int count);

  /// No description provided for @timeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeAgoHours(int count);

  /// No description provided for @timeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeAgoDays(int count);

  /// No description provided for @studentProgressNoAttemptsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Test Attempts Yet'**
  String get studentProgressNoAttemptsTitle;

  /// No description provided for @studentProgressNoAttemptsBody.
  ///
  /// In en, this message translates to:
  /// **'This student has not submitted any chapter tests yet.'**
  String get studentProgressNoAttemptsBody;

  /// No description provided for @studentEnrolledWithYouLabel.
  ///
  /// In en, this message translates to:
  /// **'Enrolled with you in: {subjects}'**
  String studentEnrolledWithYouLabel(String subjects);

  /// No description provided for @studentGeneralEnrolledFallback.
  ///
  /// In en, this message translates to:
  /// **'General Enrolled'**
  String get studentGeneralEnrolledFallback;

  /// No description provided for @commonSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get commonSort;

  /// No description provided for @teacherStudentsShowingRange.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}–{end} of {total} students'**
  String teacherStudentsShowingRange(int start, int end, int total);

  /// No description provided for @commonPageOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Page {page} / {total}'**
  String commonPageOfTotal(int page, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
