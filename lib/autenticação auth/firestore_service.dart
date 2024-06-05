import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getPlantInfo(String scientificName) async {
    try {
      var querySnapshot = await _firestore.collection('plantas')
          .where('scientificName', isEqualTo: scientificName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        throw Exception('Planta não encontrada');
      }
    } catch (e) {
      rethrow;
    }
  }
}
