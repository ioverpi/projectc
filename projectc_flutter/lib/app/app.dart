import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Placeholder(), //const MyHomePage(title: 'Serverpod Example'),
    );
  }
}