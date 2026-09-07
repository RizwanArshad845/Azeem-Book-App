# Azeem Digital Testing System — Comprehensive Error Handling & Display Audit & Implementation Blueprint

**Document Version:** 1.0.0  
**Target Platform:** Flutter (Android & iOS) / Clean Architecture + MVVM + Riverpod  
**Scope:** Exhaustive audit of all 15 feature modules, core network interceptors, domain failure taxonomies, shared UI widgets, and bilingual localization (English & Urdu).  
**Constraint:** Architectural analysis and implementation specification only. No Dart or ARB source code is modified in this step.

---

## 1. Executive Summary

A comprehensive, line-by-line audit across all 15 presentation feature domains, core network interceptors, domain failure definitions, and shared UI widgets was conducted to evaluate how exceptions, network failures, validation errors, and server states are communicated to end users.

### Core Verdict
The application has solid foundational Clean Architecture abstractions (`Result<T>`, `Failure`, `guardRequest`), but suffers from **systemic presentation and parsing anti-patterns**:
1. **The "Toast-and-Ghost" Anti-Pattern:** Critical form submissions (Teacher Onboarding, Student Onboarding, Profile Edits, Exam Submissions, Account Deletions) rely almost exclusively on fleeting 4-second Snackbars. When the Snackbar disappears, the screen reverts to a stagnant state with zero visible error indicators, no actionable recovery steps, and no explanation.
2. **Django REST Framework (DRF) Format Blindspot:** The network interceptor (`error_interceptor.dart`) only checks for `response.data['error']['message']`. Standard DRF responses (`{"detail": "..."}`, `{"phoneNumber": ["..."]}`, `{"non_field_errors": [...]}`) are ignored, falling back to generic English strings or exposing raw technical internals.
3. **Leaked Technical Internals:** `result_guard.dart` and `failure.dart` append raw Dart runtime exceptions (`TypeError`, `FormatException`, `DioException [bad response]`) to `details`, which are surfaced directly in UI text.
4. **Complete Absence of Urdu Localization for Failures:** The domain `Failure` hierarchy hardcodes English strings. When an Urdu-speaking user encounters an error, the error text is rendered in English, breaking app accessibility and immersion.
5. **Silent Error Swallowing & Misleading Fallbacks:** Multiple viewmodels and providers swallow failures with `failure: (_) => false` or `failure: (_) => []`. For instance:
   - Paying students are told "Buy Now" if the purchase verification API fails due to a network glitch.
   - Teachers are shown "0 Students" and "Rs. 0 Earnings" if the stats API encounters a 500 error.
   - Offline teachers checking approval status are falsely told "Your registration is pending approval".
   - Live test registration failures fail 100% silently with zero user feedback.

This document outlines every identified problem across every screen and provides an exhaustive, battle-tested blueprint to overhaul the error-handling subsystem into a modern, non-technical, localized, and resilient user experience.

---

## 2. Root Causes & Systemic Flaws

### 2.1 Flaw 1: DRF JSON Schema Blindspot in `ErrorInterceptor`
- **Location:** `lib/core/network/interceptors/error_interceptor.dart:73-86`
- **Root Cause:** The parser strictly looks for `data['error']['message']`:
  ```dart
  String? _serverMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) return message;
      }
    }
    return null;
  }
  ```
- **The Breakdown:**
  - Django REST Framework (DRF) default exceptions emit: `{"detail": "Authentication credentials were not provided."}`
  - Serializer field validation errors emit: `{"phoneNumber": ["A profile with this phone number already exists."], "name": ["This field may not be blank."]}`
  - Non-field validation errors emit: `{"non_field_errors": ["Invalid credentials or account inactive."]}`
  - HTML or string error pages emit on 502/504 Bad Gateway.
- **Consequence:** `_serverMessage` returns `null` for virtually all real DRF errors. As a result, 400 Bad Request responses (such as "Phone number already exists") are overwritten with a generic English fallback (`"The information provided is incorrect or incomplete. Please check and try again."`), completely hiding the real reason from the user.

### 2.2 Flaw 2: Technical Internals Leaked in `ResultGuard` & `Failure`
- **Location:** `lib/core/network/result_guard.dart:34-42` and `lib/domain/common/failure.dart:1-82`
- **Root Cause:**
  ```dart
  // result_guard.dart
  } on DioException catch (e, st) {
    return ResultFailure(
      failure is Failure ? failure : UnknownFailure(e.message ?? e.toString()),
    );
  } catch (e, st) {
    return ResultFailure(UnknownFailure(e.toString()));
  }
  ```
  ```dart
  // failure.dart
  class UnknownFailure extends Failure {
    const UnknownFailure([this.details]);
    final String? details;
    @override
    String get message => 'Something went wrong.${details != null ? ' $details' : ''}';
  }
  ```
- **The Breakdown:**
  - If a DTO throws a `TypeError` (e.g., `type 'Null' is not a subtype of type 'String' in type cast`) or a `FormatException` (e.g., malformed JSON), `UnknownFailure` is instantiated with the raw Dart runtime error string.
  - If a `DioException` occurs with no status code (e.g., CORS failure, DNS lookup failure, SSL certificate failure), `e.message` contains raw URLs, ports, and internal socket details.
- **Consequence:** Non-technical students and teachers see confusing errors like:
  > *"Something went wrong. DioException [bad response]: This exception was thrown because the response has a status code of 502 and RequestOptions.validateStatus was configured to throw..."*

### 2.3 Flaw 3: Hardcoded English Domain Failures & Zero Urdu Localization
- **Location:** `lib/domain/common/failure.dart:1-82`
- **Root Cause:** All `Failure` subclasses return hardcoded English getters:
  - `NetworkFailure` -> `'No internet connection.'`
  - `ServerFailure` -> `'Something went wrong on our end.'`
  - `UnauthorizedFailure` -> `'You are not authorized to do this.'`
  - `NotFoundFailure` -> `'Not found.'`
  - `AssetLoadFailure` -> `'Failed to load required data.'`
- **The Breakdown:** Clean Architecture dictates that Domain entities must remain agnostic of Flutter UI/Context. However, the presentation layer directly calls `failure.message` instead of formatting the failure using a presentation-layer localization mapper (`BuildContext.l10n`).
- **Consequence:** Even when the app language is set to Urdu (`ur`), all error popups, snackbars, and full-page error screens display English text.

### 2.4 Flaw 4: Fleeting & Misplaced Error Surfaces (`AppSnackbar` vs. Inline Cards)
- **Location:** `lib/core/widgets/app_snackbar.dart:1-12`
- **Root Cause:**
  ```dart
  class AppSnackbar {
    static void show(BuildContext context, String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }
  ```
- **The Breakdown:**
  - `AppSnackbar` uses default Material styling: no danger red color, no alert icon, no action buttons, and a default 4-second timeout.
  - Review screens (`TeacherOnboardingReviewView`, `StudentOnboardingReviewView`) rely on `AppSnackbar.show(...)` on submission failure.
- **Consequence:** If a user submits a registration and the phone number is already registered, a small black toast pops up at the very bottom of the phone screen for 4 seconds while the user's focus is on the "Confirm & Submit" button. Once the toast disappears, the screen remains blankly interactive with no clue why it didn't proceed.

### 2.5 Flaw 5: Silent Error Swallows & Misleading User Experience
- **Locations:**
  - `lib/presentation/live_test_registration/view/live_tests_view.dart` (Missing `ref.listen` on registration)
  - `lib/presentation/teacher_overview/viewmodel/teacher_overview_viewmodel.dart:45-47` (`studentsAsync.value ?? []`)
  - `lib/presentation/teacher_onboarding/view/teacher_pending_approval_view.dart:46-51` (`catch (_) => stillPendingMessage`)
  - `lib/presentation/test_taking/viewmodel/test_taking_viewmodel.dart:73-76` (`failure: (_) => false` on purchased check)
  - `lib/presentation/student_cart/viewmodel/student_cart_viewmodel.dart:128-130` (Cart wiped out on item remove failure)
- **The Breakdown:** Instead of distinguishing between "empty data" and "failed request", viewmodels conflate the two, providing misleading or outright false information to the user.

---

## 3. Comprehensive Screen-by-Screen & Component Audit Matrix

Below is the complete audit of all 15 presentation feature domains, shared widgets, and core network modules.

| ID | Screen / Component | File Path & Lines | Current Behavior & Defect | End-User Impact | Recommended Fix |
|:---|:---|:---|:---|:---|:---|
| **01** | **Error Interceptor** | [`lib/core/network/interceptors/error_interceptor.dart:73-86`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/network/interceptors/error_interceptor.dart#L73-L86) | Only parses `data['error']['message']`. Ignores DRF `detail`, field error maps, and `non_field_errors`. Falls back to generic English. | Users receive generic "The information provided is incorrect" instead of "A profile with this phone number already exists". | Update `_serverMessage` to inspect `data['detail']`, `data['non_field_errors']`, and flatten field maps (e.g. `data['phoneNumber'][0]`). |
| **02** | **Request Guard** | [`lib/core/network/result_guard.dart:23-42`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/network/result_guard.dart#L23-L42) | Wraps unmapped Dio exceptions and Dart errors with `e.message ?? e.toString()`. | Users see raw technical stack traces like `type 'Null' is not a subtype of type 'String'`. | Scrub technical messages. Pass human-readable category codes into `Failure` and log the raw stack trace only to `sl<Logger>()`. |
| **03** | **Domain Failure Taxonomy** | [`lib/domain/common/failure.dart:1-82`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/domain/common/failure.dart#L1-L82) | All 8 Failure subtypes have hardcoded English getters and append raw technical `details`. | Zero Urdu localization. Technical error dumps displayed on screen. | Keep domain `Failure` clean with typed metadata/codes; introduce `context.l10n.formatFailure(failure)` in presentation layer. |
| **04** | **Shared Error View** | [`lib/core/widgets/app_error_view.dart:1-43`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/app_error_view.dart#L1-L43) | Hardcoded English `'Retry'` button text. Calls `error is Failure ? error.message : error.toString()`. Centered unstyled column. | English button shown in Urdu mode. Raw exception names displayed. Destructive if embedded inside dropdown cards. | Add `title`, localized retry (`context.l10n.commonRetry`), error categorization, and compact inline variant. |
| **05** | **Shared Snackbar** | [`lib/core/widgets/app_snackbar.dart:1-12`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/app_snackbar.dart#L1-L12) | Plain Material snackbar with no semantic colors (red/green), no icons, default 4-second disappearance. | Transient errors disappear unnoticed, leaving users trapped on stagnant screens. | Add semantic factory methods: `showError`, `showSuccess`, `showWarning` with icons, theme colors, and floating margin. |
| **06** | **Missing Component** | `lib/core/widgets/app_error_card.dart` | No persistent inline error card exists in the application design system. | Forms cannot display structured, non-disappearing error cards with remedy action buttons. | Create `AppErrorCard` widget supporting title, message, remedy button (e.g. "Login Instead"), and dismiss icon. |
| **07** | **Auth Phone Entry** | [`lib/presentation/auth/view/phone_entry_view.dart:59-67`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/auth/view/phone_entry_view.dart#L59-L67) | Server/network failures trigger fleeting `AppSnackbar.show(...)`. In-page text field only highlights local regex failures. | If API rate-limits or crashes, the user sees a quick toast, button stops spinning, and no inline recovery card appears. | Render an inline `AppErrorCard` above the phone field on non-validation failures with clear retry guidance. |
| **08** | **Auth OTP Verify** | [`lib/presentation/auth/view/otp_verify_view.dart:129-197`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/auth/view/otp_verify_view.dart#L129-L197) | Double error rendering: `ref.listen` shows `AppSnackbar` AND UI renders `AppErrorView` below the OTP boxes with unlocalized `failure.message`. | Redundant, visually jarring UI. Shows raw English "Invalid OTP" in Urdu mode. | Remove duplicate snackbar; replace `AppErrorView` with inline localized helper text or `AppErrorCard`. |
| **09** | **Teacher Signup Step 1 & 2 Cards** | [`lib/presentation/teacher_onboarding/widgets/teacher_signup_step1_card.dart:66`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/teacher_signup_step1_card.dart#L66) | Uses `AsyncValueWidget` inside dropdown cards. If campus or subject fetch fails, embeds a full `AppErrorView` inside the card. | Deforms the signup card into a broken layout with a massive error icon inside the picker box. | Provide compact error fallback for inline pickers with small inline "Tap to retry" chip. |
| **10** | **Teacher Onboarding Review** | [`lib/presentation/teacher_onboarding/view/teacher_onboarding_review_view.dart:48-55`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/view/teacher_onboarding_review_view.dart#L48-L55) | On failure, triggers `AppSnackbar.show(...)` with unlocalized `failure.message`. No in-page error indicator. | **The exact issue reported by user**: Duplicate phone number error flashes in a tiny snackbar and vanishes; form remains stagnant. | Display a persistent `AppErrorCard` at the top of the review card with contextual remedy actions (e.g. "Login instead"). |
| **11** | **Teacher Pending Approval** | [`lib/presentation/teacher_onboarding/view/teacher_pending_approval_view.dart:31-56`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/view/teacher_pending_approval_view.dart#L31-L56) | `catch (_)` swallows network failures and displays `context.l10n.teacherPendingStillPendingMessage`. | An offline teacher or server error is falsely confirmed as "Your registration is pending approval". | Disambiguate errors: if exception occurs, show `AppSnackbar.showError(context, context.l10n.commonNetworkError)`. |
| **12** | **Student Onboarding Review** | [`lib/presentation/student_onboarding/view/student_onboarding_review_view.dart:46-51`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_onboarding/view/student_onboarding_review_view.dart#L46-L51) | `ref.listen` catches errors and calls `error is Failure ? error.message : error.toString()` in `AppSnackbar`. | Leaks raw `error.toString()` (e.g. `FormatException`) into snackbars; disappears after 4s. | Implement persistent `AppErrorCard` on review sheet and format errors through `context.l10n.formatFailure(failure)`. |
| **13** | **Student Academic Info** | [`lib/presentation/student_onboarding/view/student_academic_info_view.dart:71-187`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_onboarding/view/student_academic_info_view.dart#L71-L187) | Uses `AsyncValueWidget` for Class Levels, Board Classes, and Subjects inside card sections. | If subject fetch fails, that section of the onboarding wizard turns into an unlocalized `AppErrorView`. | Use compact section retry banners instead of full-page error views. |
| **14** | **Teacher Overview Stats** | [`lib/presentation/teacher_overview/viewmodel/teacher_overview_viewmodel.dart:40-47`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/viewmodel/teacher_overview_viewmodel.dart#L40-L47) | Silently swallows errors on `teacherStudentsProvider` and `teacherEarningsProvider` with `studentsAsync.value ?? []`. | If backend fails, dashboard displays "0 Students" and "Rs. 0 Earnings". Teacher panics thinking data is lost. | Retain last known state or display an in-page "Unable to sync latest statistics" warning banner with retry button. |
| **15** | **Teacher Overview Recent Activity** | [`lib/presentation/teacher_overview/widgets/teacher_recent_activity_section.dart:43`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/widgets/teacher_recent_activity_section.dart#L43) | Uses `AsyncValueWidget`. On error, replaces recent activity with `AppErrorView` with English 'Retry'. | Jarring visual contrast; unlocalized English button in Urdu dashboard. | Use localized retry and compact inline error card that matches the dashboard styling. |
| **16** | **Teacher Students List** | [`lib/presentation/teacher_students/view/teacher_students_view.dart:34`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/view/teacher_students_view.dart#L34) | Uses `AsyncValueWidget` with unlocalized `AppErrorView`. Campus resolver swallows errors silently (`failure: (_) => {}`). | Entire screen replaced by plain unstyled error; campus names fail to display without warning. | Modernize `AppErrorView` with localized retry and illustration; handle campus mapping failure gracefully. |
| **17** | **Student Progress Detail** | [`lib/presentation/teacher_students/view/student_progress_detail_view.dart:52-82`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/view/student_progress_detail_view.dart#L52-L82) | Nested `AsyncValueWidget`: outer for student, inner for attempts. Both use unlocalized English error text. | English error shown in Urdu mode. Retries don't refresh related catalog providers. | Localize error states and ensure retry invalidates all dependent providers (`attempts`, `testsById`). |
| **18** | **Teacher Earnings Screen** | [`lib/presentation/teacher_earnings/view/teacher_earnings_view.dart:75`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_earnings/view/teacher_earnings_view.dart#L75) | Entire earnings dashboard (Hero card, summary, pagination) vanishes into `AppErrorView` on failure. | High visual disruption. No distinction between offline state and server outage. | Show cached earnings if available (SWR); show localized error state if cold boot fails. |
| **19** | **Teacher Profile View** | [`lib/presentation/teacher_profile/view/teacher_profile_view.dart:107-205`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_profile/view/teacher_profile_view.dart#L107-L205) | Profile update, phone OTP request, and account deletion all use `AppSnackbar.show(context, msg)` where `msg = failure.message`. | Disappearing English toasts for critical operations. Catalog providers silently swallow errors (`failure: (_) {}`). | Show semantic `AppSnackbar.showError`; display inline error card if phone update fails; localize all messages. |
| **20** | **Student Profile View** | [`lib/presentation/student_profile/view/student_profile_view.dart:67-113`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_profile/view/student_profile_view.dart#L67-L113) | Profile save and account delete show vanishing snackbars with unlocalized `failure.message`. | Critical account deletion failure can be missed by user if they look away for 4 seconds. | Implement persistent error dialog or high-visibility modal on deletion failure; localize update messages. |
| **21** | **Student Home & Subjects** | [`lib/presentation/student_home/view/student_home_view.dart:150-216`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_home/view/student_home_view.dart#L150-L216) | `liveTestsAsync` swallows errors with `liveTestsAsync.value?.isNotEmpty ?? false`. `subjectsAsync` uses unlocalized `AppErrorView`. | Live test banner silently disappears if API fails. Home grid turns into unlocalized error view. | Show fallback retry banner for live tests if error occurs; modernize subject error view. |
| **22** | **Chapter List & Buy Now** | [`lib/presentation/student_home/view/chapter_list_view.dart:53-60`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_home/view/chapter_list_view.dart#L53-L60) | `_buyNow` ignores errors during `addSubjectBundle` and proceeds to push `AppRoutes.studentCart`. | Student is navigated to cart screen only to find it in an error state or empty. | Await `addSubjectBundle`; if it fails, display error card or error snackbar on Chapter screen and DO NOT navigate. |
| **23** | **Student Cart Mutations** | [`lib/presentation/student_cart/viewmodel/student_cart_viewmodel.dart:128-172`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_cart/viewmodel/student_cart_viewmodel.dart#L128-L172) | If `removeSubject` or `addSubjectBundle` fails, sets `state = AsyncError(failure)`. | **Destructive UX**: The user's entire cart vanishes and is replaced by a full-screen `AppErrorView` because removing one item failed! | Keep cart data intact (`state = AsyncData(previousCart)`), emit a transient error event or show snackbar. |
| **24** | **Checkout & Payment** | [`lib/presentation/student_cart/view/checkout_view.dart:42-48`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_cart/view/checkout_view.dart#L42-L48) | `checkout()` swallows failure reason (`failure: (_) => null`). `CheckoutView` shows generic `AppErrorView`. | User cannot tell if card was declined, network dropped, or cart was expired. English retry button. | Return `Result<Payment>` from `checkout()`; display specific error description with retry or support actions. |
| **25** | **Live Test Registration** | [`lib/presentation/live_test_registration/view/live_tests_view.dart:30-80`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/live_test_registration/view/live_tests_view.dart#L30-L80) | **100% Silent Failure**: No `ref.listen` for `liveTestRegistrationViewModelProvider`. Button stops spinning on error. | Student taps "Register", spinner spins and stops. No error shown. Student taps repeatedly in frustration. | Add `ref.listen` to show `AppSnackbar.showError(context, context.l10n.formatFailure(error))` on failure. |
| **26** | **Test Taking Purchase Gate** | [`lib/presentation/test_taking/viewmodel/test_taking_viewmodel.dart:73-79`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/test_taking/viewmodel/test_taking_viewmodel.dart#L73-L79) | If `GetPurchasedSubjectIdsUseCase` fails, swallows error with `failure: (_) => false` and sets `status = notPurchased`. | **Critical Bug**: A student who paid for a subject is told "Buy Now" if their connection blips while starting a test! | If check fails, throw `failure` so `AsyncValueWidget` renders retry screen instead of demanding re-purchase! |
| **27** | **Test Submission Engine** | [`lib/presentation/test_taking/widgets/question_body.dart:108-111`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/test_taking/widgets/question_body.dart#L108-L111) | On submit failure, shows a 4-second snackbar `AppSnackbar.show(context, context.l10n.testSubmitFailed)`. | Catastrophic for an exam: Student thinks answers are lost, panics, has no structured retry dialog. | Show non-dismissible modal `AppDialog` on submission failure: "Submission Failed. Your answers are safe. [Retry Now]". |
| **28** | **Test Grading Poll Timeout** | [`lib/presentation/test_taking/viewmodel/test_taking_viewmodel.dart:234-245`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/test_taking/viewmodel/test_taking_viewmodel.dart#L234-L245) | If polling for grades times out or fails, returns `null` from `submitAttempt()`, falsely triggering submission failure in UI. | The exam was actually submitted successfully, but UI reports failure! | Distinguish "Submission Succeeded, Grading Pending" from submission failure. Show pending results screen. |
| **29** | **Student Progress Analytics** | [`lib/presentation/student_progress/view/student_progress_view.dart:49-80`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/student_progress/view/student_progress_view.dart#L49-L80) | Watches 5 providers, but only wraps `attemptsAsync` in `AsyncValueWidget`. `masteryAsync` and `chaptersAsync` silently default to empty. | Pie chart and chapter mastery sections disappear or show 0% without error or retry button. | Handle error states on secondary analytic providers with inline warning badges. |
| **30** | **Notifications Actions** | [`lib/presentation/notifications/viewmodel/notifications_viewmodel.dart:48-84`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/notifications/viewmodel/notifications_viewmodel.dart#L48-L84) | `markAllAsRead` and `clearAll` silently rollback state on failure (`failure: (_) { state = AsyncData(current); }`). | Items disappear, then silently pop back on screen. User has no idea what happened. | Emit error notification via `AppSnackbar.showError(context, context.l10n.notificationsActionFailed)`. |

---

## 4. Architectural Overhaul: The 5-Pillar Blueprint

To permanently resolve these issues without ad-hoc patches, the codebase must adopt the following 5-Pillar Architecture.

```
       [ HTTP Response / Exception (Dio) ]
                       │
                       ▼
    [ Pillar 1: DRF-Aware ErrorInterceptor ]
     ├─ Parses: detail, non_field_errors, field errors
     └─ Maps status codes (400, 401, 403, 404, 409, 429, 500)
                       │
                       ▼
           [ ResultGuard (Scrubber) ]
     ├─ Strips: DioException, TypeError, FormatException
     └─ Emits clean domain Failure (code + human message)
                       │
                       ▼
       [ Pillar 2: FailureDisplayMapper ]
     ├─ context.l10n.formatFailure(failure)
     └─ Full Urdu (ur) and English (en) dictionary
                       │
         ┌─────────────┴─────────────┐
         ▼                           ▼
[ Pillar 3: AppErrorCard ]  [ Pillar 4: AppErrorView & AppSnackbar ]
 (Persistent inline cards    (Full-screen empty/error states
  for forms & review sheets)  and semantic action toasts)
```

---

### Pillar 1: DRF-Aware Network Interceptor & Technical String Scrubber

#### Specification for `lib/core/network/interceptors/error_interceptor.dart`
The interceptor must parse all standard Django REST Framework response shapes and map them into the domain `Failure` taxonomy:

1. **DRF Field Errors (`{"phoneNumber": ["A profile with this phone number already exists."]}`)**:
   Extract the first error message and create a `ValidationFailure` with a specific code (`ErrorCodes.phoneAlreadyExists`).
2. **DRF Detail (`{"detail": "..."}`)**:
   Extract the detail string.
3. **DRF Non-field Errors (`{"non_field_errors": ["..."]}`)**:
   Extract the first non-field error string.
4. **HTML / Unstructured Server 500 Responses**:
   Never pass raw HTML or status text. Map directly to `ServerFailure()`.
5. **HTTP 409 Conflict**:
   Map directly to `ValidationFailure(code: 'conflict', message: '...')`.
6. **HTTP 429 Too Many Requests**:
   Map to `RateLimitFailure()` with cooldown metadata.

#### Specification for `lib/core/network/result_guard.dart`
`result_guard.dart` must never expose `e.toString()` or `e.message` to `UnknownFailure`:
- Log the raw exception and stack trace to `sl<Logger>().e(...)`.
- If the exception is a `DioException` whose `.error` is already a `Failure`, return that `Failure`.
- If the exception is a `TypeError`, `FormatException`, or unhandled Dart exception, return `UnknownFailure()` with NO technical details attached to the user-facing message.

---

### Pillar 2: Presentation-Layer Failure Localization Mapper

#### Architectural Rule
Domain entities (`lib/domain/common/failure.dart`) must NOT depend on Flutter's `BuildContext` or `AppLocalizations`. Instead, all translation must occur in the Presentation layer via an extension or mapper:

```dart
// lib/core/extensions/failure_extensions.dart
extension FailureLocalizationX on BuildContext {
  String formatFailure(Failure failure) {
    return switch (failure) {
      NetworkFailure() => l10n.errorNetworkMessage,
      ServerFailure() => l10n.errorServerMessage,
      UnauthorizedFailure() => l10n.errorUnauthorizedMessage,
      NotFoundFailure() => l10n.errorNotFoundMessage,
      ValidationFailure(:final code, :final message) => switch (code) {
        'phone_already_exists' => l10n.errorPhoneAlreadyExists,
        'invalid_phone' => l10n.phoneInvalid,
        'rate_limit' => l10n.errorRateLimitExceeded,
        _ => message.isNotEmpty ? message : l10n.errorValidationGeneric,
      },
      _ => l10n.commonErrorGeneric,
    };
  }

  String failureTitle(Failure failure) {
    return switch (failure) {
      NetworkFailure() => l10n.errorNetworkTitle,
      ServerFailure() => l10n.errorServerTitle,
      UnauthorizedFailure() => l10n.errorUnauthorizedTitle,
      _ => l10n.errorGenericTitle,
    };
  }
}
```

---

### Pillar 3: Persistent `AppErrorCard` Component for Forms & Review

Forms and review sheets must **never** rely on transient snackbars for submission failures. A dedicated `AppErrorCard` component must be introduced in `lib/core/widgets/app_error_card.dart`.

#### Design Specification
- **Container**: Card with subtle error background tint (`colors.error.withOpacity(0.08)`), rounded border (`colors.error.withOpacity(0.3)`).
- **Header**: Danger alert icon (`Icons.error_outline_rounded`), bold title in `colors.error`.
- **Body**: Non-technical, localized explanation text in `colors.textPrimary`.
- **Action Buttons (Optional)**:
  - Primary remedy button (e.g. `AppButton(label: 'Log in instead', onPressed: ...)`).
  - Secondary retry button (e.g. `AppButton(label: 'Try again', variant: AppButtonVariant.outlined)`).
- **Dismissible**: Optional close icon to dismiss the banner once read.

#### Usage Scenarios
- `TeacherOnboardingReviewView`: When `submitSignUp` fails with duplicate phone number, display `AppErrorCard` at the top of the review scroll view:
  > **Title:** Phone Number Already Registered  
  > **Body:** An account with this phone number already exists in our system. You can log in directly or contact support.  
  > **Actions:** [Log In Instead]  [Retry Submission]
- `StudentOnboardingReviewView`: Display inline `AppErrorCard` on submission failure.
- `PhoneEntryView`: Display `AppErrorCard` when OTP request is rate-limited or blocked.

---

### Pillar 4: Modernized `AppErrorView` & Semantic `AppSnackbar`

#### Modernized `AppErrorView` (`lib/core/widgets/app_error_view.dart`)
1. **Localized Retry Button**: Replace hardcoded `'Retry'` with `context.l10n.commonRetry`.
2. **Contextual Categories**: Display distinct icons and titles for:
   - No Connection (`Icons.wifi_off_rounded` + "No Internet Connection")
   - Server Outage (`Icons.cloud_off_rounded` + "Server Unavailable")
   - Data Not Found (`Icons.search_off_rounded` + "Not Found")
3. **Compact Mode**: Support an `isCompact: true` flag for embedding inside list cards, review tiles, and dropdowns without breaking constraints.

#### Semantic `AppSnackbar` (`lib/core/widgets/app_snackbar.dart`)
Upgrade `AppSnackbar` from a bare Material toast to a semantic feedback utility:
- `AppSnackbar.showError(BuildContext context, String message, {VoidCallback? onRetry})`
  - Red container (`colors.errorContainer`), error icon, duration 5 seconds, floating behavior.
- `AppSnackbar.showSuccess(BuildContext context, String message)`
  - Green container (`colors.primaryContainer`), check icon, duration 3 seconds.
- `AppSnackbar.showWarning(BuildContext context, String message)`
  - Amber container, warning icon, duration 4 seconds.

---

### Pillar 5: Eliminating Silent Failures & Misleading Fallbacks

1. **Live Test Registration (`LiveTestsView` & `LiveTestCard`)**:
   Add `ref.listen<AsyncValue<List<LiveTestRegistration>>>(liveTestRegistrationViewModelProvider, ...)` in `LiveTestsView`. On error, trigger `AppSnackbar.showError(context, context.l10n.liveTestRegistrationFailed)`.
2. **Teacher Overview Metrics (`TeacherOverviewStatsProvider`)**:
   Do NOT conflate failed API calls with "0 students". If `teacherStudentsProvider.hasError` or `teacherEarningsProvider.hasError`, provide a `stats.isDegraded` flag to `TeacherOverviewView` to display a subtle banner: *"Unable to refresh statistics. Showing last saved data. [Refresh]"*.
3. **Teacher Pending Approval (`TeacherPendingApprovalView`)**:
   In `_handleCheckStatus()`:
   ```dart
   try {
     final teacher = await ref.read(teacherOnboardingViewModelProvider.future);
     // Only if teacher is verified as pending:
     AppSnackbar.show(context, context.l10n.teacherPendingStillPendingMessage);
   } catch (e) {
     // Network or server error:
     AppSnackbar.showError(context, context.l10n.errorNetworkMessage);
   }
   ```
4. **Student Cart Mutation Retention (`StudentCartViewModel`)**:
   In `removeSubject` and `addSubjectBundle`:
   ```dart
   failure: (failure) async {
     // DO NOT overwrite state with AsyncError! Keep current cart items!
     // Emit a failure event or display error toast via side effect.
     return AsyncData<Cart>(currentCart);
   }
   ```
5. **Test Taking Purchase Gate (`TestTakingViewModel`)**:
   In `build()`:
   ```dart
   final purchasedResult = await sl<GetPurchasedSubjectIdsUseCase>()(session.userId!);
   final isPurchased = purchasedResult.when(
     success: (ids) => ids.contains(test.subjectId),
     failure: (failure) => throw failure, // THROW, do NOT default to false!
   );
   ```
6. **Test Submission Protection (`QuestionBody` & `TestTakingViewModel`)**:
   If test submission fails, prompt the student with a non-dismissible `AppDialog`:
   > **Title:** Submission Failed  
   > **Message:** We couldn't connect to the server to submit your answers. Your answers are saved locally on your device. Please check your internet connection and try submitting again.  
   > **Actions:** [Retry Submission]  [Check Connection]

---

## 5. Bilingual ARB Localization Dictionary

The following complete dictionary of error-related keys must be added to `lib/l10n/app_en.arb` and `lib/l10n/app_ur.arb`:

### English (`lib/l10n/app_en.arb`)
```json
  "commonRetry": "Retry",
  "commonTryAgain": "Try Again",
  "commonCancel": "Cancel",
  "commonDismiss": "Dismiss",
  "commonLogin": "Log In",
  "commonContactSupport": "Contact Support",
  "errorGenericTitle": "Something Went Wrong",
  "errorGenericMessage": "An unexpected error occurred. Please try again.",
  "errorNetworkTitle": "No Internet Connection",
  "errorNetworkMessage": "Please check your network connection and try again.",
  "errorServerTitle": "Server Unavailable",
  "errorServerMessage": "Our servers are currently experiencing issues. Please try again later.",
  "errorTimeoutMessage": "The connection timed out. Please try again.",
  "errorUnauthorizedTitle": "Session Expired",
  "errorUnauthorizedMessage": "Your session has expired. Please log in again.",
  "errorNotFoundTitle": "Not Found",
  "errorNotFoundMessage": "The requested resource could not be found.",
  "errorValidationGeneric": "Please check the entered details and try again.",
  "errorRateLimitExceeded": "Too many attempts. Please wait a few minutes before trying again.",
  "errorPhoneAlreadyExists": "An account with this phone number is already registered.",
  "errorPhoneAlreadyExistsAction": "Log In Instead",
  "errorAccountInactive": "This account is inactive or has been suspended. Please contact support.",
  "liveTestRegistrationFailed": "Could not register for the live test. Please try again.",
  "cartItemRemoveFailed": "Could not remove item from cart. Please check your connection.",
  "cartBundleAddFailed": "Could not add subject to cart. Please try again.",
  "testSubmissionFailedTitle": "Test Submission Failed",
  "testSubmissionFailedMessage": "We could not reach the server to submit your test. Your answers are saved safely on your device. Please reconnect and retry.",
  "testSubmissionRetryButton": "Retry Submission",
  "testGradingPendingNotice": "Your test was submitted successfully! Grading is in progress.",
  "teacherStatsSyncFailed": "Unable to update dashboard metrics. Tap to retry.",
  "notificationsActionFailed": "Failed to update notifications. Please try again."
```

### Urdu (`lib/l10n/app_ur.arb`)
```json
  "commonRetry": "دوبارہ کوشش کریں",
  "commonTryAgain": "پھر کوشش کریں",
  "commonCancel": "منسوخ کریں",
  "commonDismiss": "رد کریں",
  "commonLogin": "لاگ ان کریں",
  "commonContactSupport": "سپورٹ سے رابطہ کریں",
  "errorGenericTitle": "کچھ غلط ہو گیا",
  "errorGenericMessage": "ایک غیر متوقع خرابی پیش آگئی ہے۔ براہ کرم دوبارہ کوشش کریں۔",
  "errorNetworkTitle": "انٹرنیٹ کنکشن نہیں ہے",
  "errorNetworkMessage": "براہ کرم اپنا انٹرنیٹ کنکشن چیک کریں اور دوبارہ کوشش کریں۔",
  "errorServerTitle": "سرور دستیاب نہیں ہے",
  "errorServerMessage": "ہمارے سرورز پر اس وقت مسئلہ آ رہا ہے۔ براہ کرم کچھ دیر بعد کوشش کریں۔",
  "errorTimeoutMessage": "کنکشن کا وقت ختم ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔",
  "errorUnauthorizedTitle": "سیشن ختم ہو گیا",
  "errorUnauthorizedMessage": "آپ کا سیشن ختم ہو چکا ہے۔ براہ کرم دوبارہ لاگ ان کریں۔",
  "errorNotFoundTitle": "نہیں ملا",
  "errorNotFoundMessage": "مطلوبہ مواد نہیں مل سکا۔",
  "errorValidationGeneric": "براہ کرم درج کردہ معلومات کی تصدیق کریں اور دوبارہ کوشش کریں۔",
  "errorRateLimitExceeded": "بہت زیادہ کوششیں کی گئیں۔ براہ کرم چند منٹ انتظار کے بعد دوبارہ کوشش کریں۔",
  "errorPhoneAlreadyExists": "اس فون نمبر کے ساتھ پہلے سے ایک اکاؤنٹ موجود ہے۔",
  "errorPhoneAlreadyExistsAction": "لاگ ان کریں",
  "errorAccountInactive": "یہ اکاؤنٹ غیر فعال یا معطل ہے۔ براہ کرم سپورٹ سے رابطہ کریں۔",
  "liveTestRegistrationFailed": "لائیو ٹیسٹ کے لیے رجسٹریشن نہیں ہو سکی۔ براہ کرم دوبارہ کوشش کریں۔",
  "cartItemRemoveFailed": "کارٹ سے آئٹم نہیں ہٹایا جا سکا۔ انٹرنیٹ چیک کریں۔",
  "cartBundleAddFailed": "مضمون کارٹ میں شامل نہیں ہو سکا۔ دوبارہ کوشش کریں۔",
  "testSubmissionFailedTitle": "ٹیسٹ جمع نہیں ہو سکا",
  "testSubmissionFailedMessage": "سرور سے رابطہ نہ ہو سکا۔ آپ کے جوابات آپ کے موبائل پر محفوظ ہیں۔ براہ کرم انٹرنیٹ بحال کر کے دوبارہ جمع کروائیں۔",
  "testSubmissionRetryButton": "دوبارہ جمع کروائیں",
  "testGradingPendingNotice": "آپ کا ٹیسٹ کامیابی سے جمع ہو گیا ہے! مارکنگ جاری ہے۔",
  "teacherStatsSyncFailed": "اعداد و شمار اپ ڈیٹ نہیں ہو سکے۔ دوبارہ کوشش کریں۔",
  "notificationsActionFailed": "اطلاعات اپ ڈیٹ نہیں ہو سکیں۔ دوبارہ کوشش کریں۔"
```

---

## 6. Phased Implementation Roadmap

When authorized to begin code execution, the overhaul will follow this strict sequence:

### Phase 1: Core Network & Parsing Layer
1. Refactor `lib/core/network/interceptors/error_interceptor.dart` to handle DRF `detail`, `non_field_errors`, field maps, and status codes.
2. Update `lib/core/network/result_guard.dart` to strip technical messages and sanitize `details`.
3. Add `code` and optional structured error metadata to `lib/domain/common/failure.dart`.

### Phase 2: Design System & Localization Foundation
1. Add all 22 new localization keys to `app_en.arb` and `app_ur.arb`, then run `flutter gen-l10n`.
2. Implement `lib/core/extensions/failure_extensions.dart` (`formatFailure`, `failureTitle`).
3. Create `lib/core/widgets/app_error_card.dart` for persistent inline error states.
4. Upgrade `lib/core/widgets/app_error_view.dart` (localized retry, category icons).
5. Upgrade `lib/core/widgets/app_snackbar.dart` (semantic `showError`, `showSuccess`, `showWarning`).

### Phase 3: Auth & Onboarding Overhaul
1. Upgrade `TeacherOnboardingReviewView` and `StudentOnboardingReviewView` to use `AppErrorCard` on submission failure.
2. In `TeacherPendingApprovalView`, fix the `catch (_)` block to distinguish network errors from pending approval status.
3. In `PhoneEntryView`, replace transient snackbars with `AppErrorCard` for rate-limiting or server failures.
4. In `OtpVerifyView`, eliminate duplicate error displays and localize error text.

### Phase 4: Teacher & Student Features Overhaul
1. In `LiveTestsView`, add `ref.listen` on registration viewmodel to show error feedback.
2. In `StudentCartViewModel`, prevent cart annihilation on failed removal/addition; return `Result<Payment>` from `checkout()`.
3. In `TestTakingViewModel`, throw failures on purchase checks instead of falsely defaulting to `notPurchased`.
4. In `QuestionBody`, replace transient snackbar on exam submission failure with a non-dismissible retry dialog.
5. In `TeacherOverviewViewModel`, add a degraded-state indicator instead of displaying "0 students" on server failure.
6. In `NotificationsViewModel`, notify the user if bulk read/clear actions fail.

### Phase 5: Verification & Quality Assurance
1. Run `flutter analyze` to ensure zero compilation or lint errors.
2. Verify English and Urdu rendering for every error category.
3. Verify simulated offline/airplane mode behavior across all 15 screens.
4. Verify simulated 400 (duplicate phone), 401 (expired token), 429 (rate limit), and 500 (server crash) responses.
