import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/illustrated_list_card.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../viewmodel/add_subject_viewmodel.dart';

/// Bottom sheet on Student Home for an already-onboarded student to add more
/// subjects from their own board class. Tapping a subject adds it right away
/// (no teacher — that can be chosen later from the subject's chapter list).
class AddSubjectSheet extends ConsumerWidget {
  const AddSubjectSheet({super.key});

  static void show(BuildContext context) {
    AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.addSubjectTitle,
      subtitle: context.l10n.addSubjectSubtitle,
      child: const AddSubjectSheet(),
    );
  }

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
  ) async {
    final failure = await ref
        .read(addSubjectViewModelProvider.notifier)
        .add(subject.id);
    if (!context.mounted) return;
    if (failure == null) {
      AppSnackbar.show(
        context,
        context.l10n.addSubjectSuccess(
          context.l10n.localizedSubjectName(subject.name),
        ),
      );
    } else {
      AppSnackbar.show(context, failure.localizedMessage(context));
      // Stale list (e.g. already added elsewhere) — reload what's addable.
      ref.invalidate(addableSubjectsProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(addableSubjectsProvider);
    final addingId = ref.watch(addSubjectViewModelProvider);

    return AsyncValueWidget<List<Subject>>(
      value: subjectsAsync,
      skeleton: const SkeletonList(itemCount: 3),
      onRetry: () => ref.invalidate(addableSubjectsProvider),
      data: (subjects) {
        if (subjects.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.dimens.lg),
            child: EmptyStateView(message: context.l10n.addSubjectNoneLeft),
          );
        }
        // Bounded height so the list itself scrolls when there are many
        // subjects (the sheet wraps its child in an unbounded scroll view).
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.md,
              vertical: context.dimens.sm,
            ),
            itemCount: subjects.length,
            separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              final isAdding = addingId == subject.id;
              return IllustratedListCard(
                title: context.l10n.localizedSubjectName(subject.name),
                imageAsset: subjectIllustration(subject.name),
                fallbackIcon: subjectIcon(subject.name),
                meta: isAdding
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        context.l10n.addSubjectTapToAdd,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                // Ignore taps while any add is running (the viewmodel also
                // guards, this just avoids a no-op tap feeling live).
                onTap: addingId == null
                    ? () => _add(context, ref, subject)
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}
