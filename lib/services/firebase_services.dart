import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_quiz/model/questions_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Question>> getQuestionsStream() {
    return _firestore.collection('questions').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Question.fromQueryDocumentSnapshot(doc))
          .toList();
    });
  }

  Stream<Map<String, dynamic>> getConfigStream() {
    return _firestore.collection('config').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return {};
    });
  }
}
