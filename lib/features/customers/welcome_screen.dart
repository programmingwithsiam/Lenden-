import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onContinue;
  const WelcomeScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.celebration_outlined, size: 80, color: AppTheme.primary),
              const SizedBox(height: 24),
              Text(
                l10n.welcomeTitle,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.welcomeDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600, height: 1.5),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: Text(l10n.getStarted),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
