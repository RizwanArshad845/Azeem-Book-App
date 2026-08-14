import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/diagnostic/entities/test_session.dart';
import '../../presentation/diagnostic/view/consent_view.dart';
import '../../presentation/diagnostic/view/results_view.dart';
import '../../presentation/diagnostic/view/self_assessment_view.dart';
import '../../presentation/diagnostic/view/test_view.dart';
import '../../presentation/home/view/home_view.dart';
import '../../presentation/onboarding/state/onboarding_state.dart';
import '../../presentation/onboarding/view/personal_info_view.dart';
import '../../presentation/onboarding/view/phone_number_view.dart';
import '../../presentation/onboarding/view/subject_count_view.dart';
import '../../presentation/onboarding/view/subject_selection_view.dart';
import '../../presentation/diagnostic/viewmodel/test_viewmodel.dart';
import '../../presentation/onboarding/viewmodel/onboarding_viewmodel.dart';
import '../../presentation/splash/view/splash_view.dart';
import '../constants/app_routes.dart';

const _onboardingStepOrder = [
  AppRoutes.onboardingPhone,
  AppRoutes.onboardingPersonalInfo,
  AppRoutes.onboardingSubjectCount,
  AppRoutes.onboardingSubjects,
];

int _furthestAllowedOnboardingIndex(OnboardingState s) {
  if (!s.otpVerified) return 0;
  if (!s.isPersonalInfoComplete) return 1;
  return _onboardingStepOrder.length - 1;
}

/// Cheap GPU-composited (opacity + transform only) page transition used for
/// every route, instead of the platform default, for a more polished feel.
CustomTransitionPage<void> _appPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

const _diagnosticRoutes = {
  AppRoutes.diagnosticSelfAssessment,
  AppRoutes.diagnosticConsent,
  AppRoutes.diagnosticTest,
  AppRoutes.diagnosticResults,
};

/// Bridges Riverpod state changes into go_router's `refreshListenable` so
/// `redirect` re-evaluates whenever onboarding or test session state changes.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(onboardingViewModelProvider, (_, _) => notifyListeners());
    ref.listen(testViewModelProvider, (_, _) => notifyListeners());
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final onboarding = ref.read(onboardingViewModelProvider);
      final testSession = ref.read(testViewModelProvider);
      final location = state.matchedLocation;

      if (location == AppRoutes.splash) return null;

      if (_onboardingStepOrder.contains(location)) {
        if (onboarding.isOnboardingComplete) return AppRoutes.home;
        final requestedIndex = _onboardingStepOrder.indexOf(location);
        final furthest = _furthestAllowedOnboardingIndex(onboarding);
        if (requestedIndex > furthest) return _onboardingStepOrder[furthest];
        return null;
      }

      if (location == AppRoutes.home) {
        if (!onboarding.isOnboardingComplete) {
          return _onboardingStepOrder[_furthestAllowedOnboardingIndex(onboarding)];
        }
        return null;
      }

      if (_diagnosticRoutes.contains(location)) {
        if (!onboarding.isOnboardingComplete) return AppRoutes.home;

        if (location == AppRoutes.diagnosticTest) {
          if (testSession.status == TestSessionStatus.completed) {
            return AppRoutes.diagnosticResults;
          }
          if (!testSession.consentAcknowledged || testSession.questions.isEmpty) {
            return AppRoutes.diagnosticConsent;
          }
          return null;
        }

        if (location == AppRoutes.diagnosticResults) {
          if (testSession.status != TestSessionStatus.completed) {
            return AppRoutes.home;
          }
          return null;
        }

        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _appPage(state, const SplashView()),
      ),
      GoRoute(
        path: AppRoutes.onboardingPhone,
        pageBuilder: (context, state) => _appPage(state, const PhoneNumberView()),
      ),
      GoRoute(
        path: AppRoutes.onboardingPersonalInfo,
        pageBuilder: (context, state) => _appPage(state, const PersonalInfoView()),
      ),
      GoRoute(
        path: AppRoutes.onboardingSubjectCount,
        pageBuilder: (context, state) => _appPage(state, const SubjectCountView()),
      ),
      GoRoute(
        path: AppRoutes.onboardingSubjects,
        pageBuilder: (context, state) => _appPage(state, const SubjectSelectionView()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => _appPage(state, const HomeView()),
      ),
      GoRoute(
        path: AppRoutes.diagnosticSelfAssessment,
        pageBuilder: (context, state) => _appPage(state, const SelfAssessmentView()),
      ),
      GoRoute(
        path: AppRoutes.diagnosticConsent,
        pageBuilder: (context, state) => _appPage(state, const ConsentView()),
      ),
      GoRoute(
        path: AppRoutes.diagnosticTest,
        pageBuilder: (context, state) => _appPage(state, const TestView()),
      ),
      GoRoute(
        path: AppRoutes.diagnosticResults,
        pageBuilder: (context, state) => _appPage(state, const ResultsView()),
      ),
    ],
  );
});
