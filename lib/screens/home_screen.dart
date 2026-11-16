import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_provider_demo/models/cart_model.dart';
import 'package:flutter_provider_demo/models/counter_model.dart';
import 'package:flutter_provider_demo/screens/cart_screen.dart';

/// Màn hình chính (StatelessWidget hoàn toàn, không dùng setState).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppBar chỉ lắng nghe riêng số lượng món trong giỏ hàng
    final cartCount = context.select<CartModel, int>((cart) => cart.itemCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Provider & ChangeNotifier'),
        actions: [
          TextButton.icon(
            onPressed: () => _openCart(context),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text('Giỏ ($cartCount)'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _CounterSection(),
          const SizedBox(height: 16),
          _CatalogSection(onOpenCart: () => _openCart(context)),
        ],
      ),
    );
  }
}

/// Minh họa Consumer, context.select() và context.read().
class _CounterSection extends StatelessWidget {
  const _CounterSection();

  @override
  Widget build(BuildContext context) {
    // context.select chỉ rebuild widget này khi chuỗi statusLabel thay đổi
    final statusLabel = context.select<CounterModel, String>(
      (model) => model.statusLabel,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1. Bộ đếm (Consumer / select / read)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Consumer<CounterModel>(
            builder: (context, counter, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số đếm: ${counter.count}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ?child,
                ],
              );
            },
            // Phần child tĩnh không bị dựng lại khi count thay đổi
            child: Text(
              'Cập nhật qua Consumer',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Trạng thái (select): $statusLabel',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => context.read<CounterModel>().decrement(),
                child: const Text('- Giảm'),
              ),
              FilledButton(
                onPressed: () => context.read<CounterModel>().increment(),
                child: const Text('+ Tăng'),
              ),
              TextButton(
                onPressed: () => context.read<CounterModel>().reset(),
                child: const Text('Đặt lại'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Minh họa ChangeNotifier đồng bộ trạng thái giữa nhiều widget và màn hình.
class _CatalogSection extends StatelessWidget {
  final VoidCallback onOpenCart;

  const _CatalogSection({required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2. Danh mục & Giỏ hàng (watch / đa màn hình)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Đã chọn: ${cart.itemCount} món • Tổng: ${formatVnd(cart.totalPrice)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
              ),
              TextButton(
                onPressed: onOpenCart,
                child: const Text('Mở giỏ hàng'),
              ),
            ],
          ),
          const Divider(),
          for (final product in sampleProducts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(product.name),
              subtitle: Text(formatVnd(product.price)),
              trailing: cart.contains(product.id)
                  ? FilledButton.tonal(
                      onPressed: () =>
                          context.read<CartModel>().toggleItem(product),
                      child: const Text('Đã thêm'),
                    )
                  : OutlinedButton(
                      onPressed: () =>
                          context.read<CartModel>().toggleItem(product),
                      child: const Text('Thêm'),
                    ),
            ),
        ],
      ),
    );
  }
}
