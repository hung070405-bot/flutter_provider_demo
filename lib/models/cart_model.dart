import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final int price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

const List<Product> sampleProducts = [
  Product(id: 'p1', name: 'Áo thun Flutter', price: 150000),
  Product(id: 'p2', name: 'Sách Dart cơ bản', price: 120000),
  Product(id: 'p3', name: 'Bàn phím cơ', price: 300000),
  Product(id: 'p4', name: 'Chuột không dây', price: 180000),
];

/// Định dạng số tiền VNĐ đơn giản không cần thư viện ngoài.
String formatVnd(int amount) {
  final str = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    final reverseIdx = str.length - i;
    buffer.write(str[i]);
    if (reverseIdx > 1 && reverseIdx % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer.toString()}đ';
}

/// ChangeNotifier quản lý trạng thái giỏ hàng dùng chung giữa các màn hình.
class CartModel extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  bool contains(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void toggleItem(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    final before = _items.length;
    _items.removeWhere((item) => item.id == productId);
    if (_items.length != before) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
