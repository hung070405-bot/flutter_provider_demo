# Hướng dẫn thuyết trình Demo Chủ đề 12: Provider & ChangeNotifier

Ứng dụng được giữ giao diện tối giản, chia tách rõ ràng tầng trạng thái (`lib/models/`) và tầng giao diện hoàn toàn dùng `StatelessWidget` (`lib/screens/`).

---

## 1. Cách chạy nhanh Demo
- Cách 1: Nhấp đúp vào [chay_demo.bat](file:///D:/download/flutter_provider_demo/chay_demo.bat), chọn `1` (Windows) hoặc `2` (Chrome).
- Cách 2: Chạy bằng lệnh:
  ```bash
  flutter run -d chrome
  ```

---

## 2. Ánh xạ lý thuyết vào Code (Trả lời vấn đáp)

| Khái niệm | File & Vị trí trong Code | Ý nghĩa khi trình bày |
| :--- | :--- | :--- |
| **ChangeNotifier & Đóng gói** | `lib/models/counter_model.dart`, `cart_model.dart` | Biến `_count`, `_items` đều đặt riêng tư (`_`), chỉ thay đổi qua phương thức và gọi `notifyListeners()`. |
| **MultiProvider ở nút cha chung** | `lib/main.dart` | Bọc cả `CounterModel` và `CartModel` phía trên `MaterialApp` để mọi màn hình bên dưới cùng truy xuất được. |
| **Consumer & tham số `child`** | `lib/screens/home_screen.dart` | Khoanh vùng chỉ vẽ lại dòng `Số đếm: X`, phần chữ phụ truyền qua `child` đứng yên. |
| **context.read()** | Các nút `onPressed` ở cả 2 màn hình | Gọi hàm thay đổi dữ liệu (`increment`, `toggleItem`, `removeItem`) mà không lắng nghe vẽ lại nút. |
| **context.select()** | `AppBar` và dòng `statusLabel` | Chỉ rebuild khi giá trị chọn lọc (`itemCount` hoặc `statusLabel`) thực sự thay đổi. |
| **context.watch()** | `_CatalogSection` & `CartScreen` | Lắng nghe thay đổi của `CartModel` để cập nhật danh sách và tổng tiền ở nhiều màn hình khác nhau. |

---

## 3. Kịch bản thao tác Demo trực tiếp (1 - 2 phút)

1. **Bước 1 – Minh họa cập nhật cục bộ với Bộ đếm:**
   - Bấm `+ Tăng` vài lần -> chỉ ra dòng `Số đếm` cập nhật qua `Consumer` và dòng `Trạng thái` cập nhật qua `context.select`, trong khi các nút bấm (`context.read`) không bị rebuild.
2. **Bước 2 – Minh họa đồng bộ nhiều widget trên cùng màn hình:**
   - Ở mục Danh mục, bấm `Thêm` ở *Áo thun Flutter* và *Bàn phím cơ*.
   - Chỉ cho thầy cô thấy **3 chỗ tự động thay đổi cùng lúc**: nút `Thêm` đổi thành `Đã thêm`, dòng tóm tắt nhảy `Đã chọn: 2 món • Tổng: 450.000đ`, và chữ `Giỏ: 2` trên `AppBar`.
3. **Bước 3 – Minh họa đồng bộ ngược đa màn hình:**
   - Bấm `Giỏ: 2` hoặc `Mở giỏ hàng` để sang một route hoàn toàn tách biệt (`CartScreen`).
   - Bấm xóa một món (hoặc `Xóa tất cả`) rồi bấm nút Back quay lại `HomeScreen` -> toàn bộ trạng thái trên `HomeScreen` đã tự đồng bộ sạch sẽ mà không cần viết một dòng `setState()` nào.
