import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/models/models.dart';
import '../../data/repositories/database_repository.dart';
import '../../services/audio_playback_service.dart';

class TrackListScreen extends ConsumerWidget {
  final String seriesId;
  final Series? series;

  const TrackListScreen({
    super.key,
    required this.seriesId,
    this.series,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoursesAsync = ref.watch(discourseListProvider(seriesId));
    final audioService = ref.watch(audioPlaybackProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: AppTheme.deepBlack,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                series?.title ?? 'Series Tracks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  series?.coverImageUrl != null
                      ? Image.network(
                          series!.coverImageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(color: AppTheme.surface),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          discoursesAsync.when(
            data: (discourses) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final discourse = discourses[index];
                  return DiscourseListTile(
                    discourse: discourse,
                    onTap: () async {
                      await audioService.playDiscourse(discourse);
                      if (context.mounted) {
                        context.pushNamed('player');
                      }
                    },
                  );
                },
                childCount: discourses.length,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppTheme.amberFire)),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscourseListTile extends StatelessWidget {
  final Discourse discourse;
  final VoidCallback? onTap;

  const DiscourseListTile({super.key, required this.discourse, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.amberFire.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: AppTheme.amberFire),
          ),
          title: Text(
            discourse.title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            '${(discourse.durationSeconds / 60).floor()} min',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          trailing: discourse.isBroken
              ? const Tooltip(
                  message: 'Unavailable',
                  child: Icon(Icons.error_outline, color: Colors.grey),
                )
              : const Icon(Icons.more_vert),
          onTap: discourse.isBroken ? null : onTap,
        ),
      ),
    );
  }
}
