import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_progress_indicator.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';
class StudentNameEntryView extends ConsumerStatefulWidget {
  const StudentNameEntryView({super.key});

  @override
  ConsumerState<StudentNameEntryView> createState() =>
      _StudentNameEntryViewState();
}

class _StudentNameEntryViewState extends ConsumerState<StudentNameEntryView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _controller.text.trim();
    final errorNotifier = ref.read(studentNameErrorViewModelProvider.notifier);
    if (name.isEmpty) {
      errorNotifier.setError(context.l10n.commonRequiredField);
      return;
    }
    errorNotifier.setError(null);
    ref.read(studentOnboardingViewModelProvider.notifier).recordName(name);
    context.push(AppRoutes.studentOnboardingCampus);
  }

  @override
  Widget build(BuildContext context) {
    final error = ref.watch(studentNameErrorViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.studentNameEntryTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionProgressIndicator(currentStep: 0, totalSteps: 4),
              SizedBox(height: context.dimens.lg),
              Text(
                context.l10n.studentNameEntrySubtitle,
                style: context.textStyles.titleMedium,
              ),
              SizedBox(height: context.dimens.lg),
              AppTextField(
                label: context.l10n.nameLabel,
                hint: context.l10n.nameHint,
                controller: _controller,
                textCapitalization: TextCapitalization.words,
                errorText: error,
              ),
              SizedBox(height: context.dimens.lg),
              AppPrimaryButton(
                label: context.l10n.commonContinue,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
