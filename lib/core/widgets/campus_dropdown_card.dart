import 'package:flutter/material.dart';

import '../../domain/campus_directory/entities/campus.dart';
import '../extensions/context_extensions.dart';
import 'app_dropdown_card.dart';

/// Shared Campus picker for onboarding (teacher + student): bold name + city
/// (with a location pin) on two lines, and a check mark on the selected
/// item in the popup list. Previously student onboarding had this richer
/// treatment and teacher onboarding fell back to `AppDropdownCard`'s plain
/// text — extracted here so both flows present the same field identically.
class CampusDropdownCard extends StatelessWidget {
  const CampusDropdownCard({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.isRequired = true,
  });

  final List<Campus> items;
  final Campus? selectedItem;
  final ValueChanged<Campus?> onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppDropdownCard<Campus>(
      label: context.l10n.campusLabel,
      icon: Icons.location_city_rounded,
      isRequired: isRequired,
      items: items,
      selectedItem: selectedItem,
      itemAsString: (c) => '${c.name} (${c.city})',
      valueBuilder: (context, campus) {
        if (campus == null) {
          return Text(
            context.l10n.campusLabel,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary.withValues(alpha: 0.7),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              campus.name,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 3),
                Text(
                  campus.city,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      itemBuilder: (context, campus, isDisabled, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimens.md,
            vertical: context.dimens.sm + 4,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: context.colors.divider.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary.withValues(alpha: 0.15)
                      : context.colors.divider.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school_outlined,
                  size: 18,
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.textSecondary,
                ),
              ),
              SizedBox(width: context.dimens.sm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      campus.name,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: isSelected
                            ? context.colors.primary
                            : (isDisabled
                                ? context.colors.textSecondary
                                    .withValues(alpha: 0.5)
                                : context.colors.textPrimary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: context.colors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          campus.city,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                SizedBox(width: context.dimens.sm),
                Icon(
                  Icons.check_circle_rounded,
                  size: context.dimens.iconSm + 4,
                  color: context.colors.primary,
                ),
              ],
            ],
          ),
        );
      },
      onChanged: onChanged,
    );
  }
}
