import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../services/audio_playback_service.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.watch(audioPlaybackProvider);
    final playerStateAsync = ref.watch(currentPlayerStateProvider);
    
    final isPlaying = playerStateAsync.value?.playing ?? false;
    final hasAudio = playerStateAsync.value != null;

    if (!hasAudio) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.pushNamed('player'),
      child: GlassContainer(
        height: 64,
        borderRadius: 0,
        blur: 14,
        opacity: 0.12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.music_note, color: AppTheme.amberFire),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Osho Discourse',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.warmIvory,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isPlaying ? 'Now Playing' : 'Paused',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppTheme.warmIvory,
                ),
                onPressed: () {
                  if (isPlaying) {
                    audioService.pause();
                  } else {
                    audioService.resume();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
