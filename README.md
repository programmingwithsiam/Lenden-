# LENDENN

LENDENN is a professional, offline-first digital ledger for shopkeepers and small businesses. Track customer dues, payments, balances, statements, and reports in Bangla or English.

## Features

- Google Sign-In with Firebase Authentication
- Per-user Firebase Realtime Database isolation
- Offline-first local storage with automatic synchronization
- Customer management with search and sorting
- Due and payment transaction tracking
- Automatic balance recalculation from transaction history
- PDF statements and native sharing through WhatsApp, SMS, email, and other apps
- Reports with date filters and cumulative due/payment trends
- Bangla and English UI with persisted language selection
- Dark mode, reminders, empty states, and responsive layouts
- LENDENN branding across Android and Web/PWA assets

## Requirements

- Flutter SDK 3.22 or newer
- Android Studio with an Android SDK or a physical Android device
- A Firebase project with Google Sign-In and Realtime Database enabled

## Setup

```bash
flutter pub get
flutter gen-l10n
flutter run
```

For a new Firebase project, configure the platforms with FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

Publish the rules from `firebase_database_rules.json` to Firebase Realtime Database. The rules isolate each user's data under their authenticated UID.

## Release builds

```bash
flutter analyze
flutter build apk --release
flutter build appbundle --release
flutter build web --release
```

The APK is generated at `build/app/outputs/flutter-apk/app-release.apk` and the App Bundle at `build/app/outputs/bundle/release/app-release.aab` when the Android Gradle build completes.

Before publishing to Google Play, configure a real release keystore in `android/key.properties` and replace the debug signing configuration in `android/app/build.gradle.kts`.

## Architecture

- `lib/app.dart`: MaterialApp, theme, localization, and root routing
- `lib/providers/`: application, theme, and locale state
- `lib/repositories/`: authentication, customer, and transaction data access
- `lib/core/services/`: local storage, synchronization, notifications, and sharing
- `lib/features/`: authentication, dashboard, customers, ledger, transactions, reports, and settings
- `lib/l10n/`: English and Bangla ARB sources plus generated localizations

Financial amounts are stored as integer poysha. Customer balances are recalculated from non-deleted transactions to avoid floating-point rounding and balance drift.

## Branding

**Product:** LENDENN  
**Built by:** CodeWithSiam  
**Website:** https://codewithsiam.vercel.app/
