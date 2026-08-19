import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/test.dart';
import '../viewmodel/live_test_registration_viewmodel.dart';

class LiveTestCard extends ConsumerWidget {
  const LiveTestCard({
    super.key,
    required this.test,
    required this.isRegistered,
    required this.isRegistering,
  });

  final Test test;
  final bool isRegistered;
  final bool isRegistering;

  bool get _hasGoneLive =>
      test.liveDate != null && !DateTime.now().isBefore(test.liveDate!);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppListRow(
      title: test.title,
      titleMaxLines: 2,
      subtitle: Text(
        test.liveDate != null
            ? _formatLiveDate(context, test.liveDate!)
            : context.l10n.liveTestDateTba,
        style: context.textStyles.bodySmall?.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
      trailing: _buildAction(context, ref),
    );
  }

  Widget _buildAction(BuildContext context, WidgetRef ref) {
    if (isRegistered && _hasGoneLive) {
      return AppPrimaryButton(
        label: context.l10n.liveTestEnter,
        onPressed: () => context.push(AppRoutes.testTakingPath(test.id)),
      );
    }
    if (isRegistered) {
      return StatusBadge(
        label: context.l10n.liveTestRegistered,
        color: context.colors.success,
      );
    }
    return AppOutlinedButton(
      label: context.l10n.liveTestRegister,
      loading: isRegistering,
      onPressed: () => ref
          .read(liveTestRegistrationViewModelProvider.notifier)
          .register(test.id),
    );
  }

  String _formatLiveDate(BuildContext context, DateTime date) =>
      context.l10n.liveTestDateFormatted('${date.day}/${date.month}/${date.year}');
}
