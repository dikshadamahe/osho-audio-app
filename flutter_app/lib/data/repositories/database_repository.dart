import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../../core/constants.dart';

class DatabaseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Series>> watchSeries() {
    return _db.collection(AppConstants.seriesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Series.fromFirestore(doc)).toList());
  }

  Stream<List<Discourse>> watchDiscourses(String seriesId) {
    return _db.collection(AppConstants.seriesCollection)
        .doc(seriesId)
        .collection(AppConstants.discoursesSubCollection)
        .orderBy('track_number')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Discourse.fromFirestore(doc)).toList());
  }
}

final databaseRepositoryProvider = Provider((ref) => DatabaseRepository());

final seriesListProvider = StreamProvider<List<Series>>((ref) {
  return ref.watch(databaseRepositoryProvider).watchSeries();
});

final discourseListProvider = StreamProvider.family<List<Discourse>, String>((ref, seriesId) {
  return ref.watch(databaseRepositoryProvider).watchDiscourses(seriesId);
});
