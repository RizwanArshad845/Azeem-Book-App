import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/hub_action_card.dart';
import '../../../core/widgets/illustration_thumbnail.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';

class SubjectCard extends ConsumerWidget {
  const SubjectCard({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subject.id) ?? false;
    final isPaymentPending = ref.watch(
      pendingSubjectIdsProvider.select(
        (ids) => ids.value?.contains(subject.id) ?? false,
      ),
    );
    final cartState = ref.watch(studentCartViewModelProvider).value;
    final cartItems = cartState?.items;
    final isInCart =
        cartItems != null && cartItems.any((i) => i.subjectId == subject.id);

    return HubActionCard(
      onTap: () => context.push(
        AppRoutes.subjectHubPath(subject.id),
        extra: subject.name,
      ),
      leading: IllustrationThumbnail(
        imageAsset: subjectIllustration(subject.name),
        fallbackIcon: subjectIcon(subject.name),
        size: 48,
      ),
      badge: isOwned
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
                  : null,
      title: context.l10n.localizedSubjectName(subject.name),
      hint: context.l10n.subjectCardExploreHint,
    );
  }
}
