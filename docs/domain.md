# Domain & Business Rules

## 1. Tác động số dư ví (Balance Impact Rules)

- **Khoản chi (Expense)**:
  `Wallet.balance = Wallet.balance - Amount`
- **Khoản thu (Income)**:
  `Wallet.balance = Wallet.balance + Amount`
- **Chuyển khoản (Transfer)**:
  `SourceWallet.balance = SourceWallet.balance - Amount`
  `DestinationWallet.balance = DestinationWallet.balance + Amount`

> [!IMPORTANT]
> **Transfer KHÔNG được tính vào tổng chi tiêu (Expense Analytics)** để tránh làm sai lệch số liệu tài chính của người dùng.

---

## 2. Hoàn tác khi chỉnh sửa hoặc xóa giao dịch

- **Khi xóa giao dịch**: Thực hiện phép tính ngược lại với loại giao dịch ban đầu để đưa số dư ví về trạng thái cũ.
- **Khi chỉnh sửa giao dịch**:
  1. Đảo ngược tác động của giao dịch cũ.
  2. Áp dụng tác động của giao dịch mới với số tiền/ví mới.

---

## 3. Công thức dự báo ngân sách (Budget Forecast Calculation)

```dart
averageDailySpend = totalSpent / elapsedDaysInMonth;
forecastAmount = averageDailySpend * daysInMonth;

if (forecastAmount > budgetAmount) {
  status = BudgetStatus.forecastExceeded;
}
```
