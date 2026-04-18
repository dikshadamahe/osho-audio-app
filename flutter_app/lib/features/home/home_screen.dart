import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/repositories/database_repository.dart';
import '../../data/models/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.deepBlack.withOpacity(0.8),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Osho Discourses',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
          ),
          seriesAsync.when(
            data: (seriesList) => SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final series = seriesList[index];
                    return SeriesCard(series: series);
                  },
                  childCount: seriesList.length,
                ),
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

class SeriesCard extends StatelessWidget {
  final Series series;

  const SeriesCard({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        'tracks',
        pathParameters: {'id': series.id},
        extra: series,
      ),
      child: GlassContainer(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: series.coverImageUrl != null && series.coverImageUrl!.isNotEmpty
                    ? Image.network(
                        series.coverImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppTheme.surface,
                          child: const Icon(Icons.music_note, color: AppTheme.mutedTeal),
                        ),
                      )
                    : Container(
                        color: AppTheme.surface,
                        child: const Icon(Icons.music_note, color: AppTheme.mutedTeal),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              series.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${series.discourseCount} Discourses',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
