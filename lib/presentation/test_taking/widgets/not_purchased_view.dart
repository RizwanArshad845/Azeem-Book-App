import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/empty_state_view.dart';

/// Purchase-gate blocked state (§ business rule: a student may attempt a
/// test only if it's a free sample or already purchased). Distinct from a
/// generic error, with a single primary way back — not a dead end.
class NotPurchasedView extends StatelessWidget {
  const NotPurchasedView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.lock_outline,
      message: context.l10n.testNotPurchasedMessage,
      actionLabel: context.l10n.commonBack,
      onAction: () => context.pop(),
    );
  }
}
