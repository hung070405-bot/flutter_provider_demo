import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_provider_demo/main.dart';
import 'package:flutter_provider_demo/models/cart_model.dart';
import 'package:flutter_provider_demo/models/counter_model.dart';

void main() {
  group('CounterModel (ChangeNotifier)', () {
    test('tăng, giảm và đặt lại trạng thái hợp lệ', () {
      final counter = CounterModel();
      var notifyCount = 0;
      counter.addListener(() => notifyCount++);

      expect(counter.count, 0);
      counter.increment();
      expect(counter.count, 1);
      expect(notifyCount, 1);

      counter.decrement();
      expect(counter.count, 0);
      expect(notifyCount, 2);

      counter.increment();
      counter.reset();
      expect(counter.count, 0);
    });
  });

  group('CartModel (ChangeNotifier)', () {
    test('thêm, xóa, tính tổng tiền và phát notifyListeners', () {
      final cart = CartModel();
      var notifyCount = 0;
      cart.addListener(() => notifyCount++);

      cart.toggleItem(sampleProducts[0]);
      cart.toggleItem(sampleProducts[2]);
      expect(cart.itemCount, 2);
      expect(cart.totalPrice, 450000);
      expect(notifyCount, 2);

      cart.removeItem(sampleProducts[0].id);
      expect(cart.itemCount, 1);
      expect(cart.totalPrice, 300000);

      cart.clear();
      expect(cart.itemCount, 0);
      expect(cart.totalPrice, 0);
    });
  });

  testWidgets('Đồng bộ trạng thái đa widget và đa màn hình',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 1. Kiểm tra CounterModel cập nhật qua Consumer & select
    expect(find.text('Số đếm: 0'), findsOneWidget);
    await tester.tap(find.text('+ Tăng'));
    await tester.pump();
    expect(find.text('Số đếm: 1'), findsOneWidget);
    expect(find.text('Trạng thái: Đang ở mức dương: +1'), findsOneWidget);

    // 2. Thêm sản phẩm ở HomeScreen -> AppBar và dòng tổng tự cập nhật
    expect(find.text('Giỏ: 0'), findsOneWidget);
    await tester.tap(find.text('Thêm').first);
    await tester.pump();
    expect(find.text('Giỏ: 1'), findsOneWidget);
    expect(find.text('Đã chọn: 1 món • Tổng: 150.000đ'), findsOneWidget);

    // 3. Mở CartScreen (nhánh màn hình khác), xóa sản phẩm và kiểm tra đồng bộ ngược
    await tester.tap(find.text('Giỏ: 1'));
    await tester.pumpAndSettle();
    expect(find.text('Giỏ hàng: 1'), findsOneWidget);
    expect(find.text('Áo thun Flutter'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();
    expect(find.text('Giỏ hàng: 0'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Giỏ: 0'), findsOneWidget);
    expect(find.text('Đã chọn: 0 món • Tổng: 0đ'), findsOneWidget);
  });
}
