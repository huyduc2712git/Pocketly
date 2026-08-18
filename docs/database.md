# Drift SQLite Database Schema & Migrations

Finly sử dụng **Drift** (trước đây là Moor) làm ORM SQLite chính thức với kiến trúc hướng kiểu mạnh (type-safe).

---

## 1. Danh sách các bảng (Tables)

| Tên bảng | Mục đích | Khóa chính |
| :--- | :--- | :--- |
| `users` | Thông tin người dùng hiện tại và thiết lập tiền tệ | `id` |
| `wallets` | Tài khoản/Ví (Tiền mặt, Ngân hàng, Thẻ tín dụng) | `id` |
| `categories` | Danh mục thu/chi (Ăn uống, Di chuyển, Lương...) | `id` |
| `transactions` | Giao dịch phát sinh (Expense, Income, Transfer) | `id` |
| `budgets` | Kế hoạch ngân sách theo tháng/năm | `id` |
| `budget_items` | Hạn mức chi tiêu cho từng danh mục con | `id` |
| `recurring_transactions` | Giao dịch định kỳ tự động phát sinh | `id` |
| `subscriptions` | Dịch vụ đăng ký định kỳ (Netflix, Spotify, iCloud...) | `id` |
| `insights` | Cảnh báo và lời khuyên tài chính từ Insight Engine | `id` |
| `sync_queue` | Hàng đợi đồng bộ hóa dữ liệu Offline-First | `id` |

---

## 2. Foreign Keys & Cascading

- `transactions.wallet_id` ➔ `wallets.id` (ON DELETE CASCADE)
- `transactions.to_wallet_id` ➔ `wallets.id` (ON DELETE SET NULL)
- `transactions.category_id` ➔ `categories.id` (ON DELETE SET NULL)
- `budget_items.budget_id` ➔ `budgets.id` (ON DELETE CASCADE)
- `budget_items.category_id` ➔ `categories.id` (ON DELETE CASCADE)
- Bật `PRAGMA foreign_keys = ON;` khi mở kết nối cơ sở dữ liệu.

---

## 3. Chiến lược Migration (Schema Versioning)

Mỗi thay đổi cấu trúc bảng sẽ nâng `DbConstants.databaseVersion` và thực hiện `m.alterTable()` hoặc `m.addColumn()` tương ứng trong `MigrationStrategy`.
