import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../viewmodel/test_taking_state.dart';
import '../viewmodel/test_taking_viewmodel.dart';
import '../widgets/grading_in_progress_view.dart';
import '../widgets/loading_gate.dart';
import '../widgets/not_purchased_view.dart';
import '../widgets/question_body.dart';
import 'test_results_view.dart';

/// Full-screen, outside-shell test-taking flow (project_spec.md §10.2 — "no
/// pause / no bottom-nav during an active test"), constructed as
/// parameterized sub-routes (`AppRoutes.studentTestTaking`, `:testId`).
/// Intercepts back navigation with a `PopScope` dialog so an accidentally-
/// tapped system back button won't abandon progress without warning.
class TestTakingView extends ConsumerWidget {
  const TestTakingView({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(testTakingViewModelProvider(testId));
    final status = asyncState.value?.status;
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final subjectId = asyncState.value?.test?.subjectId;
    final isOwned = subjectId != null && (purchasedIds?.contains(subjectId) ?? false);

    return PopScope(
      canPop: status != TestTakingStatus.inProgress &&
          status != TestTakingStatus.submitting &&
          status != TestTakingStatus.awaitingGrading,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirmed = await _confirmExit(context);
        if (confirmed == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: AppBarTitle(context.l10n.testTakingTitle)),
        body: SafeArea(
          child: AsyncValueWidget<TestTakingState>(
            value: asyncState,
            onRetry: () => ref.invalidate(testTakingViewModelProvider(testId)),
            data: (state) => switch (state.status) {
              TestTakingStatus.loadingGate => const LoadingGate(),
              TestTakingStatus.notPurchased => const NotPurchasedView(),
              TestTakingStatus.inProgress ||
              TestTakingStatus.submitting => QuestionBody(testId: testId),
              TestTakingStatus.awaitingGrading =>
                GradingInProgressView(progress: state.gradingProgress),
              TestTakingStatus.submitted => TestResultsView(
                testId: testId,
                attempt: state.result!,
                isOwned: isOwned,
              ),
            },
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmExit(BuildContext context) {
    return confirmDialog(
      context,
      title: context.l10n.testExitDialogTitle,
      message: context.l10n.testExitDialogBody,
      cancelLabel: context.l10n.testExitDialogStay,
      confirmLabel: context.l10n.testExitDialogConfirm,
      isDestructive: true,
    );
  }
}
