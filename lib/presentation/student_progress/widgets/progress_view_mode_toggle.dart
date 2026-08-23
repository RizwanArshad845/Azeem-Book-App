import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/student_progress_viewmodel.dart';

/// Segmented "Overall Cumulative Progress" vs "Per-Subject Progress" toggle
/// (CLAUDE.md's Progress Screen requirement). Custom-built (not the Material
/// `SegmentedButton`, which pulls its selected/unselected colors from
/// `Theme.colorScheme` rather than this app's `context.colors` extension)
/// so it stays on the same brand palette as every other shared widget.
class ProgressViewModeToggle extends ConsumerWidget {
  const ProgressViewModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(progressViewModeProvider);

    return Container(
      padding: EdgeInsets.all(context.dimens.xs / 2),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(context.dimens.pillRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              icon: Icons.pie_chart_outline,
              label: context.l10n.progressViewOverall,
              selected: mode == ProgressViewMode.overall,
              onTap: () => ref
                  .read(progressViewModeProvider.notifier)
                  .setMode(ProgressViewMode.overall),
            ),
          ),
          Expanded(
            child: _Segment(
              icon: Icons.bar_chart_outlined,
              label: context.l10n.progressViewPerSubject,
              selected: mode == ProgressViewMode.perSubject,
              onTap: () => ref
                  .read(progressViewModeProvider.notifier)
                  .setMode(ProgressViewMode.perSubject),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? context.colors.onPrimary
        : context.colors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: context.dimens.sm),
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(context.dimens.pillRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: context.dimens.iconSm, color: foreground),
            SizedBox(width: context.dimens.xs),
            Text(
              label,
              style: context.textStyles.labelLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
