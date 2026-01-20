// service/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Référence à la collection 'users'
  CollectionReference get usersRef => _firestore.collection('users');

  // Créer ou mettre à jour un utilisateur dans Firestore
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    Map<String, dynamic>? additionalData,
  }) async {
    final userData = {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      ...?additionalData,
    };

    await usersRef.doc(uid).set(userData, SetOptions(merge: true));
  }

  // Récupérer le profil utilisateur par UID
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await usersRef.doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du profil: $e');
      return null;
    }
  }

  // Récupérer le rôle de l'utilisateur
  Future<String?> getUserRole(String uid) async {
    final userData = await getUserProfile(uid);
    return userData?['role'] as String?;
  }

  // Vérifier si un utilisateur a un rôle spécifique
  Future<bool> hasRole(String uid, String role) async {
    final userRole = await getUserRole(uid);
    return userRole == role;
  }

  // Mettre à jour les informations utilisateur
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await usersRef.doc(uid).update(updates);
  }

  // Stream du profil utilisateur (pour écouter les changements en temps réel)
  Stream<Map<String, dynamic>?> getUserProfileStream(String uid) {
    return usersRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
      return null;
    });
  }

  // Récupérer l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Récupérer le profil de l'utilisateur actuel
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user != null) {
      return await getUserProfile(user.uid);
    }
    return null;
  }

  // Stream du profil de l'utilisateur actuel
  Stream<Map<String, dynamic>?> getCurrentUserProfileStream() {
    final user = currentUser;
    if (user != null) {
      return getUserProfileStream(user.uid);
    }
    return Stream.value(null);
  }
}
