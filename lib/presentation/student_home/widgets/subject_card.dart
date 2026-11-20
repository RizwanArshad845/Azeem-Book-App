import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/hub_action_card.dart';
import '../../../core/widgets/illustrated_list_card.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';

/// Student Home's one subject card: the same illustration, title, hint and
/// Owned / Processing / In-cart badge in both the list and grid layouts, so
/// toggling the view only changes the arrangement, never the card's look.
class SubjectCard extends ConsumerWidget {
  const SubjectCard({super.key, required this.subject, this.grid = true});

  final Subject subject;

  /// Tall grid tile when true; full-width row when false.
  final bool grid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwned = ref.watch(
      purchasedSubjectIdsProvider.select(
        (ids) => ids.value?.contains(subject.id) ?? false,
      ),
    );
    final isPaymentPending = ref.watch(
      pendingSubjectIdsProvider.select(
        (ids) => ids.value?.contains(subject.id) ?? false,
      ),
    );
    final isInCart = ref.watch(
      studentCartViewModelProvider.select(
        (cart) =>
            cart.value?.items?.any((i) => i.subjectId == subject.id) ?? false,
      ),
    );

    final badge = isOwned
        ? StatusBadge(
            label: context.l10n.subjectCardOwnedBadge,
            color: context.colors.success,
          )
        : isPaymentPending
            ? StatusBadge(
                label: context.l10n.paymentProcessingBadge,
                color: context.colors.warning,
              )
            : isInCart
                ? StatusBadge(
                    label: context.l10n.subjectCardInCartBadge,
                    color: context.colors.primary,
                  )
                : null;
    final title = context.l10n.localizedSubjectName(subject.name);
    final hint = context.l10n.subjectCardExploreHint;
    void open() => context.push(
      AppRoutes.subjectHubPath(subject.id),
      extra: subject.name,
    );

    if (!grid) {
      return IllustratedListCard(
        title: title,
        imageAsset: subjectIllustration(subject.name),
        fallbackIcon: subjectIcon(subject.name),
        thumbnailSize: 48,
        badge: badge,
        meta: Text(
          hint,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        onTap: open,
      );
    }

    return HubActionCard(
      onTap: open,
      leading: IllustrationThumbnail(
        imageAsset: subjectIllustration(subject.name),
        fallbackIcon: subjectIcon(subject.name),
        size: 48,
      ),
      badge: badge,
      title: title,
      hint: hint,
    );
  }
}
