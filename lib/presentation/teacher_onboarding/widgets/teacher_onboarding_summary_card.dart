import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

/// Spacious summary card displaying the reviewed onboarding inputs before final submission.
class TeacherOnboardingSummaryCard extends StatelessWidget {
  const TeacherOnboardingSummaryCard({
    super.key,
    required this.name,
    required this.cityName,
    required this.campusNames,
    required this.classNames,
    required this.subjectNames,
    this.studentCount,
  });

  final String name;
  final String cityName;
  final List<String> campusNames;
  final List<String> classNames;
  final List<String> subjectNames;
  final int? studentCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _SummaryItem(
          icon: Icons.person_rounded,
          label: context.l10n.teacherSignupSummaryName,
          value: name,
        ),
        SizedBox(height: context.dimens.md),
        Divider(color: context.colors.divider.withValues(alpha: 0.6), height: 1),
        SizedBox(height: context.dimens.md),

        // City
        _SummaryItem(
          icon: Icons.location_city_rounded,
          label: context.l10n.teacherSignupSummaryCity,
          value: cityName,
        ),
        SizedBox(height: context.dimens.md),
        Divider(color: context.colors.divider.withValues(alpha: 0.6), height: 1),
        SizedBox(height: context.dimens.md),

        // Campuses
        _SummaryChipSection(
          icon: Icons.account_balance_rounded,
          label: context.l10n.teacherSignupSummaryCampuses,
          items: campusNames,
        ),
        SizedBox(height: context.dimens.md),
        Divider(color: context.colors.divider.withValues(alpha: 0.6), height: 1),
        SizedBox(height: context.dimens.md),

        // Classes
        _SummaryChipSection(
          icon: Icons.class_rounded,
          label: context.l10n.teacherSignupSummaryClasses,
          items: classNames,
        ),
        SizedBox(height: context.dimens.md),
        Divider(color: context.colors.divider.withValues(alpha: 0.6), height: 1),
        SizedBox(height: context.dimens.md),

        // Subjects
        _SummaryChipSection(
          icon: Icons.menu_book_rounded,
          label: context.l10n.teacherSignupSummarySubjects,
          items: subjectNames,
        ),
        SizedBox(height: context.dimens.md),
        Divider(color: context.colors.divider.withValues(alpha: 0.6), height: 1),
        SizedBox(height: context.dimens.md),

        // Students Count
        _SummaryItem(
          icon: Icons.groups_rounded,
          label: context.l10n.teacherSignupSummaryStudents,
          value: studentCount != null
              ? '$studentCount students'
              : 'Not specified (Optional)',
          isMuted: studentCount == null,
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
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

class _SummaryChipSection extends StatelessWidget {
  const _SummaryChipSection({
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
                  'None selected',
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
                        borderRadius: BorderRadius.circular(context.dimens.radiusSm),
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
