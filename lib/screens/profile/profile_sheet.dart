import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_selector.dart';

class ProfileSheet extends StatelessWidget {
  const ProfileSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = context.read<LanguageProvider>().strings;
    final ProfileStrings s = loc.profile;
    final User? user = context.read<AuthProvider>().user;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF444444),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _Avatar(user: user),
          const SizedBox(height: 12),
          Text(
            user?.displayName ?? s.guest,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user?.email != null)
            Text(
              user!.email!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 28),
          const Divider(color: Color(0xFF2A2A2A)),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Idioma / Language',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              SizedBox(width: 12),
              LanguageSelectorButton(),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2A2A2A)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppTheme.danger),
            title: Text(
              s.signOut,
              style: const TextStyle(color: AppTheme.danger),
            ),
            onTap: () => _confirmSignOut(context, s),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, ProfileStrings s) {
    final CommonStrings cs = context.read<LanguageProvider>().strings.common;
    unawaited(showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(
          s.signOutConfirm,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          s.signOutBody,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cs.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              await context.read<AuthProvider>().signOut();
            },
            child: Text(s.signOut),
          ),
        ],
      ),
    ),);
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = user?.photoURL;
    final String initial =
        ((user?.displayName?.isNotEmpty ?? false) ? user!.displayName![0] : 'G')
            .toUpperCase();

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.primaryOrange.withValues(alpha: 0.2),
        border: Border.all(color: AppTheme.primaryOrange, width: 2),
        image: photoUrl != null
            ? DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: photoUrl == null
          ? Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
