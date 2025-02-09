import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerStateProvider = StateProvider<PlayerState?>((ref) => null,);

class VolumeNotifier extends StateNotifier<double> {
  VolumeNotifier(this.playerId) : super(1);

  final int playerId;

  void setVolume(double volume) => {state = volume};
}
final volumeProvider = StateNotifierProvider.family<VolumeNotifier, double, int>(
  (ref, playerId) => VolumeNotifier(playerId),
);

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

  late List<String> sources;

  @override  
  void initState() {
    super.initState();
    sources = [for (int i = 0; i < players.length; i++) "Track $i"];
  }
  
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final playerState = ref.watch(playerStateProvider);
    final volume = [for (int i = 0; i < players.length; i++) ref.watch(volumeProvider(i))];
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
            Column(
              children: [
                for (int i = 0; i < players.length; i++)
                Container(
                  width: 300, // TODO: use a media query.
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Track ${i+1}"),
                            Text(sources[i]),
                          ],
                        ),
                      ),
                      Slider(
                        value: volume[i], 
                        onChanged: (double value) => _setVolume(i, value),
                      ),
                      IconButton(
                        onPressed: volume[i] == 0.0 ? () => _unmute(i) : () => _mute(i), 
                        icon: Icon(getVolumeIcon(volume[i])),
                        // icon: volume[i] == 0.0 ? Icon(Icons.volume_up) : Icon(Icons.volume_mute),
                      )
                    ],
                  )
                )
              ]
            ),
          ],
        ),
      ),
    );
  }

  IconData getVolumeIcon(double volume) {
    if (volume == 0.0) {
      return Icons.volume_mute;
    } else if (volume > 0.0 && volume < 0.5) {
      return Icons.volume_down;
    } 
    return Icons.volume_up;
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

  Future<void> _mute(int playerId) async {
    await players[playerId].setVolume(0);
    ref.read(volumeProvider(playerId).notifier).setVolume(0);
  }

  Future<void> _unmute(int playerId) async {
    await players[playerId].setVolume(1);
    ref.read(volumeProvider(playerId).notifier).setVolume(1);
  }

  Future<void> _setVolume(int playerId, double value) async {
    await players[playerId].setVolume(value);
    ref.read(volumeProvider(playerId).notifier).setVolume(value);
  }
}