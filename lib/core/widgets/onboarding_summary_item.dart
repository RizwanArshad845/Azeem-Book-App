import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Icon-led label/value row for an onboarding review screen (e.g. "Phone
/// number: 03001234567"). Shared by both student and teacher review
/// screens so their summary layout reads identically.
class OnboardingSummaryItem extends StatelessWidget {
  const OnboardingSummaryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isMuted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.dimens.xs * 1.5),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(context.dimens.radiusMd),
          ),
          child: Icon(
            icon,
            size: context.dimens.iconMd,
            color: context.colors.primary,
          ),
        ),
        SizedBox(width: context.dimens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.labelMedium?.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: context.dimens.xs / 2),
              Text(
                value,
                style: context.textStyles.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isMuted
                      ? context.colors.textSecondary
                      : context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Icon-led label + wrapped-chip-list row for an onboarding review screen
/// (e.g. "Subjects: Physics, Chemistry"). Shows a muted "None selected"
/// placeholder instead of collapsing away when [items] is empty, so the
/// review screen never silently drops a section.
class OnboardingSummaryChipSection extends StatelessWidget {
  const OnboardingSummaryChipSection({
    super.key,
    required this.icon,
    required this.label,
    required this.items,
  });

  final IconData icon;
  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.dimens.xs * 1.5),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(context.dimens.radiusMd),
          ),
          child: Icon(
            icon,
            size: context.dimens.iconMd,
            color: context.colors.primary,
          ),
        ),
        SizedBox(width: context.dimens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.labelMedium?.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: context.dimens.xs),
              if (items.isEmpty)
                Text(
                  context.l10n.commonNoneSelected,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                Wrap(
                  spacing: context.dimens.xs,
                  runSpacing: context.dimens.xs,
                  children: items.map((item) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimens.sm,
                        vertical: context.dimens.xs / 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          context.dimens.radiusSm,
                        ),
                        border: Border.all(
                          color: context.colors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        item,
                        style: context.textStyles.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Lays out [children] (a mix of [OnboardingSummaryItem]/
/// [OnboardingSummaryChipSection]) with the divider rhythm both onboarding
/// review screens share, so call sites don't repeat that boilerplate.
class OnboardingSummaryList extends StatelessWidget {
  const OnboardingSummaryList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        spaced.add(SizedBox(height: context.dimens.md));
        spaced.add(
          Divider(
            color: context.colors.divider.withValues(alpha: 0.6),
            height: 1,
          ),
        );
        spaced.add(SizedBox(height: context.dimens.md));
      }
      spaced.add(children[i]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: spaced);
  }
}
