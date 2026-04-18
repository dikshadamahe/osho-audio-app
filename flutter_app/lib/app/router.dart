import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/tracks/track_list_screen.dart';
import '../features/player/player_screen.dart';
import '../features/player/mini_player_bar.dart';
import '../data/models/models.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: Stack(
            children: [
              child,
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MiniPlayerBar(),
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'series/:id',
              name: 'tracks',
              builder: (context, state) {
                final seriesId = state.pathParameters['id']!;
                final series = state.extra as Series?;
                return TrackListScreen(seriesId: seriesId, series: series);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/player',
      name: 'player',
      builder: (context, state) => const PlayerScreen(),
    ),
  ],
);
