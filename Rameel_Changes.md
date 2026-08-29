# Teacher Portal — Development & Change Log

This document tracks high-level updates, UI/UX redesigns, key file modifications, mock test datasets, and milestones for the **Teacher Portal** in the Azeem Publications app.

---

## 1. Teacher Onboarding Redesign (Completed)

### 1.1. 4-Step Intuitive Wizard
The teacher self-signup flow is structured into a modern 4-step progressive wizard:

* **Step 1: Personal & Campus Info (City Filter + Multi-Campus)**
  * Mandatory *Full Name* input.
  * **City Dropdown Filter**: Dynamically populates available cities from the institution directory (e.g. *Bahawalpur*, *Lahore*, *Multan*).
  * **Multi-Campus Selection**: Once a city is selected, shows filtered institutions/campuses in that city for multi-selection ($\ge 1$ required) with institution icons and checkmark indicators.
* **Step 2: Teaching Scope (Classes & Subjects)**
  * **Unambiguous Class Selection**: Classes are clearly labeled with their parent grade levels (e.g. `9th`, `10th`, `11th (Pre-Medical)`, `11th (Pre-Engineering)`, `12th (Pre-Medical)`, `12th (Pre-Engineering)`).
  * **Deduplicated Subjects**: Common subjects (e.g. *Physics*, *Chemistry*, *English*) appear only once regardless of how many classes are selected, with custom subject icons and multi-select checkmark badges.
* **Step 3: Student Reach (Optional)**
  * Interactive counter supporting `-` / `+` increment buttons, direct numerical typing, and quick-add preset chips (`20+`, `50+`, `100+`, `200+`, `500+`).
* **Step 4: Review Registration**
  * A dedicated summary screen displaying verified teacher information (Name, City, selected Campuses, selected Classes, selected Subjects, and Student count) before submitting for approval.

---

### 1.2. UI / UX & Aesthetic Enhancements
* **Frosted Glassmorphism Theme**: Replaced the harsh solid white card with a modern, eye-friendly translucent glass surface (76% opacity + 18px backdrop gaussian blur) that softly diffuses the background study pattern.
* **Open Single-Layer Layout**: Eliminated nested "boxes-inside-boxes" (`AppCard`s) so form fields, selection grids, and summary rows sit cleanly on the main canvas with generous breathing room.
* **Full Bilingual Support (English & Urdu)**:
  * Integrated an instant language toggle button (`EN | اردو`) in the header accessible at all onboarding stages.
  * RTL-aware navigation: Arrow icons automatically point in the natural reading direction for both English (LTR) and Urdu (RTL).
  * Standardized trailing button icons (`Continue ➔` and `Submit for Approval ✓`).

---

## 2. Teacher Dashboard Overhaul (Completed — Sprints 1, 2 & 3)

### 2.1. Overview Tab (`TeacherOverviewView`)
* **Personalized Header (`TeacherTopBar`)**: Removed generic "Teacher Dashboard" header; replaced with dynamic greeting (`"Welcome back, {Teacher Name} 👋"`), instant language toggle (`EN | اردو`), and notification bell with unread badge counter.
* **Projected Earnings Attraction Hero Card (`ProjectedEarningsHeroCard`)**: 
  * Highlights actual commission earned (**Rs. 5,500**) alongside motivating earning potential from remaining declared students (**Rs. 17,500**).
  * Includes enrollment goal progress bar (`15 / 50 Students (30%)`).
* **Quick Actions Grid (`TeacherQuickActionsGrid`)**: 4 one-tap action tiles:
  * 👥 *Students Roster (11 Paid • 4 Free)*
  * 💰 *Earnings Ledger*
  * 📝 *Custom Test (Phase 2 preview badge)*
  * 🔗 *Share Teacher Referral Link*
* **Recent Activity Section (`TeacherRecentActivitySection`)**: Live mini-feed of real-time student signups and bundle purchases.
* **Streamlined Bottom Nav Bar**: Updated to 4 clean primary tabs: *Overview*, *Students*, *Earnings*, *Profile* (notification bell moved to the top bar).

---

### 2.2. Students Directory Tab (`TeacherStudentsView`)
* **Status Summary Strip (`StudentsSummaryStrip`)**: Interactive filter pills for `All (15)`, `Active / Paid (11)`, and `Free / Unpaid (4)`.
* **Smart Filter & Search Bar (`StudentsFilterBar`)**:
  * Real-time search by name or phone.
  * Campus filter chips (`All Campuses`, `Punjab College Bahawalpur`, `Punjab College Lahore`, etc.).
  * Sorting popup menu (`Top Test Performers`, `Alphabetical A-Z`, `Recently Joined`).
* **Rich Student Card (`StudentCard`)**:
  * Initial avatar, student name, phone number, and campus badge.
  * Color-coded status badge: Emerald `Active (Paid)` vs Slate `Free (Unpaid)`.
  * Commission badge: `+Rs. 500 Commission Earned`.
  * Direct **"View Progress ➔"** action button.
* **Senior Developer Pagination UI (`StudentsList`)**:
  * Summary info indicator: `Showing 1–6 of 15 students`.
  * Direct numbered page jump chips (`1`, `2`, `3`, etc.) with active pill highlight.
  * Smooth auto-scroll to top on page navigation.

---

### 2.3. Student Progress Detail Screen (`StudentProgressDetailView`)
* **Scoped Teacher-Only Subjects**: The header only displays subjects where the student selected this specific teacher (`e.teacherId == teacher.id`), excluding unrelated subjects.
* **Diagnostic Performance Cards**:
  * Overall average score percentage gauge and test completion count.
  * Chronological attempt history cards with scores, dates, and test titles.

---

### 2.4. Detailed Earnings Dashboard (`TeacherEarningsView`)
* **Dual Financial Summary**: Actual earnings total + transaction counter.
* **Interactive Projected Earnings Simulator (`EarningsProjectedCalculatorCard`)**:
  * Interactive slider simulating potential earnings as additional declared students buy test bundles.
* **Detailed Commission Ledger (`EarningsRecordCard`)**: Individual cards showing student name, test bundle, date, and `+Rs. 500` commission badge.

---

### 2.5. Notifications Hub (`NotificationsView`)
* **Color-Coded Badges**:
  * 🟢 **Emerald Green**: Paid bundle purchases & discount announcements.
  * 🔵 **Royal Blue**: New student registrations.
  * 🟡 **Amber**: Approvals, profile updates, and test reminders.
  * 🟣 **Purple**: New test uploads.
* **Bulk Actions**: Added **"Mark all as read"** and **"Clear all"** actions with a confirmation dialog.
* **Frosted Theme**: Converted notification items to frosted glass cards over `BlurredLogoBackdrop`.

---

### 2.6. Teacher Profile & Account Settings (`TeacherProfileView`)
* **Verified Educator Card**: Profile header with avatar, name, phone, and *Azeem Verified Faculty* badge.
* **Teaching Scope & Reach**: Badges displaying affiliated campuses, taught classes, taught subjects, and declared student reach (`~50 Students Enrolled`).
* **Phone Number Change with OTP Flow**: Automatically triggers an OTP modal sheet requesting verification before committing changes to the phone number.
* **Delete Account Confirmation**: Destructive confirmation modal that safely soft-deletes the teacher record and redirects to the initial role selection launch page (`AppRoutes.authRoleSelect`).

---

## 3. UI/UX Polish, Overflow Fixes & Design System Unification
* **Unified `AppFrostedCard`**: Standardized all cards (76% alpha, 18px backdrop gaussian blur, soft glass border, subtle depth shadow) over `BlurredLogoBackdrop`.
* **Zero Overflow Guarantee**: Safeguarded `ProjectedEarningsHeroCard`, `StudentsFilterBar`, and `StudentCard` against `RenderFlex` horizontal overflows across all device densities and screen widths.
* **Full Urdu Localization**: Complete translations in `app_en.arb` and `app_ur.arb` with full RTL layout support.

---

## 4. Mock Data Enrichment (Testing Dataset for 15 Students)
* **15 Pre-Seeded Enrolled Students**:
  * **11 Active Students (Paid Bundle)**: Ali Ahmed, Fatima Zahra, Hamza Tariq, Usman Khalid, Ayesha Noor, Hassan Raza, Maryam Bibi, Saad Abdullah, Khadija Farooq, Omar Farooq, Zubair Khan.
  * **4 Free Students (Unpaid)**: Zainab Malik, Bilal Hassan, Noor ul Ain, Danish Ali.
* **11 Commission Ledger Transactions**: Totaling Rs. 5,500 in actual earnings.
* **Seeded Test Attempts**: Multi-test scores (60% - 95%) for student progress reporting.
* **Live Notifications**: Student registrations and test purchase alerts.

---

## 5. Backend Alignment (`backend.md`)
* Documented student filtering query parameters: `?query=&campus_id=&status=&sort_by=&page=&page_size=`.
* Documented earnings timeframe filter: `?timeframe=all_time|this_month|last_month`.
* Documented phone change OTP verification endpoint flow: `POST /api/v1/auth/phone-change/verify`.
* Documented teacher account deletion lifecycle and data retention.

---

## 6. File Manifest (Added, Modified, Deleted)

### 6.1. Added Files (8 New Files)
1. [`lib/core/widgets/app_frosted_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/app_frosted_card.dart) — Reusable frosted glassmorphic card (76% alpha, 18px backdrop gaussian blur, soft glass border, 18px blur shadow).
2. [`lib/presentation/teacher_overview/widgets/teacher_top_bar.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/widgets/teacher_top_bar.dart) — Top utility header with personalized greeting, bilingual language switcher (`EN | اردو`), and notification badge bell.
3. [`lib/presentation/teacher_overview/widgets/projected_earnings_hero_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/widgets/projected_earnings_hero_card.dart) — High-converting earnings card showcasing actual earnings, projected potential, and onboarding goal progress.
4. [`lib/presentation/teacher_overview/widgets/teacher_quick_actions_grid.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/widgets/teacher_quick_actions_grid.dart) — 4 shortcut action tiles (Students Roster, Earnings Ledger, Custom Test, Share Referral).
5. [`lib/presentation/teacher_overview/widgets/teacher_recent_activity_section.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/widgets/teacher_recent_activity_section.dart) — Real-time live mini-feed of student signups and bundle purchases.
6. [`lib/presentation/teacher_students/widgets/students_summary_strip.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/widgets/students_summary_strip.dart) — Interactive horizontal status filter pills (`All`, `Active / Paid`, `Free / Unpaid`).
7. [`lib/presentation/teacher_students/widgets/students_filter_bar.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/widgets/students_filter_bar.dart) — Live search input, sort popup menu, and horizontal campus filter chips.
8. [`lib/presentation/teacher_earnings/widgets/earnings_projected_calculator_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_earnings/widgets/earnings_projected_calculator_card.dart) — Interactive projected earnings simulator slider for remaining declared students.

### 6.2. Modified Files (29 Files)
1. [`lib/core/constants/app_routes.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/constants/app_routes.dart) — Added teacher notifications route path.
2. [`lib/core/router/app_router.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/router/app_router.dart) — Streamlined teacher navigation shell to 4 tabs; moved notifications outside shell.
3. [`lib/core/providers/locale_provider.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/providers/locale_provider.dart) — Added `toggleLocale()` method.
4. [`lib/core/widgets/app_dropdown.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/core/widgets/app_dropdown.dart) — Fixed Material shape assertion and added dynamic popup height constraints.
5. [`lib/l10n/app_en.arb`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_en.arb) — Added English localization keys for all teacher portal screens.
6. [`lib/l10n/app_ur.arb`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_ur.arb) — Added Urdu translations for all teacher portal screens.
7. [`lib/l10n/app_localizations.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_localizations.dart) — Added abstract getters for teacher localizations.
8. [`lib/l10n/app_localizations_en.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_localizations_en.dart) — Implemented English getter methods.
9. [`lib/l10n/app_localizations_ur.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/l10n/app_localizations_ur.dart) — Implemented Urdu getter methods.
10. [`lib/data/earnings/datasources/local/earnings_dummy_datasource.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/data/earnings/datasources/local/earnings_dummy_datasource.dart) — Seeded 11 commission transactions (Rs. 5,500).
11. [`lib/data/student_onboarding/datasources/local/student_dummy_datasource.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/data/student_onboarding/datasources/local/student_dummy_datasource.dart) — Seeded 15 mock students (11 paid, 4 free).
12. [`lib/data/test_taking/datasources/local/test_attempt_dummy_datasource.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/data/test_taking/datasources/local/test_attempt_dummy_datasource.dart) — Seeded multi-attempt test results.
13. [`lib/data/notifications/datasources/local/notification_dummy_datasource.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/data/notifications/datasources/local/notification_dummy_datasource.dart) — Seeded teacher activity notifications.
14. [`lib/presentation/teacher_onboarding/widgets/interactive_selection_grid.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/interactive_selection_grid.dart) — Wrapped tile labels in `Flexible` to prevent overflow.
15. [`lib/presentation/teacher_onboarding/widgets/teacher_signup_form.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/teacher_signup_form.dart) — Added city dropdown and multi-campus filtration.
16. [`lib/presentation/teacher_onboarding/widgets/teacher_onboarding_summary_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_onboarding/widgets/teacher_onboarding_summary_card.dart) — Updated Step 4 summary with city and campuses list.
17. [`lib/presentation/teacher_overview/view/teacher_overview_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/view/teacher_overview_view.dart) — Assembled redesigned Overview dashboard wrapped in `BlurredLogoBackdrop`.
18. [`lib/presentation/teacher_overview/viewmodel/teacher_overview_viewmodel.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_overview/viewmodel/teacher_overview_viewmodel.dart) — Added `TeacherOverviewStats` aggregate notifier and providers.
19. [`lib/presentation/teacher_students/view/teacher_students_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/view/teacher_students_view.dart) — Assembled Students tab with frosted glass styling and live refresh.
20. [`lib/presentation/teacher_students/view/student_progress_detail_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/view/student_progress_detail_view.dart) — Scoped student header to only show enrolled subjects with this teacher.
21. [`lib/presentation/teacher_students/viewmodel/teacher_students_viewmodel.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/viewmodel/teacher_students_viewmodel.dart) — Implemented search, campus filter, status filter, sorting, and pagination state.
22. [`lib/presentation/teacher_students/widgets/student_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/widgets/student_card.dart) — Upgraded with `AppFrostedCard`, status badges, commission text, and View Progress action.
23. [`lib/presentation/teacher_students/widgets/students_list.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/widgets/students_list.dart) — Implemented senior-level pagination with counter, numbered jump chips, and auto-scroll.
24. [`lib/presentation/teacher_students/widgets/average_score_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_students/widgets/average_score_card.dart) — Upgraded with `AppFrostedCard` and score gauge.
25. [`lib/presentation/teacher_earnings/view/teacher_earnings_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_earnings/view/teacher_earnings_view.dart) — Assembled Earnings dashboard with frosted cards and transaction ledger.
26. [`lib/presentation/teacher_earnings/widgets/earnings_record_card.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_earnings/widgets/earnings_record_card.dart) — Converted to `AppFrostedCard` with student name attribution.
27. [`lib/presentation/notifications/view/notifications_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/notifications/view/notifications_view.dart) — Added color-coded badges, bulk actions (`Mark all as read`, `Clear all`), and frosted styling.
28. [`lib/presentation/notifications/viewmodel/notifications_viewmodel.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/notifications/viewmodel/notifications_viewmodel.dart) — Added `markAllAsRead()` and `clearAll()` methods.
29. [`lib/presentation/teacher_profile/view/teacher_profile_view.dart`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/lib/presentation/teacher_profile/view/teacher_profile_view.dart) — Added verified credentials card, OTP phone number verification flow, and delete account redirect.
30. [`backend.md`](file:///w:/Azeem%20Book%20Related/Azeem-Book-App-1/backend.md) — Documented API endpoints, query filters, and verification contracts.

### 6.3. Deleted Files
* **None** (all existing legacy views and widgets were upgraded in place without breaking architectural hierarchy).

