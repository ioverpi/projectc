import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerStateProvider = StateProvider<PlayerState?>((ref) => null,);

class SongPage extends ConsumerStatefulWidget {
  final List<AudioPlayer> players;
  const SongPage({
    required this.players,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongPage();
}

class _SongPage extends ConsumerState<SongPage> {
  List<AudioPlayer> get players => widget.players;
  
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final playerState = ref.watch(playerStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  key: const Key('play_button'),
                  onPressed: playerState == PlayerState.playing ? null : _play,
                  iconSize: 48.0,
                  icon: const Icon(Icons.play_arrow),
                  color: color,
                ),
                IconButton(
                  key: const Key('pause_button'),
                  onPressed: playerState == PlayerState.playing ? _pause : null,
                  iconSize: 48.0,
                  icon: const Icon(Icons.pause),
                  color: color,
                ),
                IconButton(
                  key: const Key('stop_button'),
                  onPressed: playerState == PlayerState.playing || playerState == PlayerState.paused ? _stop : null,
                  iconSize: 48.0,
                  icon: const Icon(Icons.stop),
                  color: color,
                )
              ]
            ),
            FilledButton(
              child: const Text("Press me"),
              onPressed: () async {
                AudioPlayer player1 = AudioPlayer();
                AudioPlayer player2 = AudioPlayer();
            
                await player1.setSource(UrlSource("https://samplelib.com/lib/preview/mp3/sample-6s.mp3"));
                await player2.setSource(UrlSource("https://samplelib.com/lib/preview/mp3/sample-9s.mp3"));
            
                player1.onPositionChanged.listen((Duration p) {
                  print("Current position player 1: $p");
                });
            
                player2.onPositionChanged.listen((Duration p) {
                  print("Current position player 2: $p");
                });
            
                await Future.wait([
                  player1.resume(),
                  player2.resume(),
                ]);
              }, 
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _play() async {
    await Future.wait([for (final player in players) 
      player.resume()
    ]);
    ref.read(playerStateProvider.notifier).state = PlayerState.playing;
  }

  Future<void> _pause() async {
    await Future.wait([
      for (final player in players)
      player.pause()
    ]);
    ref.read(playerStateProvider.notifier).state = PlayerState.paused;
  }

  Future<void> _stop() async {
    await Future.wait([
      for (final player in players)
      player.stop()
    ]);
    ref.read(playerStateProvider.notifier).state = PlayerState.stopped;
  }
}