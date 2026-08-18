# Offline-First Synchronization Architecture

Hệ thống đồng bộ dữ liệu của Finly đảm bảo trải nghiệm người dùng không gián đoạn ngay cả khi không có kết nối mạng.

---

## 1. Vòng đời tạo dữ liệu (Data Creation Flow)

```
[User Action]
      ↓
[Domain UseCase]
      ↓
[Local Drift SQLite] (Ghi nhận tức thì)
      ↓
[UI Instant Reactive Update]
      ↓
[Push to Sync Queue] (Trạng thái: pending)
      ↓
[Background Sync Worker]
      ↓ (Có Internet)
[Remote REST API] (Dio)
      ↓
[Success Callback] ➔ [Cập nhật Sync Queue: synced]
```

---

## 2. Các trạng thái của Sync Queue (`sync_queue.status`)

1. **`pending`**: Giao dịch/thao tác mới tạo trên thiết bị, đang chờ đẩy lên server.
2. **`syncing`**: Đang trong quá trình truyền tải payload qua API.
3. **`synced`**: Đã xác nhận lưu thành công trên máy chủ.
4. **`failed`**: Lỗi mạng hoặc phản hồi lỗi từ server; hệ thống sẽ tăng `retryCount` và thử lại theo cơ chế Exponential Backoff (tối đa 3 lần).
