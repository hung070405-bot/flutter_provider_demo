# Flutter Provider & ChangeNotifier Demo – Chủ đề 12: Quản lý trạng thái

Ứng dụng Flutter thiết kế tối giản, trực quan nhằm minh họa cách tích hợp **Provider** và **ChangeNotifier**, cách cập nhật trạng thái tập trung và phản ánh thay đổi tức thì lên nhiều widget / màn hình khác nhau.

---

## 1. Phân công thực hiện theo thành viên (Đóng góp 50% - 50%)

Mã nguồn được phân chia commit rõ ràng giữa hai thành viên trên GitHub:

| Thành viên | Tài khoản GitHub | Nhiệm vụ & Module phụ trách | Tỷ lệ đóng góp |
| :--- | :--- | :--- | :---: |
| **Võ Huy Hùng** | [@hung070405-bot](https://github.com/hung070405-bot) | **Kiến trúc gốc & Bộ đếm Provider:** Khởi tạo dự án, cấu hình `MultiProvider` ở `MyApp`, xây dựng `CounterModel` (`ChangeNotifier`), giao diện bộ đếm dùng `Consumer`, `context.select`, `context.read`, tài liệu hướng dẫn và script chạy nhanh | **50%** |
| **Lê Nguyễn Trường Giang** | [@11legiang](https://github.com/11legiang) | **Đồng bộ giỏ hàng đa màn hình & Kiểm thử:** Xây dựng `CartModel` (`ChangeNotifier`), tách màn hình `CartScreen`, tích hợp badge `AppBar` + danh mục sản phẩm dùng `context.watch`, và viết unit/widget test tự động | **50%** |

---

## 2. Cấu trúc thư mục dự án

```text
flutter_provider_demo/
├── lib/
│   ├── main.dart                     # Điểm khởi chạy & cấu hình MultiProvider ở nút cha chung
│   ├── models/
│   │   ├── counter_model.dart        # ChangeNotifier bộ đếm (đóng gói _count, notifyListeners)
│   │   └── cart_model.dart           # ChangeNotifier giỏ hàng dùng chung nhiều màn hình
│   └── screens/
│       ├── home_screen.dart          # Màn hình chính (StatelessWidget hoàn toàn)
│       └── cart_screen.dart          # Màn hình giỏ hàng tách nhánh nhưng tự đồng bộ
├── test/
│   └── widget_test.dart              # Unit test ChangeNotifier & Widget test đồng bộ đa màn hình
├── chay_demo.bat                     # Script chạy nhanh app 1-click (Windows / Chrome)
├── HUONG_DAN_THUYET_TRINH.md         # Hướng dẫn thao tác từng bước khi đứng demo báo cáo
├── pubspec.yaml                      # Cấu hình dependencies Flutter (provider)
└── README.md                         # Tài liệu hướng dẫn cài đặt và cấu hình
```

---

## 3. Hướng dẫn cài đặt và chạy dự án (Installation)

### Yêu cầu môi trường
- **Flutter SDK**: `>= 3.4.0` (kiểm tra bằng lệnh `flutter doctor`).
- **Thiết bị chạy**: Google Chrome (Web), Windows Desktop, Android Emulator hoặc điện thoại thật.

### Các bước cài đặt
1. **Clone kho mã nguồn từ GitHub:**
   ```bash
   git clone https://github.com/hung070405-bot/flutter_provider_demo.git
   cd flutter_provider_demo
   ```

2. **Cách 1 – Chạy nhanh 1-click (Khuyên dùng trên Windows):**
   - Nhấp đúp vào file `chay_demo.bat` ở thư mục gốc.
   - Nhập `1` để chạy ứng dụng trên **Windows Desktop** hoặc `2` để chạy trên **Google Chrome**.

3. **Cách 2 – Chạy thủ công bằng dòng lệnh:**
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
   *(Hoặc thay `chrome` bằng `windows` hoặc `edge`).*

4. **Chạy kiểm thử tự động (Unit + Widget test):**
   ```bash
   flutter test
   ```

---

## 4. Cấu hình biến môi trường (`.env`) và `google-services.json`

### 4.1. Trạng thái hiện tại
- Dự án tập trung minh họa thuần túy cơ chế quản lý trạng thái cục bộ với **Provider & ChangeNotifier** trong Flutter (`MultiProvider`, `Consumer`, `context.watch`, `context.read`, `context.select`) mà không phụ thuộc dịch vụ backend bên ngoài. Do đó, ứng dụng **chạy ngay lập tức** sau khi clone.

### 4.2. Hướng dẫn cấu hình khi mở rộng kết nối Backend / Firebase
Khi mở rộng dự án đồng bộ trạng thái giỏ hàng hoặc tài khoản với REST API / Firebase:

1. **Cấu hình file biến môi trường (`.env`):**
   - Sao chép file `.env.example` thành `.env` tại thư mục gốc:
     ```env
     APP_ENV=development
     API_BASE_URL=https://api.example.com/v1
     CART_SYNC_ENDPOINT=/cart
     REQUEST_TIMEOUT_SECONDS=15
     ```
   - Thêm gói `flutter_dotenv` vào `pubspec.yaml` và khai báo `- .env` trong mục `assets`.

2. **Cấu hình dịch vụ Firebase (`google-services.json`):**
   - Tải `google-services.json` từ Firebase Console và đặt vào `android/app/google-services.json`.
   - Đối với iOS (nếu có), đặt `GoogleService-Info.plist` vào `ios/Runner/`.

---

## 5. Nội dung minh họa trong ứng dụng

1. **Phần 1 – Bộ đếm (`Consumer`, `context.select`, `context.read`):**
   - Bấm `+ Tăng` / `- Giảm` / `Đặt lại` bằng `context.read<CounterModel>()` (không làm nút tự vẽ lại).
   - `Consumer<CounterModel>` chỉ cập nhật đúng dòng chữ `Số đếm: X` và giữ nguyên phần `child` tĩnh.
   - `context.select<CounterModel, String>` lắng nghe riêng chuỗi trạng thái dẫn xuất (`statusLabel`).

2. **Phần 2 – Danh mục & Giỏ hàng đa màn hình (`ChangeNotifier` + `context.watch`):**
   - Bấm `Thêm` ở từng sản phẩm thuộc `HomeScreen` -> badge `Giỏ (X)` trên `AppBar`, dòng tóm tắt `Đã chọn / Tổng tiền` và nút bấm tự đồng bộ tức thì.
   - Chuyển sang route khác là `CartScreen`: danh sách sản phẩm và tổng tiền hiển thị chính xác dữ liệu chung từ `MultiProvider`.
   - Bấm xóa món hoặc `Xóa tất cả` trong `CartScreen` rồi quay lại `HomeScreen`: mọi widget liên quan đều đã phản ánh trạng thái mới mà không cần truyền callback qua lại.
