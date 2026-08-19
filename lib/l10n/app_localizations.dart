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
  /// **'Welcome to Azeem Publications'**
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

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
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

  /// No description provided for @phoneCountryCode.
  ///
  /// In en, this message translates to:
  /// **'+92'**
  String get phoneCountryCode;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'3XX XXXXXXX'**
  String get phoneHint;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
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
  /// **'Enter the 4-digit code sent to {phone}'**
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

  /// No description provided for @teacherOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacherOverviewTitle;

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
  /// **'Earnings & Commission'**
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
  /// **'Classes you teach (optional)'**
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
  /// **'Approx. number of students (optional)'**
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
  /// **'No commissions yet. Earnings show up here as soon as your students purchase a paid pack.'**
  String get teacherEarningsEmpty;

  /// No description provided for @teacherEarningsTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String teacherEarningsTransactionCount(int count);

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
