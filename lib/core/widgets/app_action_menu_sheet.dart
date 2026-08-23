import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth/entities/user_role.dart';
import '../../presentation/auth/viewmodel/auth_viewmodel.dart';
import '../constants/app_routes.dart';
import '../extensions/context_extensions.dart';
import '../providers/locale_provider.dart';
import 'app_bottom_sheet.dart';
import 'confirm_dialog.dart';

enum _ActionMenuItem { profile, language, logout }

/// AppBar trigger for the unified App Action Menu (CLAUDE.md §4): an
/// anchored dropdown list (Flutter's standard "kebab menu" pattern), not a
/// bottom sheet — Profile navigates straight to the profile screen,
/// Language opens the English/Urdu picker as its own bottom sheet, and
/// Logout asks for confirmation before signing out. One shared widget so
/// every shell screen wires the same button instead of each re-inventing an
/// `IconButton`.
class ActionMenuButton extends ConsumerWidget {
  const ActionMenuButton({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radius = BorderRadius.circular(context.dimens.radiusMd);

    return PopupMenuButton<_ActionMenuItem>(
      icon: const Icon(Icons.more_vert),
      tooltip: context.l10n.profileTitle,
      color: context.colors.surface,
      elevation: context.dimens.xs,
      shape: RoundedRectangleBorder(borderRadius: radius),
      itemBuilder: (context) => [
        _menuItem(
          context,
          value: _ActionMenuItem.profile,
          icon: Icons.person_outline,
          label: context.l10n.profileTitle,
        ),
        _menuItem(
          context,
          value: _ActionMenuItem.language,
          icon: Icons.translate,
          label: context.l10n.profileLanguage,
        ),
        _menuItem(
          context,
          value: _ActionMenuItem.logout,
          icon: Icons.logout,
          label: context.l10n.profileLogout,
          isDestructive: true,
        ),
      ],
      onSelected: (item) => _handleSelection(context, ref, item),
    );
  }

  PopupMenuItem<_ActionMenuItem> _menuItem(
    BuildContext context, {
    required _ActionMenuItem value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive
        ? context.colors.error
        : context.colors.textSecondary;
    final textColor = isDestructive
        ? context.colors.error
        : context.colors.textPrimary;

    return PopupMenuItem<_ActionMenuItem>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: context.dimens.iconMd),
          SizedBox(width: context.dimens.md),
          Text(
            label,
            style: context.textStyles.bodyLarge?.copyWith(
              color: textColor,
              fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSelection(
    BuildContext context,
    WidgetRef ref,
    _ActionMenuItem item,
  ) async {
    switch (item) {
      case _ActionMenuItem.profile:
        context.push(
          role == UserRole.teacher
              ? AppRoutes.teacherProfile
              : AppRoutes.studentProfile,
        );
      case _ActionMenuItem.language:
        await _LanguageSelectSheet.show(context);
      case _ActionMenuItem.logout:
        final confirmed = await confirmDialog(
          context,
          title: context.l10n.profileLogoutConfirmTitle,
          message: context.l10n.profileLogoutConfirmMessage,
          cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
          confirmLabel: context.l10n.profileLogout,
          isDestructive: true,
        );
        if (confirmed == true) {
          // Same path every other logout call site uses (delete-account
          // flows on both profile viewmodels) — the router's
          // `currentUserProvider`-keyed redirect sends the user back to
          // auth on its own once this resolves.
          ref.read(authViewModelProvider.notifier).logout();
        }
    }
  }
}

/// Nested English/Urdu picker opened from the Language row. Minimal
/// locale-switching plumbing already exists (`localeProvider`, persisted via
/// secure storage, already driving `MaterialApp.router(locale:)` and the
/// existing per-profile `TeacherLanguageCard`/`StudentLanguageCard`) — this
/// just gives it a second, unified entry point via the Action Menu.
class _LanguageSelectSheet extends ConsumerWidget {
  const _LanguageSelectSheet();

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show<void>(
      context: context,
      title: context.l10n.profileLanguage,
      child: const _LanguageSelectSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(
      localeProvider.select((l) => l == null || l.languageCode == 'en'),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageOptionRow(
          label: context.l10n.profileEnglish,
          selected: isEnglish,
          onTap: () {
            ref.read(localeProvider.notifier).setLocale(const Locale('en'));
            Navigator.of(context).pop();
          },
        ),
        SizedBox(height: context.dimens.xs),
        _LanguageOptionRow(
          label: context.l10n.profileUrdu,
          selected: !isEnglish,
          onTap: () {
            ref.read(localeProvider.notifier).setLocale(const Locale('ur'));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _LanguageOptionRow extends StatelessWidget {
  const _LanguageOptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.dimens.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.dimens.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimens.sm,
            vertical: context.dimens.md,
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected
                    ? context.colors.primary
                    : context.colors.textSecondary,
                size: context.dimens.iconMd,
              ),
              SizedBox(width: context.dimens.md),
              Text(
                label,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
