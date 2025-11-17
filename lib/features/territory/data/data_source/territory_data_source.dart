import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTerritoryDatasource {
  final FirebaseFirestore firestore;
  FirebaseTerritoryDatasource(this.firestore);

  Future<void> save(String id, Map<String, dynamic> map) async {
    await firestore.collection('territories').doc(id).set(map);
  }

  Future<List<Map<String, dynamic>>> fetchUserTerritories(String userId) async {
    final q = await firestore
        .collection('territories')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return q.docs.map((d) => d.data()).toList();
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final doc = await firestore.collection('territories').doc(id).get();
    return doc.exists ? doc.data() : null;
  }
}