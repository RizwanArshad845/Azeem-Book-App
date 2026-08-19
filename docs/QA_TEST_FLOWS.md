# QA Manual Test Script & Feature Flow Guide

> [!NOTE]
> This document provides end-to-end step-by-step manual test cases for QA engineers and manual testers covering all 15 feature modules in **Azeem Book App**.

---

## Table of Test Flows

1. [Flow 1: Authentication & Role Selection](#flow-1-authentication--role-selection)
2. [Flow 2: Student Onboarding](#flow-2-student-onboarding)
3. [Flow 3: Teacher Onboarding & Approval Gate](#flow-3-teacher-onboarding--approval-gate)
4. [Flow 4: Student Home & Catalog Browsing](#flow-4-student-home--catalog-browsing)
5. [Flow 5: Shopping Cart & Checkout](#flow-5-shopping-cart--checkout)
6. [Flow 6: Test Taking, Exit Dialog & Auto-Grading](#flow-6-test-taking-exit-dialog--auto-grading)
7. [Flow 7: Student Progress & Analytics](#flow-7-student-progress--analytics)
8. [Flow 8: Live Test Registration](#flow-8-live-test-registration)
9. [Flow 9: Teacher Dashboard & Student Directory](#flow-9-teacher-dashboard--student-directory)
10. [Flow 10: Teacher Earnings & Payout History](#flow-10-teacher-earnings--payout-history)
11. [Flow 11: Notifications Center](#flow-11-notifications-center)
12. [Flow 12: Profile Management & English/Urdu Toggle](#flow-12-profile-management--englishurdu-toggle)
13. [Flow 13: Session Termination & Account Deletion](#flow-13-session-termination--account-deletion)

---

## Test Cases

### Flow 1: Authentication & Role Selection
- **Pre-condition**: App is freshly installed or user is logged out.
- **Steps**:
  1. Open app. Verify `PhoneEntryView` appears.
  2. Input invalid phone number (`1234`). Tap **Send code**. Verify inline validation error appears.
  3. Input valid 10-digit number (`3001234567`). Tap **Send code**.
  4. On `OtpEntryView`, enter `1234`.
  5. On `RoleSelectionView`, tap **Student** (or **Teacher**).
- **Expected Result**: Phone verification succeeds; user is navigated to the appropriate role onboarding sequence.

---

### Flow 2: Student Onboarding
- **Pre-condition**: Logged in as a new Student without completed onboarding.
- **Steps**:
  1. `CampusSelectView`: Search and select a campus (e.g. "Lahore Main Campus"). Tap **Next**.
  2. `BoardClassSelectView`: Select Education Board (e.g. "BISE Lahore") and Class Level (e.g. "Class 11"). Tap **Continue**.
  3. `SubjectTeacherSelectView`: Select enrolled subjects (e.g. "Computer Science", "Physics") and assign a teacher for each. Tap **Complete Setup**.
- **Expected Result**: Student profile is created and user lands on `StudentHomeView` with bottom navigation shell.

---

### Flow 3: Teacher Onboarding & Approval Gate
- **Pre-condition**: Logged in as a new Teacher.
- **Steps**:
  1. `TeacherSignupView`: Fill in Full Name, Qualification, Campus, and Subject specializations. Tap **Submit Application**.
  2. Observe navigation to `TeacherPendingApprovalView`.
- **Expected Result**: Screen displays "Pending Approval" notice stating application is under review by Azeem Publications administration.

---

### Flow 4: Student Home & Catalog Browsing
- **Pre-condition**: Student onboarding completed.
- **Steps**:
  1. Open `StudentHomeView`. Observe greeting header ("Hi, Ali Raza"), enrolled subject pills, diagnostic test card, and bottom navigation.
  2. Tap on "Computer Science" subject pill.
  3. Observe list of available chapter test suites and price tags (Free vs Paid).
- **Expected Result**: Chapter list renders cleanly with accurate status badges ("Free", "Purchased", "Rs. 250").

---

### Flow 5: Shopping Cart & Checkout
- **Pre-condition**: Student browsing catalog.
- **Steps**:
  1. Tap **Add to Cart** on a paid test suite.
  2. Navigate to `CartView` via bottom bar icon. Verify item appears with price breakdown.
  3. Tap **Proceed to Checkout**.
  4. On `CheckoutView`, select payment method (e.g. "EasyPaisa / JazzCash / Card") and tap **Pay Now**.
- **Expected Result**: Processing spinner shows, purchase completes with success message, cart clears, and test suite unlocks instantly.

---

### Flow 6: Test Taking, Exit Dialog & Auto-Grading
- **Pre-condition**: Unlocked test ready to take.
- **Steps**:
  1. Tap **Start Test**. Read consent dialog and check agreement box. Tap **Begin Test**.
  2. Observe `TestTakingView`: countdown timer bar, question progress ("Q 1/10"), REC recording indicator, MCQ option cards.
  3. Select answers for questions 1 through 5.
  4. Tap back button or exit icon. Observe `confirmDialog` ("Leave test? Progress will be lost"). Tap **Cancel**.
  5. Complete remaining questions and tap **Submit Test**.
- **Expected Result**: Test closes, auto-grader calculates score, and opens `TestResultsView` showing overall score percentage, readiness gauge, and chapter breakdown.

---

### Flow 7: Student Progress & Analytics
- **Pre-condition**: At least one test completed.
- **Steps**:
  1. Tap **Progress** tab on bottom navigation bar (`StudentProgressView`).
  2. View overall score gauge, total tests taken counter, and chapter performance pie chart.
  3. Scroll down to view **Attempt History** list.
- **Expected Result**: Attempt history displays test title, score percentage, date, and `StatusBadge` ("Passed" / "Needs Review").

---

### Flow 8: Live Test Registration
- **Pre-condition**: Student on Home or Catalog.
- **Steps**:
  1. Tap **Live Tests** section on home page (`LiveTestsView`).
  2. View upcoming scheduled live tests with start times and duration.
  3. Tap **Register Now** button on an upcoming test card.
- **Expected Result**: Button updates dynamically to `StatusBadge` showing "Registered" with a checkmark.

---

### Flow 9: Teacher Dashboard & Student Directory
- **Pre-condition**: Logged in as an approved Teacher.
- **Steps**:
  1. `TeacherOverviewView`: View `StatSummaryCard` widgets ("Students Onboarded", "Total Earnings", "Active Tests").
  2. Tap **My Students** tab (`TeacherStudentsView`).
  3. Use search bar to filter student name (e.g. "Ali").
  4. Tap a student card to open `StudentDetailView`.
- **Expected Result**: Student details open showing student contact info, enrolled class/board, and detailed test performance report.

---

### Flow 10: Teacher Earnings & Payout History
- **Pre-condition**: Logged in as Teacher with student test purchases attributed.
- **Steps**:
  1. Navigate to `TeacherEarningsView`.
  2. View revenue summary (`StatSummaryCard` for Total Revenue, Commission Earned, Pending Payout).
  3. Scroll through Payout History log.
- **Expected Result**: Earnings breakdown renders with formatted Currency (`Rs. X,XXX`) and commission rates.

---

### Flow 11: Notifications Center
- **Pre-condition**: User logged in (Student or Teacher).
- **Steps**:
  1. Tap notification bell icon in top app bar.
  2. View list of system notifications (test reminders, purchase receipts, approval alerts).
  3. Tap **Mark all as read**.
- **Expected Result**: Unread badge count clears; notification cards update to read state.

---

### Flow 12: Profile Management & English/Urdu Toggle
- **Pre-condition**: User on Profile tab.
- **Steps**:
  1. Navigate to `StudentProfileView` (or `TeacherProfileView`).
  2. Edit Name field and tap **Save**. Verify success snackbar.
  3. Locate **Language / زبان** section (`_LanguageCard`).
  4. Tap **اردو (Urdu)** chip.
- **Expected Result**: Entire application UI instantly updates text to Urdu script with correct right-to-left orientation where applicable. Tapping **English** returns UI to English text.

---

### Flow 13: Session Termination & Account Deletion
- **Pre-condition**: User on Profile tab.
- **Steps**:
  1. Scroll to bottom of Profile view.
  2. Tap **Delete Account** text button.
  3. Observe destructive confirmation dialog (`confirmDialog`). Tap **Cancel**. Verify dialog dismisses without logging out.
  4. Tap **Delete Account** again. Tap **Delete** in dialog.
- **Expected Result**: Account data is removed, local secure storage session clears, and user is redirected immediately back to `PhoneEntryView`.
