import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:projectc_flutter/features/songs/presentation/song.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // This audio player code will eventually move out of here probably. 
    AudioPlayer player1 = AudioPlayer();
    AudioPlayer player2 = AudioPlayer();

    player1.setSource(AssetSource("atrack.mp3"));
    player2.setSource(AssetSource("btrack.mp3"));

    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SongPage(players: [player1, player2]), //const MyHomePage(title: 'Serverpod Example'),
    );
  }
}