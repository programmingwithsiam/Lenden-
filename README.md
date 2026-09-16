# আমার খাতা (Amar Khata) — Digital Ledger Android App

সম্পূর্ণ প্রোডাকশন-রেডি Flutter/Android অ্যাপ। এই README অনুসরণ করলে তুমি নিজের Firebase
প্রজেক্ট দিয়ে অ্যাপটা রান করতে এবং APK বানাতে পারবে — সম্পূর্ণ ফ্রি (Firebase Spark/free
plan যথেষ্ট)।

---
## ১. আগে থেকে যা লাগবে (Prerequisites)

- **Flutter SDK** (3.22+) ইনস্টল করা — https://docs.flutter.dev/get-started/install
- **Android Studio** (Android SDK + an emulator, or a real Android phone with USB debugging)
- একটা **Google/Firebase অ্যাকাউন্ট** (ফ্রি)
- Node.js না লাগলেও, Firebase CLI-এর জন্য npm লাগবে:
  ```
  npm install -g firebase-tools
  ```

চেক করো সব ঠিক আছে কিনা:
```
flutter doctor
```

---
## ২. প্রজেক্ট তৈরি (একবারই করতে হবে)

আমি যে ফাইলগুলো দিয়েছি তাতে শুধু **`lib/`** (Dart কোড) এবং কনফিগ ফাইল আছে। Android-এর
নেটিভ ফোল্ডার (`android/`, `ios/` ইত্যাদি) তোমার নিজের Flutter ভার্সনের সাথে মিলিয়ে
স্বয়ংক্রিয়ভাবে তৈরি করাটাই সবচেয়ে নিরাপদ (হাতে বানালে ভার্সন মিসম্যাচে build ভেঙে যেতে পারে)।

1. এই zip ফাইলটা extract করো, ধরো ফোল্ডারের নাম `amar_khata`।
2. টার্মিনাল/CMD খুলে সেই ফোল্ডারে যাও:
   ```
   cd amar_khata
   ```
3. Android/iOS নেটিভ স্ক্যাফোল্ডিং জেনারেট করো (এটা lib/pubspec.yaml-কে স্পর্শ করবে না):
   ```
   flutter create --platforms=android --org com.yourcompany --project-name amar_khata .
   ```
   `com.yourcompany` জায়গায় তোমার পছন্দমতো ডোমেইন-স্টাইল নাম দাও (যেমন `com.rahim.dokan`)।
   এটাই হবে তোমার অ্যাপের **package name** — Firebase-এ এটাই ব্যবহার করবে।
4. প্যাকেজ ইনস্টল করো:
   ```
   flutter pub get
   ```

---
## ৩. Firebase প্রজেক্ট সেটআপ

### ৩.১ প্রজেক্ট তৈরি
1. https://console.firebase.google.com এ যাও → **Add project** → নাম দাও (যেমন `amar-khata`)।
2. Google Analytics লাগবে না, বন্ধ রাখতে পারো।

### ৩.২ Android অ্যাপ যোগ করো
1. প্রজেক্টে ঢুকে **Add app → Android** সিলেক্ট করো।
2. **Android package name** ঘরে ধাপ ২.৩-এ দেওয়া প্যাকেজ নাম বসাও (যেমন `com.rahim.dokan`)।
3. **SHA-1** এবং **SHA-256** লাগবে Google Sign-In কাজ করার জন্য। বের করার কমান্ড:
   ```
   cd android
   ./gradlew signingReport
   ```
   (Windows-এ `gradlew signingReport`)
   আউটপুটে `Variant: debug` অংশে SHA1 আর SHA-256 পাবে — দুটোই Firebase কনসোলে পেস্ট করো।
   পরে যখন রিলিজ APK বানাবে (ধাপ ৭), তখন রিলিজ কী-স্টোরের SHA1/SHA256-ও এখানে যোগ করতে হবে।
4. `google-services.json` ডাউনলোড করে **`android/app/`** ফোল্ডারে রাখো।

### ৩.৩ Authentication চালু করো
1. Firebase কনসোলে **Build → Authentication → Get started**।
2. **Sign-in method** ট্যাবে **Google** চালু করো (Enable করে Save)।

### ৩.৪ Realtime Database চালু করো
1. **Build → Realtime Database → Create Database**।
2. Location হিসেবে কাছের রিজিওন বেছে নাও (যেমন Singapore/asia-southeast1)।
3. প্রথমে "locked mode"-এ শুরু হবে — চিন্তা নেই, পরের ধাপে সঠিক Rules বসাবো।
4. **Rules** ট্যাবে গিয়ে এই প্রজেক্টের `firebase_database_rules.json` ফাইলের পুরো কন্টেন্ট
   কপি করে পেস্ট করো, তারপর **Publish**। এই rules নিশ্চিত করে যে একজন ইউজার শুধু নিজের
   `users/{নিজের-uid}/...` ডেটা পড়তে/লিখতে পারবে — অন্য কারো ডেটা কখনোই না।

---
## ৪. `flutterfire configure` চালাও (সবচেয়ে গুরুত্বপূর্ণ ধাপ)

```
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```
- প্রজেক্ট লিস্ট থেকে তোমার Firebase প্রজেক্ট সিলেক্ট করো।
- Platform-এ শুধু **android** টিক দাও।
- এটা `lib/firebase_options.dart` ফাইলটা **তোমার আসল কনফিগ দিয়ে ওভাররাইট** করে দেবে
  (আমি যেটা দিয়েছি সেটা placeholder ছিল — `YOUR_FIREBASE_CONFIG` লেখা)।

---
## ৫. AndroidManifest.xml ও Gradle প্যাচ

`flutter create` করার পর নিচের পরিবর্তনগুলো করো:

### ৫.১ `android/app/build.gradle.kts` (বা `.gradle`)
- `minSdk` কমপক্ষে **23** রাখো (Firebase Auth-এর জন্য দরকার):
  ```kotlin
  defaultConfig {
      applicationId = "com.yourcompany.amar_khata" // ধাপ ২.৩-এ যা দিয়েছিলে
      minSdk = 23
      targetSdk = 34
      multiDexEnabled = true
  }
  ```
- ফাইলের একদম উপরে (plugins ব্লকে) যোগ করো:
  ```kotlin
  plugins {
      id("com.android.application")
      id("kotlin-android")
      id("dev.flutter.flutter-gradle-plugin")
      id("com.google.gms.google-services") // <-- এই লাইনটা যোগ করো
  }
  ```

### ৫.২ প্রজেক্ট-লেভেল `android/settings.gradle.kts`
`plugins` ব্লকে যোগ করো:
```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

### ৫.৩ `android/app/src/main/AndroidManifest.xml`
`<manifest>` ট্যাগের ভেতরে, `<application>` ট্যাগের আগে এই পারমিশনগুলো যোগ করো:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```
`<application android:label="আমার খাতা" ...>` — লেবেলটা এভাবে বাংলায় বদলে দিতে পারো।

---
## ৬. অ্যাপ আইকন ও স্প্ল্যাশ স্ক্রিন (ঐচ্ছিক কিন্তু প্রফেশনাল লুকের জন্য সুপারিশকৃত)

```
flutter pub add flutter_launcher_icons flutter_native_splash --dev
```
`pubspec.yaml`-এ যোগ করো:
```yaml
flutter_launcher_icons:
  android: true
  image_path: "assets/icons/app_icon.png"

flutter_native_splash:
  color: "#0F9D58"
  image: "assets/icons/splash_logo.png"
```
নিজের লোগো `assets/icons/` ফোল্ডারে রেখে চালাও:
```
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

---
## ৭. রান করো / APK বানাও

### ডিবাগ মোডে টেস্ট (ফোন/এমুলেটরে)
```
flutter run
```

### রিলিজ APK বানাও (শপ-মালিককে দেওয়ার জন্য)
```
flutter build apk --release
```
ফাইল পাবে: `build/app/outputs/flutter-apk/app-release.apk`

> **নোট:** ডিফল্টভাবে এটা `debug` কী দিয়ে সাইন হবে যা Play Store-এ আপলোডের জন্য যথেষ্ট না,
> কিন্তু সরাসরি APK শেয়ার করে ইনস্টল করার জন্য সমস্যা নেই। প্রোডাকশনে দিতে চাইলে নিজের
> keystore বানিয়ে `android/key.properties` সেট করো (Flutter অফিসিয়াল ডকসে "Sign the app" অংশ দেখো),
> এবং সেই কী-স্টোরের SHA-1/SHA-256 আবার Firebase কনসোলে যোগ করতে ভুলো না।

---
## ৮. প্রোজেক্ট আর্কিটেকচার

```
lib/
  main.dart                 # এন্ট্রি পয়েন্ট: Hive + Firebase + Notifications init
  app.dart                  # রুট রাউটার (Splash → Login → Welcome → MainShell)
  firebase_options.dart     # ⚠️ তোমার নিজের Firebase কনফিগ (flutterfire configure দিয়ে বদলাও)

  core/
    constants/               # অ্যাপ-ওয়াইড কনস্ট্যান্ট
    theme/                   # Material 3 লাইট/ডার্ক থিম
    utils/                   # Currency formatter, validators
    services/
      local_db_service.dart   # Hive (অফলাইন ক্যাশ) boxes
      sync_service.dart        # অফলাইন↔অনলাইন সিঙ্ক ইঞ্জিন (মূল লজিক এখানে)
      connectivity_service.dart
      share_service.dart       # রশিদ/স্টেটমেন্ট শেয়ার (PDF + native share sheet)
      notification_service.dart# পেমেন্ট রিমাইন্ডার
    widgets/                 # পুনঃব্যবহারযোগ্য widgets

  models/                   # CustomerModel, TransactionModel, AppUserModel
  repositories/             # AuthRepository, CustomerRepository, TransactionRepository
  providers/                # AppProvider (মূল state), ThemeProvider

  features/
    splash/, auth/, dashboard/, customers/, ledger/,
    transactions/, reports/, settings/, main_shell.dart
```

### ডেটা কীভাবে চলে (Offline-first flow)
1. ইউজার কিছু যোগ/এডিট/ডিলিট করলে → সাথে সাথে **Hive**-এ (ফোনের লোকাল স্টোরেজ) সেভ হয়
   এবং UI তাৎক্ষণিক আপডেট হয় (ইন্টারনেট থাকুক বা না থাকুক)।
2. একই সাথে সেই রেকর্ড একটা "pending sync queue"-তে যোগ হয়।
3. `SyncService` ব্যাকগ্রাউন্ডে Firebase-এর কানেকশন স্ট্যাটাস (`.info/connected`) মনিটর করে;
   কানেকশন পেলেই queue থেকে সব pending রেকর্ড Firebase Realtime Database-এ পাঠিয়ে দেয়।
4. একই সাথে Firebase-এর ডেটাতেও লাইভ লিসেনার থাকে — অন্য ডিভাইস থেকে সিঙ্ক হওয়া ডেটা
   স্বয়ংক্রিয়ভাবে এই ফোনেও চলে আসবে (last-write-wins conflict resolution, `updatedAt` টাইমস্ট্যাম্প দিয়ে)।
5. Dashboard/Settings-এ ছোট ব্যাজ দেখায়: **✓ সিঙ্ক সম্পন্ন / ⟳ সিঙ্ক হচ্ছে / ⚠ সিঙ্ক বাকি**।

### টাকার হিসাব
সব টাকা **পয়সা (integer)** হিসেবে সংরক্ষিত হয় (১ টাকা = ১০০ পয়সা) — floating point এর
কারণে রাউন্ডিং ভুল কখনো হবে না। কাস্টমারের ব্যালেন্স কখনো আলাদা সংখ্যা হিসেবে এডিট হয় না;
প্রতিবার একটা লেনদেন যোগ/এডিট/ডিলিট হলে সেই কাস্টমারের **সব** লেনদেন যোগ করে ব্যালেন্স নতুন করে
হিসাব হয় — তাই ভুল ব্যালেন্স হওয়ার সুযোগ নেই।

---
## ৯. ফিচার চেকলিস্ট (spec অনুযায়ী কী কী আছে)

- [x] Google Sign-In + Firebase Auth, ইউজার-ভিত্তিক ডেটা আইসোলেশন
- [x] Dashboard: মোট কাস্টমার, মোট পাওনা/জমা, আজকের লেনদেন/সংগ্রহ, সাম্প্রতিক লেনদেন, quick actions
- [x] কাস্টমার Add/Edit/Delete/Search/Sort (শুধু নাম আবশ্যক)
- [x] কাস্টমার লেজার: পাওনা/জমা বাটন, সম্পূর্ণ history, filter, search
- [x] Transaction entry: amount, product, quantity, description, date/time (এডিটযোগ্য), note
- [x] Transaction edit/delete হলে ব্যালেন্স স্বয়ংক্রিয় পুনঃহিসাব
- [x] রশিদ/স্টেটমেন্ট শেয়ার — Android native share sheet (WhatsApp/SMS/Email/যেকোনো অ্যাপ)
- [x] PDF কাস্টমার স্টেটমেন্ট
- [x] Reports: আজ/সপ্তাহ/মাস/কাস্টম রেঞ্জ, top due customers, chart
- [x] Local reminders (পেইড সার্ভিস ছাড়াই)
- [x] Settings: প্রোফাইল, ডার্ক মোড, মুদ্রা, সিঙ্ক স্ট্যাটাস, লগআউট
- [x] Offline-first + auto sync + conflict-safe merge
- [x] Firebase Security Rules (per-user isolation)
- [x] Empty states সব জায়গায়
- [x] ইনপুট validation (ফোন নম্বর, amount > 0, required name)

**ভবিষ্যতে সহজে যোগ করা যাবে** (আর্কিটেকচার এভাবেই সাজানো): multiple businesses, staff
accounts, product inventory, barcode scan, invoice system, QR payment, AI insights — এগুলোর
জন্য নতুন `features/<name>/` ফোল্ডার আর দরকার হলে নতুন Firebase নোড যোগ করলেই চলবে।

---
## ১০. টেস্টিং চেকলিস্ট

- [ ] Google দিয়ে লগইন/লগআউট কাজ করছে কিনা
- [ ] নতুন কাস্টমার শুধু নাম দিয়ে সেভ হচ্ছে কিনা
- [ ] পাওনা/জমা যোগ করলে ব্যালেন্স ঠিক হিসাব হচ্ছে কিনা
- [ ] Airplane mode অন করে কাস্টমার/লেনদেন যোগ করে দেখো — কাজ করা উচিত
- [ ] Airplane mode অফ করার পর "⚠ সিঙ্ক বাকি" থেকে "✓ সিঙ্ক সম্পন্ন" হচ্ছে কিনা
- [ ] দুইটা ডিভাইসে একই Google অ্যাকাউন্ট দিয়ে লগইন করে ডেটা সিঙ্ক হচ্ছে কিনা
- [ ] অন্য Google অ্যাকাউন্ট দিয়ে লগইন করলে আগের ইউজারের ডেটা দেখা যাচ্ছে না তো (isolation)
- [ ] Transaction এডিট/ডিলিট করলে ব্যালেন্স রিক্যালকুলেট হচ্ছে কিনা
- [ ] শেয়ার বাটনে WhatsApp/SMS/Email অপশন আসছে কিনা
- [ ] Dark mode টগল ঠিকমতো কাজ করছে কিনা

---
## ১১. সমস্যা সমাধান (Troubleshooting)

| সমস্যা | সমাধান |
|---|---|
| Google Sign-In "ApiException: 10" | SHA-1/SHA-256 Firebase কনসোলে সঠিকভাবে যোগ করা হয়নি — ধাপ ৩.২ আবার চেক করো |
| `firebase_options.dart` এরর | `flutterfire configure` চালাওনি বা placeholder ভ্যালুই রয়ে গেছে |
| Build এ "google-services.json missing" | ফাইলটা ঠিক `android/app/` ফোল্ডারে আছে কিনা চেক করো |
| ডেটা সিঙ্ক হচ্ছে না | Realtime Database Rules সঠিকভাবে Publish হয়েছে কিনা, এবং ইন্টারনেট আছে কিনা চেক করো |
| Notification আসছে না (Android 13+) | অ্যাপ প্রথমবার খোলার সময় Notification permission দিতে হবে |

---
এই প্রজেক্টটা তোমার নিজের Firebase ক্রেডেনশিয়াল দিয়ে সম্পূর্ণ ফ্রি-তে চালানো যাবে
(Firebase Spark/free plan-এ Realtime Database + Authentication দুটোই ফ্রি quota-তে আছে)।
