import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_provider_demo/models/counter_model.dart';

/// Màn hình chính (StatelessWidget hoàn toàn, không dùng setState).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Provider & ChangeNotifier'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CounterSection(),
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
