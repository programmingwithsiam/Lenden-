import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/customers/welcome_screen.dart';
import 'features/main_shell.dart';
import 'features/splash/splash_screen.dart';
import 'providers/app_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

class AmarKhataApp extends StatelessWidget {
  const AmarKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    return MaterialApp(
      title: AppConstants.appName,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('bn'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      AppLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const _RootRouter(),
    );
  }
}

class _RootRouter extends StatefulWidget {
  const _RootRouter();

  @override
  State<_RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<_RootRouter> {
  bool _showWelcome = false;
  bool _welcomeDecided = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    switch (app.authStatus) {
      case AuthStatus.unknown:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
        _welcomeDecided = false;
        return const LoginScreen();
      case AuthStatus.authenticated:
        if (!_welcomeDecided) {
          _showWelcome = app.isNewUser;
          _welcomeDecided = true;
        }
        if (_showWelcome) {
          return WelcomeScreen(onContinue: () => setState(() => _showWelcome = false));
        }
        return const MainShell();
    }
  }
}
