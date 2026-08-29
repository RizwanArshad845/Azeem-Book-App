import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../domain/student_onboarding/entities/student.dart';

/// Rich frosted student card displaying active/free status, campus affiliation,
/// commission attribution, and direct "View Progress" action.
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.subjectNames,
    this.campusName,
    required this.onTap,
  });

  final Student student;
  final List<String> subjectNames;
  final String? campusName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPaid =
        (student.subjectEnrollments ?? []).any((e) => e.discountApplied);

    final statusColor =
        isPaid ? const Color(0xFF059669) : const Color(0xFF64748B);
    final statusBg =
        isPaid
            ? const Color(0xFF059669).withValues(alpha: 0.1)
            : const Color(0xFF64748B).withValues(alpha: 0.1);
    final statusLabel =
        isPaid
            ? context.l10n.teacherActivePaid
            : context.l10n.teacherFreeUnpaid;

    return AppFrostedCard(
      onTap: onTap,
      padding: EdgeInsets.all(context.dimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Name + Status Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    isPaid
                        ? context.colors.primary.withValues(alpha: 0.15)
                        : context.colors.divider.withValues(alpha: 0.5),
                child: Text(
                  student.name.isNotEmpty
                      ? student.name[0].toUpperCase()
                      : 'S',
                  style: TextStyle(
                    color:
                        isPaid
                            ? context.colors.primary
                            : context.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: context.dimens.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: context.textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.dimens.xs / 3),
                    Text(
                      student.phoneNumber,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.dimens.xs),
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.sm,
                  vertical: context.dimens.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(
                    context.dimens.radiusLg,
                  ),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: context.dimens.xs / 2),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.dimens.sm),

          // Middle Row: Campus & Subject info
          Wrap(
            spacing: context.dimens.xs,
            runSpacing: context.dimens.xs / 2,
            children: [
              if (campusName != null)
                _InfoChip(
                  icon: Icons.account_balance_outlined,
                  label: campusName!,
                ),
              if (subjectNames.isNotEmpty)
                _InfoChip(
                  icon: Icons.menu_book_outlined,
                  label: subjectNames.join(', '),
                ),
            ],
          ),
          SizedBox(height: context.dimens.sm),
          Divider(
            color: context.colors.divider.withValues(alpha: 0.5),
            height: 1,
          ),
          SizedBox(height: context.dimens.sm),

          // Bottom Row: Commission Attribution + View Progress Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child:
                    isPaid
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: statusColor,
                            ),
                            SizedBox(width: context.dimens.xs / 2),
                            Flexible(
                              child: Text(
                                context.l10n.teacherCommissionEarned,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          context.l10n.teacherBundleNotPurchased,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                            fontStyle: FontStyle.italic,
                            fontSize: 11.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
              ),
              SizedBox(width: context.dimens.xs),

              // "View Progress" Action Button
              InkWell(
                borderRadius: BorderRadius.circular(
                  context.dimens.radiusSm,
                ),
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.xs,
                    vertical: context.dimens.xs / 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.teacherViewProgress,
                        style: context.textStyles.labelSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: context.dimens.xs / 3),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.xs * 1.5,
        vertical: context.dimens.xs / 3,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(context.dimens.radiusSm),
        border: Border.all(color: context.colors.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: context.colors.textSecondary),
          SizedBox(width: context.dimens.xs / 2),
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.colors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
