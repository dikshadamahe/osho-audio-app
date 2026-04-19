import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:osho_discourses/core/theme.dart';
import 'package:osho_discourses/data/models/models.dart';
import 'package:osho_discourses/features/tracks/widgets/track_tile.dart';

void main() {
  testWidgets(
    'TrackTile shows unavailable badge and strike-through for broken tracks',
    (tester) async {
      final brokenTrack = Discourse(
        id: '001',
        trackNumber: 1,
        title: 'Broken discourse',
        audioUrl: 'https://example.com/broken.mp3',
        durationSeconds: 95,
        isBroken: true,
      );

      await tester.pumpWidget(
        NeumorphicApp(
          themeMode: ThemeMode.dark,
          theme: AppTheme.darkNeumorphicTheme,
          darkTheme: AppTheme.darkNeumorphicTheme,
          home: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: TrackTile(discourse: brokenTrack),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Unavailable'), findsOneWidget);
      expect(find.byIcon(Icons.block_rounded), findsOneWidget);

      final titleText = tester.widget<Text>(find.text('Broken discourse'));
      expect(titleText.style?.decoration, TextDecoration.lineThrough);
    },
  );
}
