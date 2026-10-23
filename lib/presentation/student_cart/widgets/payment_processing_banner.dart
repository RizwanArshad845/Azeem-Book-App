import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../viewmodel/student_cart_viewmodel.dart';

/// Shown wherever a subject would otherwise be buyable (cart, chapter list)
/// while a payment for it is still awaiting the gateway's outcome: tells the
/// student it will unlock on its own and they don't need to pay again, with
/// a "Check status" action. Renders nothing when no payment is pending.
class PaymentProcessingBanner extends ConsumerWidget {
  const PaymentProcessingBanner({super.key, this.subjectId});

  /// Only show for this subject; `null` = show if any payment is pending.
  final String? subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingSubjectIdsProvider).value ?? const {};
    final isPending =
        subjectId == null ? pending.isNotEmpty : pending.contains(subjectId);
    if (!isPending) return const SizedBox.shrink();

    final isChecking = ref.watch(
      paymentConfirmationProvider.select(
        (s) => s == PaymentConfirmation.confirming,
      ),
    );

    return AppCard(
      child: Row(
        children: [
          Icon(Icons.hourglass_top_outlined, color: context.colors.warning),
          SizedBox(width: context.dimens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.paymentProcessingTitle,
                  style: context.textStyles.titleSmall,
                ),
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  context.l10n.paymentProcessingMessage,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.dimens.sm),
          if (isChecking)
            SizedBox(
              width: context.dimens.iconSm,
              height: context.dimens.iconSm,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.warning,
              ),
            )
          else
            TextButton(
              onPressed: () => ref
                  .read(paymentConfirmationProvider.notifier)
                  .resumeIfPending(),
              child: Text(context.l10n.checkoutCheckStatus),
            ),
        ],
      ),
    );
  }
}
