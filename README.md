# Pocketly - Modern Personal Finance Management 💸

**Pocketly** là ứng dụng quản lý tài chính cá nhân di động hiện đại, bảo mật và hoạt động hoàn toàn **Offline-First**, tuân thủ nghiêm ngặt mô hình **Clean Architecture + Feature-First**. Ứng dụng giúp người dùng theo dõi chi tiêu, thu nhập, quản lý đa ví, ngân sách thông minh, giao dịch định kỳ, gói thuê bao và nhận các phân tích tài chính giá trị.

---

## 🚀 Tính năng nổi bật (Features)

- ⚡ **Ghi chép giao dịch siêu tốc**: Nhập số tiền, ghi chú, phân loại danh mục và ví tiền chỉ trong 3 giây.
- 📱 **Giao diện Fintech đẳng cấp (UI/UX Pro Max)**: Tối ưu hiển thị Dark/Light mode, hiệu ứng thị giác hiện đại, typography Outfit sắc nét.
- 🌐 **Offline-First Architecture**: Mọi thay đổi lưu tức thì vào SQLite cục bộ qua Drift, tự động đồng bộ qua Sync Queue khi có mạng.
- 💳 **Quản lý đa ví & Chuyển tiền (Transfer)**: Phân biệt rõ ràng giữa Chi tiêu và Chuyển khoản (không làm sai lệch phân tích chi tiêu).
- 📊 **Ngân sách & Dự báo cuối tháng (*Forecast Engine*)**: Thuật toán dự báo chi tiêu cuối tháng và cảnh báo nguy cơ vượt hạn mức.
- 🔄 **Giao dịch định kỳ & Gói thuê bao**: Tự động theo dõi các gói dịch vụ định kỳ (Netflix, Spotify, iCloud, ChatGPT Plus...) và đếm ngược ngày gia hạn.
- 🧠 **Smart Insight Engine (5 Quy tắc Fintech)**: Tự động phát hiện chi tiêu tăng đột biến, cảnh báo rủi ro và tuyên dương tỷ lệ tiết kiệm.
- 📥 **Xuất dữ liệu CSV & JSON**: Hỗ trợ xuất toàn bộ lịch sử thu chi để mở trên Microsoft Excel hoặc Google Sheets.
- 🌍 **Hệ thống Đa ngôn ngữ (Localization)**: Chuẩn ARB hỗ trợ Tiếng Việt & Tiếng Anh.
- 🔒 **Bảo mật tuyệt đối**: Token và dữ liệu nhạy cảm được lưu trữ an toàn trong `flutter_secure_storage`.

---

## 🛠 Tech Stack

- **Flutter & Dart** (Flutter 3.44+ / Dart 3.12+)
- **State Management**: [Riverpod](https://riverpod.dev) (`flutter_riverpod`, `riverpod_annotation`)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) (`StatefulShellRoute`, Deep linking, Auth Guards)
- **Local Database**: [Drift](https://drift.simonbinder.eu) (SQLite with Native isolates & migrations)
- **Networking**: [Dio](https://pub.dev/packages/dio) with custom Interceptors (Auth, Logging, Error)
- **Localization**: Official Flutter ARB (`app_vi.arb`, `app_en.arb`)
- **Typography & Styling**: Google Fonts Outfit & Custom Fintech Design System

---

## 📂 Kiến trúc dự án (Architecture)

Pocketly áp dụng **Clean Architecture + Feature-First**:

```
lib/
├── app/          # App initialization, Router, Theme tokens, Global config
├── core/         # Database (Drift), Network (Dio), Storage, Errors, Result, Utils, Extensions
├── shared/       # Reusable UI widgets, Bottom sheets, Cards, Dialogs
├── l10n/         # Multi-language ARB dictionary files (vi, en)
└── features/     # Feature modules (auth, dashboard, transaction, wallet, budget, analytics,
                  # recurring_transaction, subscription, insight, sync, settings)
```

---

## ⚡ Hướng dẫn cài đặt & Chạy dự án (Getting Started)

### 1. Cài đặt dependencies
```bash
flutter pub get
```

### 2. Sinh file Localization & Code Generation
```bash
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 3. Chạy kiểm tra tĩnh (Analyzer)
```bash
flutter analyze
```

### 4. Chạy kiểm thử tự động (Unit & Integration Tests)
```bash
flutter test
```

### 5. Khởi chạy ứng dụng
```bash
# Chạy trên Web Chrome
flutter run -d chrome

# Chạy trên thiết bị di động (khi có thiết bị/máy ảo)
flutter run
```
