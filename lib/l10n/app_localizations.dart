import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'LENDENN'**
  String get appName;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboard;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @totalDue.
  ///
  /// In en, this message translates to:
  /// **'Total Due'**
  String get totalDue;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get totalCustomers;

  /// No description provided for @todayCollection.
  ///
  /// In en, this message translates to:
  /// **'Today’s Collection'**
  String get todayCollection;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @latestActivity.
  ///
  /// In en, this message translates to:
  /// **'Latest account activity'**
  String get latestActivity;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quickActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast access to essential tasks'**
  String get quickActionsSubtitle;

  /// No description provided for @createCustomer.
  ///
  /// In en, this message translates to:
  /// **'Create customer'**
  String get createCustomer;

  /// No description provided for @trackDues.
  ///
  /// In en, this message translates to:
  /// **'Track dues'**
  String get trackDues;

  /// No description provided for @logPayment.
  ///
  /// In en, this message translates to:
  /// **'Log payment'**
  String get logPayment;

  /// No description provided for @findCustomer.
  ///
  /// In en, this message translates to:
  /// **'Find customer'**
  String get findCustomer;

  /// No description provided for @searchQuickly.
  ///
  /// In en, this message translates to:
  /// **'Search quickly'**
  String get searchQuickly;

  /// No description provided for @unknownCustomer.
  ///
  /// In en, this message translates to:
  /// **'Unknown customer'**
  String get unknownCustomer;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @searchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search customer'**
  String get searchCustomer;

  /// No description provided for @searchCustomerByNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone number'**
  String get searchCustomerByNameOrPhone;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get newCustomer;

  /// No description provided for @customerList.
  ///
  /// In en, this message translates to:
  /// **'Customer list'**
  String get customerList;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get nameAZ;

  /// No description provided for @highestDue.
  ///
  /// In en, this message translates to:
  /// **'Highest due'**
  String get highestDue;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomersYet;

  /// No description provided for @customerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name *'**
  String get customerNameRequired;

  /// No description provided for @customerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Rahim Store'**
  String get customerNameHint;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @addressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get addressOptional;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount (৳) *'**
  String get amountRequired;

  /// No description provided for @productOptional.
  ///
  /// In en, this message translates to:
  /// **'Product / item (optional)'**
  String get productOptional;

  /// No description provided for @quantityOptional.
  ///
  /// In en, this message translates to:
  /// **'Quantity (optional)'**
  String get quantityOptional;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @saveDue.
  ///
  /// In en, this message translates to:
  /// **'Save due'**
  String get saveDue;

  /// No description provided for @savePayment.
  ///
  /// In en, this message translates to:
  /// **'Save payment'**
  String get savePayment;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// No description provided for @advanceBalance.
  ///
  /// In en, this message translates to:
  /// **'Advance balance'**
  String get advanceBalance;

  /// No description provided for @currentDue.
  ///
  /// In en, this message translates to:
  /// **'Current due'**
  String get currentDue;

  /// No description provided for @searchProductOrDescription.
  ///
  /// In en, this message translates to:
  /// **'Search product or description'**
  String get searchProductOrDescription;

  /// No description provided for @onlyDue.
  ///
  /// In en, this message translates to:
  /// **'Due only'**
  String get onlyDue;

  /// No description provided for @onlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment only'**
  String get onlyPayment;

  /// No description provided for @noCustomerTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this customer'**
  String get noCustomerTransactions;

  /// No description provided for @shareReceipt.
  ///
  /// In en, this message translates to:
  /// **'Share receipt'**
  String get shareReceipt;

  /// No description provided for @shareViaSms.
  ///
  /// In en, this message translates to:
  /// **'Share via SMS'**
  String get shareViaSms;

  /// No description provided for @shareViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get shareViaWhatsApp;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionMessage.
  ///
  /// In en, this message translates to:
  /// **'This transaction will be deleted and the customer\'s balance will be recalculated.'**
  String get deleteTransactionMessage;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'Sync pending'**
  String get syncPending;

  /// No description provided for @deleteCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete customer?'**
  String get deleteCustomerTitle;

  /// No description provided for @deleteCustomerMessage.
  ///
  /// In en, this message translates to:
  /// **'All information and transactions for {name} will be deleted. This cannot be undone.'**
  String deleteCustomerMessage(Object name);

  /// No description provided for @deleteCustomerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCustomerConfirm;

  /// No description provided for @clearBalance.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearBalance;

  /// No description provided for @advance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get advance;

  /// No description provided for @addDue.
  ///
  /// In en, this message translates to:
  /// **'Add Due'**
  String get addDue;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get addPayment;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bangla;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyValue.
  ///
  /// In en, this message translates to:
  /// **'৳ Bangladeshi Taka'**
  String get currencyValue;

  /// No description provided for @dataAndSync.
  ///
  /// In en, this message translates to:
  /// **'Data & Sync'**
  String get dataAndSync;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get syncStatus;

  /// No description provided for @syncDescription.
  ///
  /// In en, this message translates to:
  /// **'Your data is automatically saved to the cloud'**
  String get syncDescription;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored only in your account'**
  String get privacyDescription;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your data is safely stored in the cloud. You can restore it by logging in again.'**
  String get logoutConfirmMessage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'Your ledger at a glance'**
  String get businessOverview;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalance;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @owed.
  ///
  /// In en, this message translates to:
  /// **'Owed'**
  String get owed;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @filterAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get filterAllTransactions;

  /// No description provided for @noTransactionsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period'**
  String get noTransactionsInPeriod;

  /// No description provided for @accountSummary.
  ///
  /// In en, this message translates to:
  /// **'Account summary'**
  String get accountSummary;

  /// No description provided for @builtBy.
  ///
  /// In en, this message translates to:
  /// **'Built by CodeWithSiam'**
  String get builtBy;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track customer dues and payments with clarity.'**
  String get loginSubtitle;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginGoogle;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get waiting;

  /// No description provided for @loginInfo.
  ///
  /// In en, this message translates to:
  /// **'Your information stays secure in the cloud.'**
  String get loginInfo;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your digital ledger, beautifully organized'**
  String get splashSubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your digital ledger'**
  String get welcomeTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep customer names, dues, and payments at your fingertips. Work offline and sync automatically when you are online.'**
  String get welcomeDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'LENDENN is designed for modern credit tracking and reliable cash flow management.'**
  String get aboutDescription;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get versionLabel;

  /// No description provided for @creatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creatorLabel;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @reportCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reportCustom;

  /// No description provided for @dueInPeriod.
  ///
  /// In en, this message translates to:
  /// **'Total due (period)'**
  String get dueInPeriod;

  /// No description provided for @paymentInPeriod.
  ///
  /// In en, this message translates to:
  /// **'Total payment (period)'**
  String get paymentInPeriod;

  /// No description provided for @totalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total outstanding'**
  String get totalOutstanding;

  /// No description provided for @dueVsPayment.
  ///
  /// In en, this message translates to:
  /// **'Due vs payment'**
  String get dueVsPayment;

  /// No description provided for @topDueCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers with highest due'**
  String get topDueCustomers;

  /// No description provided for @noReportData.
  ///
  /// In en, this message translates to:
  /// **'No report data available'**
  String get noReportData;

  /// No description provided for @brandFooter.
  ///
  /// In en, this message translates to:
  /// **'Built by CodeWithSiam'**
  String get brandFooter;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
