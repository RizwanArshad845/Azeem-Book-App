import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/catalog/entities/test.dart';

class LiveTestBanner extends StatelessWidget {
  const LiveTestBanner({super.key, required this.liveTestsAsync});

  final AsyncValue<List<Test>> liveTestsAsync;

  @override
  Widget build(BuildContext context) {
    final liveTests = liveTestsAsync.value;
    if (liveTests == null || liveTests.isEmpty) return const SizedBox.shrink();

    final next = liveTests.first;
    return AppCard(
      onTap: () => context.push(AppRoutes.studentLiveTests),
      child: Row(
        children: [
          Icon(Icons.podcasts, color: context.colors.warning),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  liveTests.length == 1
                      ? context.l10n.liveTestScheduledSingle
                      : context.l10n.liveTestScheduledMultiple(liveTests.length),
                  style: context.textStyles.titleSmall,
                ),
                SizedBox(height: context.dimens.xs / 2),
                Text(
                  next.title,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.textSecondary),
        ],
      ),
    );
  }
}
