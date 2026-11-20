import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../viewmodel/student_home_viewmodel.dart';

/// The one "add this subject's bundle to the cart" flow — shared by the
/// Chapters screen's Buy Now and [LockedContentSheet]. Callers then open the
/// cart tab.
Future<void> addSubjectBundleToCart(
  WidgetRef ref, {
  required String subjectId,
  String? fallbackName,
}) async {
  var subject =
      ref.read(subjectByIdProvider(subjectId)).value ??
      await ref.read(subjectByIdProvider(subjectId).future);
  if (subject == null && fallbackName != null) {
    // bundlePrice: 0 is a placeholder only — the server looks up the real
    // Subject.bundlePrice from subjectId, this fallback object's price
    // never reaches it (see AddCartItemRequestDto, which has no price field).
    subject = Subject(
      id: subjectId,
      boardClassId: '',
      name: fallbackName,
      bundlePrice: 0,
    );
  }
  final tests =
      ref.read(testsForSubjectProvider(subjectId)).value ??
      await ref.read(testsForSubjectProvider(subjectId).future);
  if (subject != null && tests != null && tests.isNotEmpty) {
    await ref
        .read(studentCartViewModelProvider.notifier)
        .addSubjectBundle(subject, tests);
  }
}

/// Explains why content (ebook, lecture) is locked and offers the single
/// way to unlock it: add the subject to the cart.
class LockedContentSheet extends ConsumerWidget {
  const LockedContentSheet({
    super.key,
    required this.subjectId,
    this.subjectName,
  });

  final String subjectId;
  final String? subjectName;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subjectId,
    String? subjectName,
  }) {
    return AppBottomSheet.show<void>(
      context: context,
      title: title,
      child: LockedContentSheet(subjectId: subjectId, subjectName: subjectName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMutating = ref.watch(cartMutationInProgressProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.lock_rounded,
          size: context.dimens.iconLg * 1.5,
          color: context.colors.secondary,
        ),
        SizedBox(height: context.dimens.md),
        Text(
          context.l10n.stuLockedBody,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimens.lg),
        AppButton(
          label: context.l10n.subjectCardAddToCartGeneric,
          icon: Icons.add_shopping_cart_rounded,
          loading: isMutating,
          onPressed: () async {
            // Resolved up front: this sheet's context is gone once it pops.
            final navigator = Navigator.of(context);
            final router = GoRouter.of(context);
            await addSubjectBundleToCart(
              ref,
              subjectId: subjectId,
              fallbackName: subjectName,
            );
            if (!navigator.mounted) return;
            navigator.pop();
            router.go(AppRoutes.studentCart);
          },
        ),
      ],
    );
  }
}
