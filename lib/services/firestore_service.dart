import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();

  static final instance = FireStoreService._();

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentID)
          builder}) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((result) => builder(result.data(), result.id))
        .toList());
  }
}
