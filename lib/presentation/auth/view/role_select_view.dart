import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/role_option_card.dart';

class RoleSelectView extends ConsumerWidget {
  const RoleSelectView({super.key});

  void _select(BuildContext context, WidgetRef ref, UserRole role) {
    ref.read(authViewModelProvider.notifier).selectRole(role);
    context.push(AppRoutes.authPhone);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isUrdu = currentLocale?.languageCode == 'ur';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: context.dimens.md),
              child: InkWell(
                borderRadius: BorderRadius.circular(context.dimens.pillRadius),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(
                        isUrdu ? const Locale('en') : const Locale('ur'),
                      );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.sm,
                    vertical: context.dimens.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius:
                        BorderRadius.circular(context.dimens.pillRadius),
                    border: Border.all(color: context.colors.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: context.dimens.iconSm,
                        color: context.colors.primary,
                      ),
                      SizedBox(width: context.dimens.xs / 2),
                      Text(
                        context.l10n.langToggleLabel,
                        style: context.textStyles.labelSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.dimens.contentMaxWidth,
            ),
            child: Padding(
              padding: EdgeInsets.all(context.dimens.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.roleSelectionTitle,
                    style: context.textStyles.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.dimens.sm),
                  Text(
                    context.l10n.roleSelectionSubtitle,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.dimens.xl),
                  RoleOptionCard(
                    icon: Icons.school_outlined,
                    title: context.l10n.roleTeacher,
                    subtitle: context.l10n.roleTeacherDesc,
                    onTap: () => _select(context, ref, UserRole.teacher),
                  ),
                  SizedBox(height: context.dimens.md),
                  RoleOptionCard(
                    icon: Icons.menu_book_outlined,
                    title: context.l10n.roleStudent,
                    subtitle: context.l10n.roleStudentDesc,
                    onTap: () => _select(context, ref, UserRole.student),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
