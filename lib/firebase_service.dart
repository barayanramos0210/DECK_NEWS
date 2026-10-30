import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'analysis_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- GESTIÓN DE USUARIOS ---
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // --- GESTIÓN DE ANÁLISIS ---
  Future<void> saveAnalysis(AnalysisResult result, String url) async {
    final user = await getCurrentUser();
    if (user == null) return;

    await _db.collection('analisis').add({
      'userId': user.uid,
      'url': url,
      'resumen': result.resumenNeutral,
      'categorias': result.categoriasAplicables,
      'datos': result.datosAnalisis,
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  // --- GESTIÓN DE REFLEXIONES ---
  Future<void> saveReflection({
    required String analysisId,
    required String decision,
    required String text,
  }) async {
    final user = await getCurrentUser();
    if (user == null) return;

    await _db.collection('retroalimentacion').add({
      'userId': user.uid,
      'analysisId': analysisId,
      'decision': decision,
      'reflexion': text,
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  // --- HISTORIAL ---
  Stream<QuerySnapshot> getUserHistory() {
    final user = _auth.currentUser;
    if (user == null) return Stream.empty();

    return _db
        .collection('analisis')
        .where('userId', isEqualTo: user.uid)
        .orderBy('fecha', descending: true)
        .snapshots();
  }
}
