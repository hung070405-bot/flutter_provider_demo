import 'package:flutter/foundation.dart';

/// ChangeNotifier quản lý trạng thái bộ đếm đơn giản.
/// Đóng gói biến [_count] để mọi thay đổi đều đi qua phương thức và gọi [notifyListeners].
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  String get statusLabel {
    if (_count == 0) return 'Chưa có thao tác';
    if (_count > 0) return 'Đang ở mức dương (+$_count)';
    return 'Đang ở mức âm ($_count)';
  }

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    if (_count == 0) return;
    _count = 0;
    notifyListeners();
  }
}
