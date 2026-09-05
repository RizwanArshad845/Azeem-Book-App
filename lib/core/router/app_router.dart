import 'package:flutter/cupertino.dart' show CupertinoPage;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth/entities/user_role.dart';
import '../../presentation/auth/view/otp_verify_view.dart';
import '../../presentation/auth/view/phone_entry_view.dart';
import '../../presentation/auth/view/role_select_view.dart';
import '../../presentation/auth/viewmodel/auth_viewmodel.dart';
import '../../presentation/notifications/view/notifications_view.dart';
import '../../presentation/splash/view/splash_view.dart';
import '../../presentation/student_cart/view/checkout_view.dart';
import '../../presentation/student_cart/view/student_cart_view.dart';
import '../../presentation/student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../presentation/student_progress/view/student_progress_view.dart';
import '../../presentation/live_test_registration/view/live_tests_view.dart';
import '../../presentation/student_home/view/chapter_list_view.dart';
import '../../presentation/student_home/view/student_home_view.dart';
import '../../presentation/student_home/view/test_list_view.dart';
import '../../presentation/student_onboarding/view/student_academic_info_view.dart';
import '../../presentation/student_onboarding/view/student_basic_info_view.dart';
import '../../presentation/student_onboarding/view/student_onboarding_review_view.dart';
import '../../presentation/student_profile/view/student_profile_view.dart';
import '../../presentation/teacher_profile/view/teacher_profile_view.dart';
import '../../presentation/student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../../presentation/test_taking/view/test_taking_view.dart';
import '../../presentation/teacher_onboarding/view/teacher_onboarding_review_view.dart';
import '../../presentation/teacher_onboarding/view/teacher_pending_approval_view.dart';
import '../../presentation/teacher_onboarding/view/teacher_signup_view.dart';
import '../../presentation/teacher_earnings/view/teacher_earnings_view.dart';
import '../../presentation/teacher_overview/view/teacher_overview_view.dart';
import '../../presentation/teacher_students/view/student_progress_detail_view.dart';
import '../../presentation/teacher_students/view/teacher_students_view.dart';
import '../../presentation/teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import '../constants/app_routes.dart';
import '../extensions/context_extensions.dart';
import '../widgets/app_scaffold_with_bottom_nav.dart';

/// iOS/macOS get the native `CupertinoPage` transition (and, critically, its
/// built-in edge-swipe-to-pop gesture — `CustomTransitionPage`'s fully custom
/// `buildTransitions` bypasses `PageTransitionsTheme`/
/// `CupertinoPageTransitionsBuilder` entirely, so swipe-back doesn't work on
/// any route using it). Android/other platforms keep the existing custom
/// fade+slide transitions below, unchanged.
bool get _useCupertinoTransition =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

Page<void> _appPage(GoRouterState state, Widget child) {
  if (_useCupertinoTransition) {
    return CupertinoPage<void>(key: state.pageKey, child: child);
  }
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    // Tightened from 260ms/200ms (Workstream 7 — motion polish) so
    // navigation reads as immediate rather than sluggish, while keeping the
    // same easeOutCubic-style feel.
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 160),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.03),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

/// Faster, directional transition for onboarding step-to-step navigation
/// (basic info -> academic info) — distinct from the generic cross-app
/// `_appPage` fade+slide so advancing through onboarding reads as
/// progress, not a context switch. Scoped to just these routes; the global
/// `_appPage` transition is untouched. iOS/macOS still get `CupertinoPage`
/// (see `_appPage`) so swipe-back works on onboarding steps too.
Page<void> _onboardingStepPage(GoRouterState state, Widget child) {
  if (_useCupertinoTransition) {
    return CupertinoPage<void>(key: state.pageKey, child: child);
  }
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incoming = Tween<Offset>(
        begin: const Offset(0.25, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final outgoing = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.15, 0),
      ).animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic));
      return SlideTransition(
        position: outgoing,
        child: SlideTransition(
          position: incoming,
          child: FadeTransition(opacity: animation, child: child),
        ),
      );
    },
  );
}

List<BottomNavDestinationSpec> _buildStudentDestinations(
  BuildContext context,
  int cartCount,
) {
  return [
    BottomNavDestinationSpec(
      icon: Icons.home_outlined,
      label: context.l10n.navHome,
    ),
    BottomNavDestinationSpec(
      icon: Icons.shopping_cart_outlined,
      label: context.l10n.navCart,
      badgeCount: cartCount,
    ),
    BottomNavDestinationSpec(
      icon: Icons.insights_outlined,
      label: context.l10n.navProgress,
    ),
  ];
}

List<BottomNavDestinationSpec> _buildTeacherDestinations(BuildContext context) {
  return [
    BottomNavDestinationSpec(
      icon: Icons.home_outlined,
      label: context.l10n.navHome,
    ),
    BottomNavDestinationSpec(
      icon: Icons.people_outline,
      label: context.l10n.navStudents,
    ),
    BottomNavDestinationSpec(
      icon: Icons.account_balance_wallet_outlined,
      label: context.l10n.navEarnings,
    ),
  ];
}

const _authRoutes = {
  AppRoutes.authRoleSelect,
  AppRoutes.authPhone,
  AppRoutes.authOtp,
};

const _studentOnboardingRoutes = {
  AppRoutes.studentOnboardingBasicInfo,
  AppRoutes.studentOnboardingAcademicInfo,
  AppRoutes.studentOnboardingReview,
};

const _studentShellRoutes = {
  AppRoutes.studentHome,
  AppRoutes.studentCart,
  AppRoutes.studentProgress,
};

const _teacherShellRoutes = {
  AppRoutes.teacherOverview,
  AppRoutes.teacherStudents,
  AppRoutes.teacherEarnings,
};

// Pushed on top of either shell (or before it) once a role/onboarding stage
// is fully resolved — live tests, checkout, per-student detail. `testTaking`
// is checked separately via a prefix match since it carries a `:testId`
// path param, so `state.matchedLocation` is a concrete path like
// `/test-taking/abc123`, never the literal `AppRoutes.testTaking` pattern.
const _outsideShellRoutes = {
  AppRoutes.cartCheckout,
  AppRoutes.studentProfile,
  // Round-2: Profile + Notifications moved off the bottom nav to dedicated
  // app-bar icons; they now push full-screen on top of either shell.
  AppRoutes.teacherProfile,
  AppRoutes.studentNotifications,
  AppRoutes.teacherNotifications,
};

bool _isOutsideShellRoute(String location) =>
    _outsideShellRoutes.contains(location) ||
    location.startsWith('/test-taking/') ||
    (location.startsWith('/teacher/students/') &&
        location.endsWith('/progress'));

/// Re-evaluates the router `redirect` whenever session or onboarding state
/// changes — e.g. right after OTP verification succeeds, or right after an
/// onboarding form submits, since neither of those flows navigates itself
/// (§10.2: redirect owns "where does an authenticated user belong").
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(currentUserProvider, (_, _) => notifyListeners());
    ref.listen(teacherOnboardingViewModelProvider, (_, _) => notifyListeners());
    ref.listen(studentOnboardingViewModelProvider, (_, _) => notifyListeners());
  }
}

/// Single source of truth for "where does this request belong right now,"
/// given the current auth session and (role-specific) onboarding progress.
/// Returns `null` to allow the requested [location] as-is.
String? _redirectFor(Ref ref, String location) {
  if (location == AppRoutes.splash) return null;

  final session = ref.read(currentUserProvider);
  if (session == null) {
    return _authRoutes.contains(location) ? null : AppRoutes.authRoleSelect;
  }

  if (session.role == UserRole.teacher) {
    final teacherAsync = ref.read(teacherOnboardingViewModelProvider);
    if (teacherAsync.isLoading && !teacherAsync.hasValue) return null;

    final teacher = teacherAsync.value;
    if (teacher == null) {
      const teacherPreSubmitRoutes = {
        AppRoutes.teacherOnboardingSignup,
        AppRoutes.teacherOnboardingReview,
      };
      return teacherPreSubmitRoutes.contains(location)
          ? null
          : AppRoutes.teacherOnboardingSignup;
    }

    if (teacherOnboardingStageOf(teacher) ==
        TeacherOnboardingStage.pendingApproval) {
      return location == AppRoutes.teacherOnboardingPending
          ? null
          : AppRoutes.teacherOnboardingPending;
    }

    final allowed =
        _teacherShellRoutes.contains(location) || _isOutsideShellRoute(location);
    return allowed ? null : AppRoutes.teacherOverview;
  }

  final studentAsync = ref.read(studentOnboardingViewModelProvider);
  if (studentAsync.isLoading && !studentAsync.hasValue) return null;

  final student = studentAsync.value;
  if (student == null) {
    return _studentOnboardingRoutes.contains(location)
        ? null
        : AppRoutes.studentOnboardingBasicInfo;
  }

  final allowed =
      _studentShellRoutes.contains(location) ||
      _isOutsideShellRoute(location) ||
      location.startsWith('${AppRoutes.studentHome}/');
  return allowed ? null : AppRoutes.studentHome;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _redirectFor(ref, state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _appPage(state, const SplashView()),
      ),

      // Auth (outside shell)
      GoRoute(
        path: AppRoutes.authRoleSelect,
        pageBuilder: (context, state) =>
            _appPage(state, const RoleSelectView()),
      ),
      GoRoute(
        path: AppRoutes.authPhone,
        pageBuilder: (context, state) =>
            _appPage(state, const PhoneEntryView()),
      ),
      GoRoute(
        path: AppRoutes.authOtp,
        pageBuilder: (context, state) =>
            _appPage(state, const OtpVerifyView()),
      ),

      // Teacher onboarding (outside shell)
      GoRoute(
        path: AppRoutes.teacherOnboardingSignup,
        pageBuilder: (context, state) =>
            _appPage(state, const TeacherSignupView()),
      ),
      GoRoute(
        path: AppRoutes.teacherOnboardingReview,
        pageBuilder: (context, state) =>
            _onboardingStepPage(state, const TeacherOnboardingReviewView()),
      ),
      GoRoute(
        path: AppRoutes.teacherOnboardingPending,
        pageBuilder: (context, state) =>
            _appPage(state, const TeacherPendingApprovalView()),
      ),

      // Student onboarding (outside shell) — own faster, directional
      // step-to-step transition (see `_onboardingStepPage`).
      GoRoute(
        path: AppRoutes.studentOnboardingBasicInfo,
        pageBuilder: (context, state) =>
            _onboardingStepPage(state, const StudentBasicInfoView()),
      ),
      GoRoute(
        path: AppRoutes.studentOnboardingAcademicInfo,
        pageBuilder: (context, state) =>
            _onboardingStepPage(state, const StudentAcademicInfoView()),
      ),
      GoRoute(
        path: AppRoutes.studentOnboardingReview,
        pageBuilder: (context, state) =>
            _onboardingStepPage(state, const StudentOnboardingReviewView()),
      ),

      // Student shell (§10.2 tab set)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => Consumer(
          builder: (context, ref, _) {
            // Scoped to the student shell only — watching the cart here
            // (rather than inside `AppScaffoldWithBottomNav` itself) keeps
            // the teacher shell from ever building a `StudentCartViewModel`
            // for a teacher session.
            final cartCount = ref.watch(
              studentCartViewModelProvider.select(
                (c) => c.value?.items?.length ?? 0,
              ),
            );
            return AppScaffoldWithBottomNav(
              navigationShell: navigationShell,
              destinations: _buildStudentDestinations(context, cartCount),
            );
          },
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.studentHome,
                pageBuilder: (context, state) =>
                    _appPage(state, const StudentHomeView()),
                routes: [
                  GoRoute(
                    path: 'subject/:subjectId/chapters',
                    pageBuilder: (context, state) => _appPage(
                      state,
                      ChapterListView(
                        subjectId: state.pathParameters['subjectId']!,
                        subjectName: state.extra as String?,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'subject/:subjectId/chapter/:chapterId/tests',
                    pageBuilder: (context, state) => _appPage(
                      state,
                      TestListView(
                        subjectId: state.pathParameters['subjectId']!,
                        chapterId: state.pathParameters['chapterId']!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'live-tests',
                    pageBuilder: (context, state) =>
                        _appPage(state, const LiveTestsView()),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.studentCart,
                pageBuilder: (context, state) =>
                    _appPage(state, const StudentCartView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.studentProgress,
                pageBuilder: (context, state) =>
                    _appPage(state, const StudentProgressView()),
              ),
            ],
          ),
        ],
      ),

      // Teacher shell (§10.2 tab set)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppScaffoldWithBottomNav(
              navigationShell: navigationShell,
              destinations: _buildTeacherDestinations(context),
            ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.teacherOverview,
                pageBuilder: (context, state) =>
                    _appPage(state, const TeacherOverviewView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.teacherStudents,
                pageBuilder: (context, state) =>
                    _appPage(state, const TeacherStudentsView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.teacherEarnings,
                pageBuilder: (context, state) =>
                    _appPage(state, const TeacherEarningsView()),
              ),
            ],
          ),
        ],
      ),

      // Outside-shell, pushed on top (bottom nav disappears mid-task)
      GoRoute(
        path: AppRoutes.studentProfile,
        pageBuilder: (context, state) =>
            _appPage(state, const StudentProfileView()),
      ),
      GoRoute(
        path: AppRoutes.teacherProfile,
        pageBuilder: (context, state) =>
            _appPage(state, const TeacherProfileView()),
      ),
      // Notifications — pushed full-screen via the app-bar bell icon (no
      // longer a bottom-nav tab). Same view serves both roles.
      GoRoute(
        path: AppRoutes.studentNotifications,
        pageBuilder: (context, state) =>
            _appPage(state, const NotificationsView()),
      ),
      GoRoute(
        path: AppRoutes.teacherNotifications,
        pageBuilder: (context, state) =>
            _appPage(state, const NotificationsView()),
      ),
      GoRoute(
        path: AppRoutes.testTaking,
        pageBuilder: (context, state) => _appPage(
          state,
          TestTakingView(testId: state.pathParameters['testId']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.cartCheckout,
        pageBuilder: (context, state) =>
            _appPage(state, const CheckoutView()),
      ),
      GoRoute(
        path: AppRoutes.teacherStudentProgressDetail,
        pageBuilder: (context, state) => _appPage(
          state,
          StudentProgressDetailView(
            studentId: state.pathParameters['studentId']!,
          ),
        ),
      ),
    ],
  );
});
