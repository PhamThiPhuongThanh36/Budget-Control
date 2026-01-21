# 💰 Budget Control App - Quản lý tài chính cá nhân

Ứng dụng giúp bạn quản lý thu chi hàng ngày một cách đơn giản, trực quan và hiệu quả. Được xây dựng bằng Flutter với kiến trúc MVVM và database Drift (SQLite).

## 📸 Hình ảnh ứng dụng

### 🔐 Khởi đầu
| Màn hình đăng nhập |
| :---: |
| <img src="https://github.com/user-attachments/assets/b4cde8ec-89c6-4926-a260-81d13edb573e" width="280"> |
| *Giao diện đăng nhập tối giản* |

---

### 🏠 Tổng quan & Giao dịch
| Màn hình chính | Lịch sử giao dịch |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/b32c6631-7170-43a6-baa1-d35f9a9f6b3b" width="280"> | <img src="https://github.com/user-attachments/assets/3cbe49bd-5bca-49c4-abf1-8392c89e6223" width="280"> |
| *Theo dõi số dư thời gian thực* | *Chi tiết các khoản thu chi* |

---

### 📊 Phân tích & Thống kê
| Thống kê chi tiêu |
| :---: |
| <img src="https://github.com/user-attachments/assets/f46fe637-658d-495f-83c3-827e5fcf77b8" width="280"> |
| *Biểu đồ tròn trực quan theo danh mục* |

---

### 📂 Quản lý danh mục
| Danh sách danh mục | Chi tiết giao dịch | Thêm/Sửa danh mục | Xóa danh mục |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/6e19fdf1-03f1-4c90-8cff-036ebe5c5628" width="220"> | <img src="https://github.com/user-attachments/assets/d6111de2-7b73-4026-98a2-ddb7c05e64e0" width="220"> | <img src="https://github.com/user-attachments/assets/ff73bcd1-967a-45fd-ae38-fc1c17c08a5c" width="220"> | <img src="https://github.com/user-attachments/assets/ac06d81d-b3b8-49d7-a702-1786e76ad670" width="220"> |
| *Phân loại Thu/Chi* | *Xem giao dịch con* | *Tùy chỉnh linh hoạt* | *Xác nhận an toàn* |

---

## ✨ Tính năng nổi bật

* **Quản lý thu chi:** Thêm, sửa, xóa các giao dịch hàng ngày nhanh chóng.
* **Thống kê thông minh:** Biểu đồ tròn tự động phân tích tỷ lệ chi tiêu theo Tuần/Tháng/Năm.
* **So sánh kỳ trước:** Tự động tính toán phần trăm tăng trưởng so với tháng trước.
* **Quản lý danh mục:** Tự tạo các danh mục riêng (Ăn uống, Lương, Mua sắm...) để dễ dàng theo dõi.
* **Dữ liệu thời gian thực:** Sử dụng Stream giúp cập nhật số liệu ngay lập tức khi có thay đổi.
* **Lưu trữ Offline:** Toàn bộ dữ liệu được lưu cục bộ trên điện thoại, đảm bảo tính riêng tư.

## 🛠 Công nghệ sử dụng

* **Flutter:** Framework chính cho UI.
* **Provider:** Quản lý trạng thái (State Management).
* **Drift (SQLite):** Hệ quản trị cơ sở dữ liệu mạnh mẽ, hỗ trợ Stream.
* **GoRouter:** Điều hướng màn hình chuyên nghiệp.
* **FL Chart:** Thư viện vẽ biểu đồ chuyên sâu.
