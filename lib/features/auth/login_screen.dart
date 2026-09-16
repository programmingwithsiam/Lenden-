import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/lendenn_logo.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  const LendennLogo(width: 320, showTagline: true),
                  const SizedBox(height: 28),
                  Text(
                    l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                  const Spacer(flex: 2),
                  if (appProvider.authErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        appProvider.authErrorMessage!,
                        style: const TextStyle(color: AppTheme.danger),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: appProvider.isSigningIn
                          ? null
                          : () => appProvider.signInWithGoogle(),
                      icon: appProvider.isSigningIn
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.g_mobiledata, size: 26),
                      label: Text(appProvider.isSigningIn ? l10n.waiting : l10n.loginGoogle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loginInfo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
