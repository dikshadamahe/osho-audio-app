import 'package:cloud_firestore/cloud_firestore.dart';

class Series {
  final String id;
  final String title;
  final String? coverImageUrl;
  final int discourseCount;
  final String language;
  final String slug;

  Series({
    required this.id,
    required this.title,
    this.coverImageUrl,
    required this.discourseCount,
    required this.language,
    required this.slug,
  });

  factory Series.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Series(
      id: doc.id,
      title: data['title'] ?? '',
      coverImageUrl: data['cover_image_url'],
      discourseCount: data['discourse_count'] ?? 0,
      language: data['language'] ?? 'hi',
      slug: data['slug'] ?? '',
    );
  }
}

class Discourse {
  final String id;
  final int trackNumber;
  final String title;
  final String audioUrl;
  final int durationSeconds;
  final bool isBroken;
  final bool hasTranscript;
  final String? transcriptUrl;

  Discourse({
    required this.id,
    required this.trackNumber,
    required this.title,
    required this.audioUrl,
    required this.durationSeconds,
    this.isBroken = false,
    this.hasTranscript = false,
    this.transcriptUrl,
  });

  factory Discourse.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Discourse(
      id: doc.id,
      trackNumber: data['track_number'] ?? 0,
      title: data['title'] ?? 'Unknown Track',
      audioUrl: data['audio_url'] ?? '',
      durationSeconds: data['duration_seconds'] ?? 0,
      isBroken: data['is_broken'] ?? false,
      hasTranscript: data['has_transcript'] ?? false,
      transcriptUrl: data['transcript_url'],
    );
  }
}
