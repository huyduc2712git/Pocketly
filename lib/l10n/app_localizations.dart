import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Pocketly'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tài chính thông minh'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In vi, this message translates to:
  /// **'Sổ thu chi'**
  String get navTransactions;

  /// No description provided for @navBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách'**
  String get navBudget;

  /// No description provided for @navAnalytics.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get navAnalytics;

  /// No description provided for @navProfile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get navProfile;

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lại'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// No description provided for @commonCopy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get commonCopy;

  /// No description provided for @commonSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get commonSuccess;

  /// No description provided for @commonError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get commonError;

  /// No description provided for @commonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu...'**
  String get commonLoading;

  /// No description provided for @commonEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu'**
  String get commonEmpty;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @dashboardTotalBalance.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số dư khả dụng'**
  String get dashboardTotalBalance;

  /// No description provided for @dashboardIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get dashboardIncome;

  /// No description provided for @dashboardExpense.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu'**
  String get dashboardExpense;

  /// No description provided for @dashboardRemainingBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách còn lại'**
  String get dashboardRemainingBudget;

  /// No description provided for @dashboardBudgetProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ sử dụng'**
  String get dashboardBudgetProgress;

  /// No description provided for @dashboardSmartInsight.
  ///
  /// In vi, this message translates to:
  /// **'Finly Smart Insight'**
  String get dashboardSmartInsight;

  /// No description provided for @dashboardCategoryBudgets.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách danh mục'**
  String get dashboardCategoryBudgets;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch gần đây'**
  String get dashboardRecentTransactions;

  /// No description provided for @transactionAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm giao dịch'**
  String get transactionAdd;

  /// No description provided for @transactionAddExpense.
  ///
  /// In vi, this message translates to:
  /// **'Khoản chi tiêu'**
  String get transactionAddExpense;

  /// No description provided for @transactionAddIncome.
  ///
  /// In vi, this message translates to:
  /// **'Khoản thu nhập'**
  String get transactionAddIncome;

  /// No description provided for @transactionAddTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển tiền'**
  String get transactionAddTransfer;

  /// No description provided for @transactionAmount.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get transactionAmount;

  /// No description provided for @transactionCategory.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get transactionCategory;

  /// No description provided for @transactionWallet.
  ///
  /// In vi, this message translates to:
  /// **'Ví thanh toán'**
  String get transactionWallet;

  /// No description provided for @transactionSourceWallet.
  ///
  /// In vi, this message translates to:
  /// **'Ví nguồn (Chuyển đi)'**
  String get transactionSourceWallet;

  /// No description provided for @transactionDestWallet.
  ///
  /// In vi, this message translates to:
  /// **'Ví đích (Nhận tiền)'**
  String get transactionDestWallet;

  /// No description provided for @transactionNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get transactionNote;

  /// No description provided for @transactionDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao dịch'**
  String get transactionDate;

  /// No description provided for @transactionDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa giao dịch thành công'**
  String get transactionDeleted;

  /// No description provided for @budgetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngân Sách Chi Tiêu'**
  String get budgetTitle;

  /// No description provided for @budgetMonthlyLimit.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mức chi tiêu tháng'**
  String get budgetMonthlyLimit;

  /// No description provided for @budgetSetMonthly.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập ngân sách'**
  String get budgetSetMonthly;

  /// No description provided for @budgetForecastWarning.
  ///
  /// In vi, this message translates to:
  /// **'Dự kiến cuối tháng bạn sẽ vượt ngân sách {amount}'**
  String budgetForecastWarning(String amount);

  /// No description provided for @analyticsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phân Tích & Báo Cáo'**
  String get analyticsTitle;

  /// No description provided for @analyticsSpendingBreakdown.
  ///
  /// In vi, this message translates to:
  /// **'Phân bổ chi tiêu'**
  String get analyticsSpendingBreakdown;

  /// No description provided for @analyticsCashflowTrend.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng dòng tiền'**
  String get analyticsCashflowTrend;

  /// No description provided for @analyticsSavingsRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ tiết kiệm'**
  String get analyticsSavingsRate;

  /// No description provided for @analyticsNetSavings.
  ///
  /// In vi, this message translates to:
  /// **'Tiết kiệm ròng'**
  String get analyticsNetSavings;

  /// No description provided for @subscriptionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gói Thuê Bao & Định Kỳ'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionMonthlyBurden.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí thuê bao hàng tháng'**
  String get subscriptionMonthlyBurden;

  /// No description provided for @subscriptionDaysRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày'**
  String subscriptionDaysRemaining(int days);

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cá Nhân & Cài Đặt'**
  String get profileTitle;

  /// No description provided for @profileSyncStatus.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ dữ liệu'**
  String get profileSyncStatus;

  /// No description provided for @profileSyncNow.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ ngay'**
  String get profileSyncNow;

  /// No description provided for @profileExportCsv.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu CSV'**
  String get profileExportCsv;

  /// No description provided for @profileExportJson.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu JSON'**
  String get profileExportJson;

  /// No description provided for @profileDarkMode.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện tối (Dark Mode)'**
  String get profileDarkMode;

  /// No description provided for @profileCurrency.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị tiền tệ chính'**
  String get profileCurrency;

  /// No description provided for @profileLogout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất tài khoản'**
  String get profileLogout;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
