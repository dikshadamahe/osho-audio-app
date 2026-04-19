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
    final data = _asMap(doc.data());
    return Series(
      id: doc.id,
      title: _asString(data['title']),
      coverImageUrl: _asNullableString(data['cover_image_url']),
      discourseCount: _asInt(data['discourse_count']),
      language: _asString(data['language'], fallback: 'hi'),
      slug: _asString(data['slug']),
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
    final data = _asMap(doc.data());
    return Discourse(
      id: doc.id,
      trackNumber: _asInt(data['track_number']),
      title: _asString(data['title'], fallback: 'Unknown Track'),
      audioUrl: _asString(data['audio_url']),
      durationSeconds: _asInt(data['duration_seconds']),
      isBroken: _asBool(data['is_broken']),
      hasTranscript: _asBool(data['has_transcript']),
      transcriptUrl: _asNullableString(data['transcript_url']),
    );
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, entryValue) => MapEntry(key.toString(), entryValue));
  }
  return const <String, dynamic>{};
}

String _asString(Object? value, {String fallback = ''}) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return fallback;
}

String? _asNullableString(Object? value) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return null;
}

int _asInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return 0;
}

bool _asBool(Object? value) {
  if (value is bool) {
    return value;
  }
  return false;
}
