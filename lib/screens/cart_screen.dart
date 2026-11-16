import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_provider_demo/models/cart_model.dart';

/// Màn hình Giỏ hàng tách nhánh hoàn toàn với HomeScreen.
/// Cả hai màn hình đều đọc chung một thể hiện CartModel từ MultiProvider gốc.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng (${cart.itemCount})'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Giỏ hàng đang trống.\nQuay lại danh mục để thêm sản phẩm.',
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.name),
                        subtitle: Text(formatVnd(item.price)),
                        trailing: IconButton(
                          tooltip: 'Xóa khỏi giỏ',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            context.read<CartModel>().removeItem(item.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng cộng (${cart.itemCount} món)',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Text(
                            formatVnd(cart.totalPrice),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () => context.read<CartModel>().clear(),
                        child: const Text('Xóa tất cả'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
