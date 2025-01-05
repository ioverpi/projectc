import 'package:flutter/material.dart';
import 'package:projectc_flutter/features/songs/presentation/song.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SongPage(), //const MyHomePage(title: 'Serverpod Example'),
    );
  }
}