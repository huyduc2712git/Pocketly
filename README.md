# Finly - Personal Finance & Expense Management 💸

**Finly** là ứng dụng quản lý tài chính cá nhân di động hiện đại, bảo mật và hoạt động hoàn toàn **Offline-First**. Ứng dụng giúp người dùng theo dõi chi tiêu, thu nhập, quản lý đa ví, ngân sách thông minh và nhận các phân tích tài chính giá trị.

---

## 🚀 Tính năng nổi bật (Features)

- ⚡ **Ghi chép giao dịch siêu tốc**: Nhập số tiền, ghi chú, phân loại danh mục và ví tiền chỉ trong 3 giây.
- 📱 **Giao diện Fintech đẳng cấp**: Tối ưu hiển thị Dark/Light mode, hiệu ứng thị giác hiện đại, typography Outfit sắc nét.
- 🌐 **Offline-First Architecture**: Mọi thay đổi lưu tức thì vào SQLite cục bộ qua Drift, tự động đồng bộ lên máy chủ qua Sync Queue khi có mạng.
- 💳 **Quản lý đa ví & Chuyển tiền (Transfer)**: Phân biệt rõ ràng giữa Chi tiêu và Chuyển khoản (không làm sai lệch phân tích chi tiêu).
- 📊 **Ngân sách & Cảnh báo thông minh**: Theo dõi tiến độ chi tiêu danh mục, dự báo vượt ngân sách và Rule-based Insight.
- 🔒 **Bảo mật tuyệt đối**: Token và dữ liệu nhạy cảm được lưu trữ an toàn trong `flutter_secure_storage`.

---

## 🛠 Tech Stack

- **Flutter & Dart** (Flutter 3.44+ / Dart 3.12+)
- **State Management**: [Riverpod](https://riverpod.dev) (`flutter_riverpod`, `riverpod_annotation`)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) (`StatefulShellRoute`, Deep linking, Auth Guards)
- **Local Database**: [Drift](https://drift.simonbinder.eu) (SQLite with Native isolates & migrations)
- **Networking**: [Dio](https://pub.dev/packages/dio) with custom Interceptors (Auth, Logging, Error)
- **Data Modeling**: [Freezed](https://pub.dev/packages/freezed) & `json_serializable`
- **Typography & Styling**: Google Fonts Outfit & Custom Fintech Design System

---

## 📂 Kiến trúc dự án (Architecture)

Finly áp dụng **Clean Architecture + Feature-First**:

```
lib/
├── app/          # App initialization, Router, Theme tokens, Global config
├── core/         # Database (Drift), Network (Dio), Storage, Errors, Result, Utils
├── shared/       # Reusable UI widgets, Bottom sheets, Cards, Dialogs
└── features/     # Feature modules (auth, dashboard, transaction, wallet, budget, analytics...)
```

---

## ⚡ Hướng dẫn cài đặt & Chạy dự án (Getting Started)

### 1. Cài đặt dependencies
```bash
flutter pub get
```

### 2. Chạy Code Generation (Drift, Freezed, Riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Chạy kiểm tra tĩnh (Analyzer)
```bash
flutter analyze
```

### 4. Chạy Unit & Widget Tests
```bash
flutter test
```

### 5. Khởi chạy ứng dụng
```bash
flutter run
```

---

## 📖 Tài liệu kỹ thuật chi tiết

- [Kiến trúc & Nguyên tắc thiết kế](ARCHITECTURE.md)
- [Cơ sở dữ liệu Drift & Schema](docs/database.md)
- [Cơ chế Offline-First Sync](docs/sync.md)
- [Quy tắc Domain & Tài chính](docs/domain.md)
- [Chiến lược Kiểm thử (Testing)](docs/testing.md)
