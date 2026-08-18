// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Pocketly';

  @override
  String get appTagline => 'Quản lý tài chính thông minh';

  @override
  String get navHome => 'Tổng quan';

  @override
  String get navTransactions => 'Sổ thu chi';

  @override
  String get navBudget => 'Ngân sách';

  @override
  String get navAnalytics => 'Báo cáo';

  @override
  String get navProfile => 'Cá nhân';

  @override
  String get commonSave => 'Lưu lại';

  @override
  String get commonCancel => 'Hủy bỏ';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonEdit => 'Chỉnh sửa';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonCopy => 'Sao chép';

  @override
  String get commonSuccess => 'Thành công';

  @override
  String get commonError => 'Đã xảy ra lỗi';

  @override
  String get commonLoading => 'Đang tải dữ liệu...';

  @override
  String get commonEmpty => 'Chưa có dữ liệu';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get dashboardTotalBalance => 'Tổng số dư khả dụng';

  @override
  String get dashboardIncome => 'Thu nhập';

  @override
  String get dashboardExpense => 'Chi tiêu';

  @override
  String get dashboardRemainingBudget => 'Ngân sách còn lại';

  @override
  String get dashboardBudgetProgress => 'Tiến độ sử dụng';

  @override
  String get dashboardSmartInsight => 'Finly Smart Insight';

  @override
  String get dashboardCategoryBudgets => 'Ngân sách danh mục';

  @override
  String get dashboardRecentTransactions => 'Giao dịch gần đây';

  @override
  String get transactionAdd => 'Thêm giao dịch';

  @override
  String get transactionAddExpense => 'Khoản chi tiêu';

  @override
  String get transactionAddIncome => 'Khoản thu nhập';

  @override
  String get transactionAddTransfer => 'Chuyển tiền';

  @override
  String get transactionAmount => 'Số tiền';

  @override
  String get transactionCategory => 'Danh mục';

  @override
  String get transactionWallet => 'Ví thanh toán';

  @override
  String get transactionSourceWallet => 'Ví nguồn (Chuyển đi)';

  @override
  String get transactionDestWallet => 'Ví đích (Nhận tiền)';

  @override
  String get transactionNote => 'Ghi chú';

  @override
  String get transactionDate => 'Ngày giao dịch';

  @override
  String get transactionDeleted => 'Đã xóa giao dịch thành công';

  @override
  String get budgetTitle => 'Ngân Sách Chi Tiêu';

  @override
  String get budgetMonthlyLimit => 'Hạn mức chi tiêu tháng';

  @override
  String get budgetSetMonthly => 'Thiết lập ngân sách';

  @override
  String budgetForecastWarning(String amount) {
    return 'Dự kiến cuối tháng bạn sẽ vượt ngân sách $amount';
  }

  @override
  String get analyticsTitle => 'Phân Tích & Báo Cáo';

  @override
  String get analyticsSpendingBreakdown => 'Phân bổ chi tiêu';

  @override
  String get analyticsCashflowTrend => 'Xu hướng dòng tiền';

  @override
  String get analyticsSavingsRate => 'Tỷ lệ tiết kiệm';

  @override
  String get analyticsNetSavings => 'Tiết kiệm ròng';

  @override
  String get subscriptionTitle => 'Gói Thuê Bao & Định Kỳ';

  @override
  String get subscriptionMonthlyBurden => 'Chi phí thuê bao hàng tháng';

  @override
  String subscriptionDaysRemaining(int days) {
    return 'Còn $days ngày';
  }

  @override
  String get profileTitle => 'Cá Nhân & Cài Đặt';

  @override
  String get profileSyncStatus => 'Đồng bộ dữ liệu';

  @override
  String get profileSyncNow => 'Đồng bộ ngay';

  @override
  String get profileExportCsv => 'Xuất dữ liệu CSV';

  @override
  String get profileExportJson => 'Xuất dữ liệu JSON';

  @override
  String get profileDarkMode => 'Giao diện tối (Dark Mode)';

  @override
  String get profileCurrency => 'Đơn vị tiền tệ chính';

  @override
  String get profileLogout => 'Đăng xuất tài khoản';
}
