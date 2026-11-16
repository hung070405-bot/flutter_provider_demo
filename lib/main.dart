import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_provider_demo/models/counter_model.dart';
import 'package:flutter_provider_demo/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
      ],
      child: MaterialApp(
        title: 'Demo Chủ đề 12: Provider & ChangeNotifier',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blueGrey,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
