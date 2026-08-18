# Finly Architecture Documentation

## 1. Clean Architecture + Feature-First

Finly tuân thủ nghiêm ngặt **Dependency Rule**:

```
Presentation Layer (UI, Controllers, Widgets)
       ↓
Domain Layer (Entities, Use Cases, Repositories Interfaces)
       ↓
Data Layer (Repositories Impl, Local/Remote DataSources, Drift SQLite, Dio)
```

### Nguyên tắc cốt lõi:
1. **Domain Layer độc lập hoàn toàn**: Không phụ thuộc vào Flutter UI framework hay các package bên thứ 3 ngoài ngôn ngữ Dart thuần.
2. **Business Logic tập trung**: Logic tài chính (cộng trừ số dư ví, tính forecast, luật cảnh báo insight) nằm trong Domain Entity hoặc UseCase.
3. **Repository Abstraction**: Interface định nghĩa ở Domain, Implementation cụ thể nằm ở Data layer.
4. **Không có God Classes / God Providers**: Mỗi feature có ranh giới module rõ ràng.

---

## 2. Ranh giới các tầng (Layer Boundaries)

### 2.1 Domain Layer
- **Entities**: Mô hình nghiệp vụ bất biến (`UserEntity`, `RecurringTransactionEntity`, `SubscriptionEntity`, `InsightEntity`).
- **Repositories**: Giao diện trừu tượng (`AuthRepository`, `TransactionRepository`, `WalletRepository`).
- **Use Cases**: Đơn vị xử lý một hành vi người dùng (`AddTransactionUseCase`, `CalculateBudgetForecastUseCase`).

### 2.2 Data Layer
- **DataSources**:
  - `LocalDataSource`: Tương tác trực tiếp với SQLite qua Drift DAOs.
  - `RemoteDataSource`: Giao tiếp REST API qua Dio.
- **Repositories Implementation**: Điều phối giữa Local SQLite và Remote API theo mô hình Offline-First.

### 2.3 Presentation Layer
- **Controllers / Notifiers**: Riverpod `StateNotifier` quản lý UI state (Loading, Success, Error).
- **Pages**: Giao diện màn hình chính gắn liền với GoRouter.
- **Widgets**: Các widget con chuyên biệt, kích thước nhỏ gọn, không chứa business logic.

---

## 3. Quản lý trạng thái (State Management with Riverpod)

- **Server / Persistent State**: Đồng bộ từ Drift SQLite Stream và Repository.
- **UI State**: Được quản lý bởi Notifier nhẹ nhàng.
- **Không đặt toàn bộ app state vào global state**: Phân tách state theo từng feature riêng biệt.
