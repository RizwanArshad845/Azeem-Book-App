# Teacher Portal — Development & Change Log

This document tracks high-level updates, UI/UX redesigns, key file modifications, and upcoming milestones for the **Teacher Portal** in the Azeem Publications app.

---

## 1. Teacher Onboarding Redesign (Completed)

### 1.1. 4-Step Intuitive Wizard
The teacher self-signup flow was restructured from a flat form into a modern 4-step progressive wizard:

* **Step 1: Personal & Campus Info**
  * Mandatory *Full Name* and *Campus* dropdown selection.
  * Real-time field validation with clear red asterisk (`*`) indicators.
* **Step 2: Teaching Scope (Classes & Subjects)**
  * **Unambiguous Class Selection**: Classes are clearly labeled with their parent grade levels (e.g. `9th`, `10th`, `11th (Pre-Medical)`, `11th (Pre-Engineering)`, `12th (Pre-Medical)`, `12th (Pre-Engineering)`).
  * **Deduplicated Subjects**: Common subjects (e.g. *Physics*, *Chemistry*, *English*) appear only once regardless of how many classes are selected, with custom subject icons and multi-select checkmark badges.
* **Step 3: Student Reach (Optional)**
  * Interactive counter supporting `-` / `+` increment buttons, direct numerical typing, and quick-add preset chips (`20+`, `50+`, `100+`, `200+`, `500+`).
* **Step 4: Review Registration**
  * A dedicated summary screen displaying verified teacher information (Name, Campus, selected Classes, selected Subjects, and Student count) before submitting for approval.

---

### 1.2. UI / UX & Aesthetic Enhancements
* **Frosted Glassmorphism Theme**: Replaced the harsh solid white card with a modern, eye-friendly translucent glass surface (76% opacity + 18px backdrop gaussian blur) that softly diffuses the background study pattern.
* **Open Single-Layer Layout**: Eliminated nested "boxes-inside-boxes" (`AppCard`s) so form fields, selection grids, and summary rows sit cleanly on the main canvas with generous breathing room.
* **Full Bilingual Support (English & Urdu)**:
  * Integrated an instant language toggle button (`EN | اردو`) in the header accessible at all onboarding stages.
  * RTL-aware navigation: Arrow icons automatically point in the natural reading direction for both English (LTR) and Urdu (RTL).
  * Standardized trailing button icons (`Continue ➔` and `Submit for Approval ✓`).

---

### 1.3. Files Modified & Created

#### New Components
* [`lib/presentation/teacher_onboarding/widgets/interactive_selection_grid.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/interactive_selection_grid.dart) — Generic multi-select grid with animated selection borders and category icons.
* [`lib/presentation/teacher_onboarding/widgets/student_count_counter.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/student_count_counter.dart) — Interactive stepper counter with preset chips and direct input.
* [`lib/presentation/teacher_onboarding/widgets/teacher_onboarding_summary_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/teacher_onboarding_summary_card.dart) — Clean review summary section for Step 4.

#### Modified UI & Logic
* [`lib/presentation/teacher_onboarding/widgets/teacher_signup_form.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/teacher_signup_form.dart) — Multi-step animated form wizard, field validation, and submit integration.
* [`lib/presentation/teacher_onboarding/view/teacher_signup_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/view/teacher_signup_view.dart) — Step state manager and header progress integration.
* [`lib/presentation/teacher_onboarding/viewmodel/teacher_signup_form_providers.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/viewmodel/teacher_signup_form_providers.dart) — Grade-level class title resolution and subject deduplication logic.

#### Shared Core Widgets & Polish
* [`lib/core/widgets/onboarding_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/onboarding_card.dart) — Implemented frosted glassmorphic card styling.
* [`lib/core/widgets/onboarding_scaffold.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/onboarding_scaffold.dart) — Header language switcher, RTL back arrows, and responsive title scaling.
* [`lib/core/widgets/section_progress_indicator.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/section_progress_indicator.dart) — Fixed step progress bar index calculation.
* [`lib/core/widgets/app_button.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/app_button.dart) — Trailing icon layout and flexible text overflow prevention.
* [`lib/core/widgets/blurred_logo_backdrop.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/blurred_logo_backdrop.dart) — Impeller rendering engine opacity fix.
* [`lib/presentation/auth/view/role_select_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/auth/view/role_select_view.dart) & [`phone_entry_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/auth/view/phone_entry_view.dart) — Added initial header language switchers.

#### Localization & Config
* [`lib/l10n/app_en.arb`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_en.arb) & [`lib/l10n/app_ur.arb`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_ur.arb) — English and Urdu localized string definitions.
* [`lib/l10n/app_localizations*.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/) — Generated localization getters.
* [`android/gradle.properties`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/android/gradle.properties) — Local Android Gradle build fix.

---

## 2. Upcoming Roadmap (Next Steps)

### Phase 2: Teacher Dashboard
1. **Overview Screen**:
   * Summary metric cards (active students, generated tests, earnings).
   * Quick action buttons for test generation and student management.
2. **Students Directory & Progress**:
   * Searchable, filterable student roster by class/subject.
   * Detailed student progress, test scores, and performance analytics.
3. **Earnings & Commission Breakdown**:
   * Clear earnings dashboard with monthly breakdowns and transaction history.
4. **Teacher Profile & Account Settings**:
   * Teaching preferences, campus details, and password/contact updates.
