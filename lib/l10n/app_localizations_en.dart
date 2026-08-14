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
  String get subjectCountTitle => 'How many subjects are you studying?';

  @override
  String get subjectCountSubtitle => 'Choose a number between 1 and 8';

  @override
  String get subjectSelectionTitle => 'Select your subjects';

  @override
  String get subjectSelectionSubtitle =>
      'Select your enrolled subjects to customize your study dashboard.';

  @override
  String subjectSelectionLabel(int index) {
    return 'Subject $index';
  }

  @override
  String get subjectSelectionHint => 'Choose a subject';

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
}
