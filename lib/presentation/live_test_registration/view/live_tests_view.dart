import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../student_home/viewmodel/student_home_viewmodel.dart';
import '../viewmodel/live_test_registration_viewmodel.dart';
import '../widgets/live_test_card.dart';

/// Dedicated "Live Tests" screen (§10.2 live-test surface; §11 Phase-1
/// scope "Live tests | Beta (register + run)" — explicitly no leaderboard
/// UI). Lists every Admin-scheduled live test relevant to the current
/// student (`Test.isLive == true`, scoped to their enrolled subjects) with
/// registration status and the one action that applies to each: Register,
/// Registered (no action), or Enter once `liveDate` has arrived.
///
/// Reached from a small entry point on `StudentHomeView`; reuses
/// `liveTestsProvider` (already enrolled-subject-scoped + sorted by
/// `liveDate`, defined in `student_home_viewmodel.dart`) rather than
/// re-deriving the same "which live tests apply to this student" read here
/// — this feature only adds the registration state machine on top of it.
class LiveTestsView extends ConsumerWidget {
  const LiveTestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveTestsAsync = ref.watch(liveTestsProvider);
    final registrationsAsync = ref.watch(liveTestRegistrationViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.liveTestsTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(liveTestsProvider);
            ref.invalidate(liveTestRegistrationViewModelProvider);
          },
          child: AsyncValueWidget<List<Test>>(
            value: liveTestsAsync,
            onRetry: () => ref.invalidate(liveTestsProvider),
            data: (liveTests) {
              if (liveTests.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    EmptyStateView(
                      icon: Icons.podcasts,
                      message: context.l10n.liveTestsEmpty,
                    ),
                  ],
                );
              }

              final registeredTestIds = (registrationsAsync.value ?? const [])
                  .map((registration) => registration.testId)
                  .toSet();
              final isRegistering = registrationsAsync.isLoading;

              return ListView.separated(
                padding: EdgeInsets.all(context.dimens.lg),
                itemCount: liveTests.length,
                separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
                itemBuilder: (context, index) {
                  final test = liveTests[index];
                  return LiveTestCard(
                    test: test,
                    isRegistered: registeredTestIds.contains(test.id),
                    isRegistering: isRegistering,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
