import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongPage extends ConsumerStatefulWidget {
  const SongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongPage();
}

class _SongPage extends ConsumerState<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song"),
      ),
      body: FilledButton(
        child: const Text("Press me"),
        onPressed: () async {
          AudioPlayer player1 = AudioPlayer();
          AudioPlayer player2 = AudioPlayer();

          await player1.setSource(UrlSource("https://samplelib.com/lib/preview/mp3/sample-6s.mp3"));
          await player2.setSource(UrlSource("https://samplelib.com/lib/preview/mp3/sample-9s.mp3"));

          await Future.wait([
            player1.resume(),
            player2.resume(),
          ]);
        }, 
      ),
    );
  }
}