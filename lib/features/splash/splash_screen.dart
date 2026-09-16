import 'package:flutter/material.dart';
import '../../core/widgets/lendenn_logo.dart';
import '../../l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF031A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LendennLogo(width: 320, showTagline: true),
            const SizedBox(height: 24),
            Text(
              l10n.splashSubtitle,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 14),
            ),
            const SizedBox(height: 22),
            const CircularProgressIndicator(color: Color(0xFF39E7A4)),
          ],
        ),
      ),
    );
  }
}
