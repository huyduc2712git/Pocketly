# Testing Guidelines

Finly duy trì độ tin cậy cao qua các cấp độ kiểm thử:

---

## 1. Unit Tests
- `test/core/result_test.dart`: Kiểm tra functional `Result<T>` pattern.
- `test/core/currency_formatter_test.dart`: Kiểm tra định dạng tiền tệ VND, USD, compact format.
- `test/core/database_test.dart`: Kiểm tra khởi tạo in-memory Drift SQLite, tạo dữ liệu seed và truy vấn.
- `test/features/auth/auth_controller_test.dart`: Kiểm tra StateNotifier auth flow.

---

## 2. Widget Tests
- `test/shared/widgets/app_button_test.dart`: Kiểm tra hiển thị nút bấm, variant và trạng thái loading.
- `test/features/dashboard/home_page_test.dart`: Kiểm tra render dashboard và 5 tab navigation.

---

## 3. Lệnh chạy kiểm thử
```bash
flutter test
```
