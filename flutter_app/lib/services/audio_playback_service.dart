import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/models.dart';

class AudioPlaybackService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> playDiscourse(Discourse discourse) async {
    try {
      final source = AudioSource.uri(Uri.parse(discourse.audioUrl));
      await _player.setAudioSource(source);
      _player.play();
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> seek(Duration position) => _player.seek(position);

  void dispose() {
    _player.dispose();
  }
}

final audioPlaybackProvider = Provider((ref) {
  final service = AudioPlaybackService();
  ref.onDispose(() => service.dispose());
  return service;
});

final currentPlayerStateProvider = StreamProvider((ref) {
  return ref.watch(audioPlaybackProvider).playerStateStream;
});

final currentPositionProvider = StreamProvider((ref) {
  return ref.watch(audioPlaybackProvider).positionStream;
});
final currentDurationProvider = StreamProvider((ref) {
  return ref.watch(audioPlaybackProvider).durationStream;
});
