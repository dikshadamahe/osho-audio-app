import 'package:flutter/material.dart';

class PlayPauseMorphIcon extends StatelessWidget {
  const PlayPauseMorphIcon({
    super.key,
    required this.isPlaying,
    this.size = 24,
    this.color,
  });

  final bool isPlaying;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: isPlaying ? 0 : 1, end: isPlaying ? 1 : 0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: AlwaysStoppedAnimation<double>(value),
          size: size,
          color: color,
        );
      },
    );
  }
}
