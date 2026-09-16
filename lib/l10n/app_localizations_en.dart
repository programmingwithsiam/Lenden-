// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LENDENN';

  @override
  String get dashboard => 'Home';

  @override
  String get customers => 'Customers';

  @override
  String get transactions => 'Transactions';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get due => 'Due';

  @override
  String get payment => 'Payment';

  @override
  String get totalDue => 'Total Due';

  @override
  String get totalPayment => 'Total Payment';

  @override
  String get totalCustomers => 'Customers';

  @override
  String get todayCollection => 'Today’s Collection';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get latestActivity => 'Latest account activity';

  @override
  String get hide => 'Hide';

  @override
  String get show => 'Show';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get quickActionsSubtitle => 'Fast access to essential tasks';

  @override
  String get createCustomer => 'Create customer';

  @override
  String get trackDues => 'Track dues';

  @override
  String get logPayment => 'Log payment';

  @override
  String get findCustomer => 'Find customer';

  @override
  String get searchQuickly => 'Search quickly';

  @override
  String get unknownCustomer => 'Unknown customer';

  @override
  String get seeAll => 'See all';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get searchCustomer => 'Search customer';

  @override
  String get searchCustomerByNameOrPhone => 'Search by name or phone number';

  @override
  String get newCustomer => 'New Customer';

  @override
  String get customerList => 'Customer list';

  @override
  String get recent => 'Recent';

  @override
  String get nameAZ => 'Name (A-Z)';

  @override
  String get highestDue => 'Highest due';

  @override
  String get noCustomersFound => 'No customers found';

  @override
  String get noCustomersYet => 'No customers yet';

  @override
  String get customerNameRequired => 'Customer name *';

  @override
  String get customerNameHint => 'Example: Rahim Store';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get addressOptional => 'Address (optional)';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get amountRequired => 'Amount (৳) *';

  @override
  String get productOptional => 'Product / item (optional)';

  @override
  String get quantityOptional => 'Quantity (optional)';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get saveDue => 'Save due';

  @override
  String get savePayment => 'Save payment';

  @override
  String get customerNotFound => 'Customer not found';

  @override
  String get advanceBalance => 'Advance balance';

  @override
  String get currentDue => 'Current due';

  @override
  String get searchProductOrDescription => 'Search product or description';

  @override
  String get onlyDue => 'Due only';

  @override
  String get onlyPayment => 'Payment only';

  @override
  String get noCustomerTransactions => 'No transactions for this customer';

  @override
  String get shareReceipt => 'Share receipt';

  @override
  String get shareViaSms => 'Share via SMS';

  @override
  String get shareViaWhatsApp => 'Share via WhatsApp';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get deleteTransaction => 'Delete transaction';

  @override
  String get deleteTransactionTitle => 'Delete transaction?';

  @override
  String get deleteTransactionMessage =>
      'This transaction will be deleted and the customer\'s balance will be recalculated.';

  @override
  String get syncPending => 'Sync pending';

  @override
  String get deleteCustomerTitle => 'Delete customer?';

  @override
  String deleteCustomerMessage(Object name) {
    return 'All information and transactions for $name will be deleted. This cannot be undone.';
  }

  @override
  String get deleteCustomerConfirm => 'Delete';

  @override
  String get clearBalance => 'Clear';

  @override
  String get advance => 'Advance';

  @override
  String get addDue => 'Add Due';

  @override
  String get addPayment => 'Record Payment';

  @override
  String get language => 'Language';

  @override
  String get bangla => 'বাংলা';

  @override
  String get english => 'English';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get logout => 'Log out';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get general => 'General';

  @override
  String get currency => 'Currency';

  @override
  String get currencyValue => '৳ Bangladeshi Taka';

  @override
  String get dataAndSync => 'Data & Sync';

  @override
  String get syncStatus => 'Sync status';

  @override
  String get syncDescription => 'Your data is automatically saved to the cloud';

  @override
  String get other => 'Other';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyDescription => 'Your data is stored only in your account';

  @override
  String get aboutApp => 'About App';

  @override
  String get user => 'User';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmMessage =>
      'Your data is safely stored in the cloud. You can restore it by logging in again.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get businessOverview => 'Your ledger at a glance';

  @override
  String get currentBalance => 'Current balance';

  @override
  String get received => 'Received';

  @override
  String get owed => 'Owed';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get all => 'All';

  @override
  String get filterAllTransactions => 'All transactions';

  @override
  String get noTransactionsInPeriod => 'No transactions in this period';

  @override
  String get accountSummary => 'Account summary';

  @override
  String get builtBy => 'Built by CodeWithSiam';

  @override
  String get website => 'Website';

  @override
  String get appVersion => 'App version';

  @override
  String get creator => 'Creator';

  @override
  String get loginSubtitle => 'Track customer dues and payments with clarity.';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get waiting => 'Please wait...';

  @override
  String get loginInfo => 'Your information stays secure in the cloud.';

  @override
  String get splashSubtitle => 'Your digital ledger, beautifully organized';

  @override
  String get welcomeTitle => 'Start your digital ledger';

  @override
  String get welcomeDescription =>
      'Keep customer names, dues, and payments at your fingertips. Work offline and sync automatically when you are online.';

  @override
  String get getStarted => 'Get started';

  @override
  String get aboutDescription =>
      'LENDENN is designed for modern credit tracking and reliable cash flow management.';

  @override
  String get close => 'Close';

  @override
  String get versionLabel => 'App version';

  @override
  String get creatorLabel => 'Creator';

  @override
  String get websiteLabel => 'Website';

  @override
  String get reportCustom => 'Custom';

  @override
  String get dueInPeriod => 'Total due (period)';

  @override
  String get paymentInPeriod => 'Total payment (period)';

  @override
  String get totalOutstanding => 'Total outstanding';

  @override
  String get dueVsPayment => 'Due vs payment';

  @override
  String get topDueCustomers => 'Customers with highest due';

  @override
  String get noReportData => 'No report data available';

  @override
  String get brandFooter => 'Built by CodeWithSiam';
}
