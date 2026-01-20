// service/auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    // Créer l'utilisateur dans Firebase Auth
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Récupérer l'UID
    final user = userCredential.user;
    if (user != null) {
      // Créer le profil dans Firestore
      await _firestoreService.createUserProfile(
        uid: user.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Méthode pour récupérer le rôle de l'utilisateur actuel
  Future<String?> getCurrentUserRole() async {
    final user = currentUser;
    if (user != null) {
      return await _firestoreService.getUserRole(user.uid);
    }
    return null;
  }

  // Méthode pour récupérer le profil complet de l'utilisateur actuel
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    return await _firestoreService.getCurrentUserProfile();
  }
}
