/// App-wide constants used across the project.
class AppConstants {
  AppConstants._();

  static const String appName = 'LENDENN';
  static const String appNameEn = 'LENDENN';
  static const String creatorName = 'CodeWithSiam';
  static const String creatorWebsite = 'https://codewithsiam.vercel.app/';

  // Hive box names (local offline cache)
  static const String customerBox = 'customers_box';
  static const String transactionBox = 'transactions_box';
  static const String pendingSyncBox = 'pending_sync_box';
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';

  // Shared preferences keys
  static const String prefIsDarkMode = 'is_dark_mode';
  static const String prefLanguage = 'language';
  static const String prefLastSyncTime = 'last_sync_time';

  // Transaction types
  static const String typeDue = 'due'; // পাওনা
  static const String typePayment = 'payment'; // জমা

  // Payment methods
  static const List<String> paymentMethods = ['Cash', 'Bank', 'Mobile Banking', 'Other'];

  // Sync status
  static const String syncStatusSynced = 'synced';
  static const String syncStatusSyncing = 'syncing';
  static const String syncStatusPending = 'pending';

  // Firebase Realtime Database paths (relative to users/{uid}/...)
  static const String dbProfile = 'profile';
  static const String dbCustomers = 'customers';
  static const String dbTransactions = 'transactions';
  static const String dbSettings = 'settings';
}
