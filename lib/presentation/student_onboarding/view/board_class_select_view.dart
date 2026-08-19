import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/section_progress_indicator.dart';
import '../../../domain/catalog/entities/board_class.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';
import '../widgets/board_class_row.dart';

/// Step 2/3 of student onboarding. Renders every Admin-managed board/class,
/// including disabled ones — disabled rows render visibly but unselectable
/// ("coming soon"), per §9.1/§9.2 (`BoardClass.isEnabled == false`).
class BoardClassSelectView extends ConsumerStatefulWidget {
  const BoardClassSelectView({super.key});

  @override
  ConsumerState<BoardClassSelectView> createState() =>
      _BoardClassSelectViewState();
}

class _BoardClassSelectViewState extends ConsumerState<BoardClassSelectView> {
  String? _selectedId;

  void _continue() {
    final selectedId = _selectedId;
    if (selectedId == null) return;
    ref
        .read(studentOnboardingViewModelProvider.notifier)
        .selectBoardClass(selectedId);
    context.push(AppRoutes.studentOnboardingSubjects);
  }

  @override
  Widget build(BuildContext context) {
    final boardClassesAsync = ref.watch(boardClassesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.boardClassSelectTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionProgressIndicator(currentStep: 1, totalSteps: 3),
              SizedBox(height: context.dimens.lg),
              Text(
                context.l10n.boardClassSelectSubtitle,
                style: context.textStyles.titleMedium,
              ),
              SizedBox(height: context.dimens.lg),
              Expanded(
                child: AsyncValueWidget<List<BoardClass>>(
                  value: boardClassesAsync,
                  onRetry: () => ref.invalidate(boardClassesProvider),
                  data: (boardClasses) => boardClasses.isEmpty
                      ? EmptyStateView(
                          message: context.l10n.boardClassSelectEmpty,
                        )
                      : ListView.separated(
                          itemCount: boardClasses.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: context.dimens.sm),
                          itemBuilder: (context, index) {
                            final boardClass = boardClasses[index];
                            final isSelected =
                                boardClass.id == _selectedId;
                            return BoardClassRow(
                              boardClass: boardClass,
                              isSelected: isSelected,
                              onTap: boardClass.isEnabled
                                  ? () => setState(
                                      () => _selectedId = boardClass.id,
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
              ),
              SizedBox(height: context.dimens.lg),
              AppPrimaryButton(
                label: context.l10n.commonContinue,
                onPressed: _selectedId == null ? null : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
