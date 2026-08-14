import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

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

  /// No description provided for @subjectCountTitle.
  ///
  /// In en, this message translates to:
  /// **'How many subjects are you studying?'**
  String get subjectCountTitle;

  /// No description provided for @subjectCountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a number between 1 and 8'**
  String get subjectCountSubtitle;

  /// No description provided for @subjectSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your subjects'**
  String get subjectSelectionTitle;

  /// No description provided for @subjectSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your enrolled subjects to customize your study dashboard.'**
  String get subjectSelectionSubtitle;

  /// No description provided for @subjectSelectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject {index}'**
  String subjectSelectionLabel(int index);

  /// No description provided for @subjectSelectionHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a subject'**
  String get subjectSelectionHint;

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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
