import 'package:flutter/material.dart';
import 'package:inexplorer_app/pages/home-page.dart';

import 'package:inexplorer_app/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: PURPLE),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
      },
      initialRoute: '/',
    );
  }
}