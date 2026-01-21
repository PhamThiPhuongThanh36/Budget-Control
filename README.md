# Budget Control App - Quản lý tài chính cá nhân

Ứng dụng giúp bạn quản lý thu chi hàng ngày một cách đơn giản, trực quan và hiệu quả. Được xây dựng bằng Flutter với kiến trúc MVVM và database Drift (SQLite).

## 📸 Hình ảnh ứng dụng

### Đăng nhập
| Màn hình đăng nhập |
| :---: |
| <img src="https://github.com/user-attachments/assets/6e19fdf1-03f1-4c90-8cff-036ebe5c5628" width="280"> |

---

### Tổng quan & Giao dịch
| Màn hình chính | Thêm giao dịch | Lịch sử giao dịch |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/d6111de2-7b73-4026-98a2-ddb7c05e64e0" width="280"> | <img src="https://github.com/user-attachments/assets/f46fe637-658d-495f-83c3-827e5fcf77b8" width="280"> | <img src="https://github.com/user-attachments/assets/10fd7f31-7107-47e2-894f-fcae60e63666" width="280"> |

---

### Phân tích & Thống kê
| Thống kê theo tuần | Thống kê theo tháng | Thống kê theo năm |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/3f9d15a4-f344-49e7-b3ec-6797bf954cb2" width="280"> | <img src="https://github.com/user-attachments/assets/ac06d81d-b3b8-49d7-a702-1786e76ad670" width="280"> | <img src="https://github.com/user-attachments/assets/ff73bcd1-967a-45fd-ae38-fc1c17c08a5c" width="280"> |

---

### Quản lý danh mục
| Danh sách danh mục | Thêm danh mục | Sửa danh mục | Xóa danh mục |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/e23e8ec9-2442-4788-8149-0905cb34fe53" width="220"> | <img src="https://github.com/user-attachments/assets/3cbe49bd-5bca-49c4-abf1-8392c89e6223" width="220"> | <img src="https://github.com/user-attachments/assets/b4cde8ec-89c6-4926-a260-81d13edb573e" width="220"> | <img src="https://github.com/user-attachments/assets/b32c6631-7170-43a6-baa1-d35f9a9f6b3b" width="220"> |

---

## Tính năng nổi bật

* **Quản lý thu chi:** Thêm, sửa, xóa các giao dịch hàng ngày nhanh chóng.
* **Thống kê thông minh:** Biểu đồ tròn tự động phân tích tỷ lệ chi tiêu theo Tuần/Tháng/Năm.
* **Quản lý danh mục:** Tự tạo các danh mục riêng (Ăn uống, Lương, Mua sắm...) để dễ dàng theo dõi, xoá, sửa danh mục.
* **Dữ liệu thời gian thực:** Sử dụng Stream giúp cập nhật số liệu ngay lập tức khi có thay đổi.
* **Lưu trữ Offline:** Toàn bộ dữ liệu được lưu cục bộ trên điện thoại, đảm bảo tính riêng tư.

## 🛠 Công nghệ sử dụng

* **Flutter:** Framework chính cho UI.
* **Provider:** Quản lý trạng thái (State Management).
* **Drift (SQLite):** Hệ quản trị cơ sở dữ liệu mạnh mẽ, hỗ trợ Stream.
* **GoRouter:** Điều hướng màn hình chuyên nghiệp.
* **FL Chart:** Thư viện vẽ biểu đồ chuyên sâu.
