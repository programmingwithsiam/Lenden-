// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'LENDENN';

  @override
  String get dashboard => 'হোম';

  @override
  String get customers => 'কাস্টমার';

  @override
  String get transactions => 'লেনদেন';

  @override
  String get reports => 'রিপোর্ট';

  @override
  String get settings => 'সেটিংস';

  @override
  String get due => 'পাওনা';

  @override
  String get payment => 'জমা';

  @override
  String get totalDue => 'মোট পাওনা';

  @override
  String get totalPayment => 'মোট জমা';

  @override
  String get totalCustomers => 'কাস্টমার';

  @override
  String get todayCollection => 'আজকের সংগ্রহ';

  @override
  String get recentTransactions => 'সাম্প্রতিক লেনদেন';

  @override
  String get latestActivity => 'সাম্প্রতিক হিসাবের কার্যক্রম';

  @override
  String get hide => 'লুকান';

  @override
  String get show => 'দেখুন';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get quickActionsSubtitle => 'প্রয়োজনীয় কাজগুলো দ্রুত করুন';

  @override
  String get createCustomer => 'কাস্টমার তৈরি করুন';

  @override
  String get trackDues => 'পাওনা ট্র্যাক করুন';

  @override
  String get logPayment => 'জমা লিখুন';

  @override
  String get findCustomer => 'কাস্টমার খুঁজুন';

  @override
  String get searchQuickly => 'দ্রুত খুঁজুন';

  @override
  String get unknownCustomer => 'অজানা কাস্টমার';

  @override
  String get seeAll => 'সব দেখুন';

  @override
  String get noTransactions => 'এখনও কোনো লেনদেন নেই';

  @override
  String get searchCustomer => 'কাস্টমার খুঁজুন';

  @override
  String get searchCustomerByNameOrPhone => 'নাম বা ফোন নম্বর দিয়ে খুঁজুন';

  @override
  String get newCustomer => 'নতুন কাস্টমার';

  @override
  String get customerList => 'কাস্টমার তালিকা';

  @override
  String get recent => 'সাম্প্রতিক';

  @override
  String get nameAZ => 'নাম (A-Z)';

  @override
  String get highestDue => 'সর্বোচ্চ পাওনা';

  @override
  String get noCustomersFound => 'কোনো কাস্টমার পাওয়া যায়নি';

  @override
  String get noCustomersYet => 'এখনও কোনো কাস্টমার নেই';

  @override
  String get customerNameRequired => 'কাস্টমারের নাম *';

  @override
  String get customerNameHint => 'যেমন: রহিম স্টোর';

  @override
  String get phoneOptional => 'ফোন নম্বর (ঐচ্ছিক)';

  @override
  String get addressOptional => 'ঠিকানা (ঐচ্ছিক)';

  @override
  String get noteOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get amountRequired => 'পরিমাণ (৳) *';

  @override
  String get productOptional => 'পণ্য / আইটেম (ঐচ্ছিক)';

  @override
  String get quantityOptional => 'পরিমাণ/কোয়ান্টিটি (ঐচ্ছিক)';

  @override
  String get paymentMethod => 'পেমেন্ট মাধ্যম';

  @override
  String get descriptionOptional => 'বিবরণ (ঐচ্ছিক)';

  @override
  String get saveDue => 'পাওনা সংরক্ষণ করুন';

  @override
  String get savePayment => 'জমা সংরক্ষণ করুন';

  @override
  String get customerNotFound => 'কাস্টমার পাওয়া যায়নি';

  @override
  String get advanceBalance => 'অগ্রিম জমা আছে';

  @override
  String get currentDue => 'বর্তমান বাকি';

  @override
  String get searchProductOrDescription => 'পণ্য বা বিবরণ খুঁজুন';

  @override
  String get onlyDue => 'শুধু পাওনা';

  @override
  String get onlyPayment => 'শুধু জমা';

  @override
  String get noCustomerTransactions => 'এই কাস্টমারের কোনো লেনদেন নেই';

  @override
  String get shareReceipt => 'রশিদ শেয়ার করুন';

  @override
  String get shareViaSms => 'SMS-এ শেয়ার করুন';

  @override
  String get shareViaWhatsApp => 'WhatsApp-এ শেয়ার করুন';

  @override
  String get downloadPdf => 'PDF ডাউনলোড করুন';

  @override
  String get editTransaction => 'সম্পাদনা করুন';

  @override
  String get deleteTransaction => 'মুছে ফেলুন';

  @override
  String get deleteTransactionTitle => 'লেনদেন মুছে ফেলুন?';

  @override
  String get deleteTransactionMessage =>
      'এই লেনদেনটি মুছে ফেলা হলে কাস্টমারের বাকি পুনরায় হিসাব হবে।';

  @override
  String get syncPending => 'সিঙ্ক বাকি';

  @override
  String get deleteCustomerTitle => 'কাস্টমার মুছে ফেলুন?';

  @override
  String deleteCustomerMessage(Object name) {
    return '$name-এর সব তথ্য ও লেনদেন মুছে যাবে। এই কাজটি ফিরিয়ে আনা যাবে না।';
  }

  @override
  String get deleteCustomerConfirm => 'মুছে ফেলুন';

  @override
  String get clearBalance => 'ক্লিয়ার';

  @override
  String get advance => 'অগ্রিম';

  @override
  String get addDue => 'পাওনা যোগ করুন';

  @override
  String get addPayment => 'জমা রেকর্ড করুন';

  @override
  String get language => 'ভাষা';

  @override
  String get bangla => 'বাংলা';

  @override
  String get english => 'English';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get logout => 'লগআউট';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get delete => 'ডিলিট';

  @override
  String get edit => 'এডিট';

  @override
  String get date => 'তারিখ';

  @override
  String get time => 'সময়';

  @override
  String get general => 'সাধারণ';

  @override
  String get currency => 'মুদ্রা';

  @override
  String get currencyValue => '৳ বাংলাদেশি টাকা';

  @override
  String get dataAndSync => 'ডেটা ও সিঙ্ক';

  @override
  String get syncStatus => 'সিঙ্ক স্ট্যাটাস';

  @override
  String get syncDescription =>
      'আপনার সব তথ্য স্বয়ংক্রিয়ভাবে ক্লাউডে সংরক্ষিত হয়';

  @override
  String get other => 'অন্যান্য';

  @override
  String get privacy => 'প্রাইভেসি';

  @override
  String get privacyDescription =>
      'আপনার ডেটা শুধুমাত্র আপনার অ্যাকাউন্টে সংরক্ষিত থাকে';

  @override
  String get aboutApp => 'অ্যাপ সম্পর্কে';

  @override
  String get user => 'ব্যবহারকারী';

  @override
  String get logoutConfirmTitle => 'লগআউট করবেন?';

  @override
  String get logoutConfirmMessage =>
      'আপনার সব তথ্য নিরাপদে ক্লাউডে সংরক্ষিত আছে। আবার লগইন করলে সব ফিরে পাবেন।';

  @override
  String get welcomeBack => 'স্বাগতম';

  @override
  String get businessOverview => 'আপনার ব্যবসার হিসাব এক নজরে';

  @override
  String get currentBalance => 'বর্তমান ব্যালেন্স';

  @override
  String get received => 'পাওনা';

  @override
  String get owed => 'অগ্রিম';

  @override
  String get today => 'আজ';

  @override
  String get thisWeek => 'এই সপ্তাহ';

  @override
  String get thisMonth => 'এই মাস';

  @override
  String get all => 'সব';

  @override
  String get filterAllTransactions => 'সব লেনদেন';

  @override
  String get noTransactionsInPeriod => 'এই সময়ে কোনো লেনদেন নেই';

  @override
  String get accountSummary => 'একাউন্ট সারাংশ';

  @override
  String get builtBy => 'CodeWithSiam দ্বারা নির্মিত';

  @override
  String get website => 'ওয়েবসাইট';

  @override
  String get appVersion => 'অ্যাপ সংস্করণ';

  @override
  String get creator => 'ক্রিয়েটর';

  @override
  String get loginSubtitle => 'কাস্টমারের বাকি ও জমার হিসাব সহজে দেখুন।';

  @override
  String get loginGoogle => 'Google দিয়ে লগইন করুন';

  @override
  String get waiting => 'অপেক্ষা করুন...';

  @override
  String get loginInfo =>
      'লগইন করলে আপনার তথ্য নিরাপদে ক্লাউডে সংরক্ষিত থাকবে।';

  @override
  String get splashSubtitle => 'আপনার ডিজিটাল হিসাবের খাতা সাজানোভাবে';

  @override
  String get welcomeTitle => 'আপনার ডিজিটাল খাতা শুরু করুন';

  @override
  String get welcomeDescription =>
      'কাস্টমারের নাম, বাকি ও জমার হিসাব হাতের মুঠোয় রাখুন। অফলাইনে কাজ করুন, অনলাইনে এলে স্বয়ংক্রিয়ভাবে সিঙ্ক হবে।';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get aboutDescription =>
      'LENDENN আধুনিক পাওনা ও নগদ প্রবাহ ব্যবস্থাপনার জন্য ডিজাইন করা হয়েছে।';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get versionLabel => 'অ্যাপ সংস্করণ';

  @override
  String get creatorLabel => 'ক্রিয়েটর';

  @override
  String get websiteLabel => 'ওয়েবসাইট';

  @override
  String get reportCustom => 'কাস্টম';

  @override
  String get dueInPeriod => 'মোট পাওনা (এই সময়ে)';

  @override
  String get paymentInPeriod => 'মোট জমা (এই সময়ে)';

  @override
  String get totalOutstanding => 'সর্বমোট বকেয়া';

  @override
  String get dueVsPayment => 'পাওনা বনাম জমা';

  @override
  String get topDueCustomers => 'সর্বোচ্চ পাওনা কাস্টমার';

  @override
  String get noReportData => 'রিপোর্ট দেখানোর মতো তথ্য নেই';

  @override
  String get brandFooter => 'CodeWithSiam দ্বারা নির্মিত';
}
