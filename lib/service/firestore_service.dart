// service/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sama_ufr/EtuPage/models.dart';
import 'dart:io';

// pour les actualités

// Méthodes pour la gestion des actualités (News)
class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Référence à la collection news
  CollectionReference get newsRef => _firestore.collection('news');

  /// Récupérer toutes les actualités publiées (pour étudiants)
  Future<List<NewsModel>> getPublishedNews() async {
    try {
      final querySnapshot = await newsRef
          .where('isPublished', isEqualTo: true)
          .orderBy('publishDate', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return NewsModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Erreur récupération actualités publiées: $e');
      return [];
    }
  }

  /// Stream des actualités publiées (pour mise à jour en temps réel)
  Stream<List<NewsModel>> getPublishedNewsStream() {
    return newsRef
        .where('isPublished', isEqualTo: true)
        .orderBy('publishDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return NewsModel.fromFirestore(doc);
          }).toList();
        });
  }

  /// Incrémenter le compteur de vues d'une actualité
  Future<void> incrementViews(String newsId) async {
    try {
      await newsRef.doc(newsId).update({
        'views': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erreur incrément vues: $e');
    }
  }

  /// Rechercher des actualités par mot-clé
  Future<List<NewsModel>> searchNews(String query) async {
    try {
      // Note: Firestore ne supporte pas les recherches textuelles natives
      // Pour des fonctionnalités avancées, envisagez Algolia ou ElasticSearch
      final allNews = await getPublishedNews();
      return allNews.where((news) {
        final titleMatch = news.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        final contentMatch = news.content.toLowerCase().contains(
          query.toLowerCase(),
        );
        final categoryMatch = news.category.toLowerCase().contains(
          query.toLowerCase(),
        );
        final tagsMatch = news.tags.any(
          (tag) => tag.toLowerCase().contains(query.toLowerCase()),
        );

        return titleMatch || contentMatch || categoryMatch || tagsMatch;
      }).toList();
    } catch (e) {
      print('Erreur recherche actualités: $e');
      return [];
    }
  }

  /// Récupérer les actualités par catégorie
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      final querySnapshot = await newsRef
          .where('isPublished', isEqualTo: true)
          .where('category', isEqualTo: category)
          .orderBy('publishDate', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return NewsModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Erreur récupération par catégorie: $e');
      return [];
    }
  }

  /// Récupérer les actualités les plus populaires (plus de vues)
  Future<List<NewsModel>> getPopularNews({int limit = 5}) async {
    try {
      final querySnapshot = await newsRef
          .where('isPublished', isEqualTo: true)
          .orderBy('views', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        return NewsModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Erreur récupération actualités populaires: $e');
      return [];
    }
  }

  /// Récupérer les catégories uniques des actualités
  Future<List<String>> getNewsCategories() async {
    try {
      final news = await getPublishedNews();
      final categories = news.map((n) => n.category).toSet().toList();
      categories.sort();
      return categories;
    } catch (e) {
      print('Erreur récupération catégories: $e');
      return ['Général', 'Événements', 'Bourses', 'Concours', 'Administratif'];
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  NewsService newsService = NewsService();

  // Références aux collections
  CollectionReference get usersRef => _firestore.collection('users');
  CollectionReference get formationsRef => _firestore.collection('formations');
  CollectionReference get documentsRef => _firestore.collection('documents');

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

  // Récupérer tous les utilisateurs
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final querySnapshot = await usersRef.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs: $e');
      return [];
    }
  }

  // Récupérer toutes les formations
  Future<List<Map<String, dynamic>>> getAllFormations() async {
    try {
      final querySnapshot = await formationsRef.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des formations: $e');
      return [];
    }
  }

  // Récupérer tous les documents
  Future<List<Map<String, dynamic>>> getAllDocuments() async {
    try {
      final querySnapshot = await documentsRef.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des documents: $e');
      return [];
    }
  }

  // Compter les utilisateurs
  Future<int> getUsersCount() async {
    final users = await getAllUsers();
    return users.length;
  }

  // Compter les formations
  Future<int> getFormationsCount() async {
    final formations = await getAllFormations();
    return formations.length;
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthodes existantes...

  // NOUVELLES MÉTHODES POUR LA GESTION DES DOCUMENTS

  /// Récupérer les documents en attente de validation
  Future<List<Map<String, dynamic>>> getPendingDocuments() async {
    try {
      final querySnapshot = await _firestore
          .collection('documents')
          .where('status', isEqualTo: 'pending')
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Erreur récupération documents en attente: $e');
      return [];
    }
  }

  /// Valider un document et l'envoyer à l'étudiant
  Future<bool> validateAndSendDocument({
    required String documentId,
    required String studentEmail,
    required String documentType,
    File? pdfFile,
    String? comments,
  }) async {
    try {
      String? fileUrl;

      // Si un fichier PDF est fourni, l'uploader
      if (pdfFile != null) {
        final ref = _storage.ref().child(
          'validated_documents/${DateTime.now().millisecondsSinceEpoch}_$documentType.pdf',
        );
        await ref.putFile(pdfFile);
        fileUrl = await ref.getDownloadURL();
      }

      // Mettre à jour le statut du document
      await _firestore.collection('documents').doc(documentId).update({
        'status': 'validated',
        'validatedAt': FieldValue.serverTimestamp(),
        'validatedBy': 'admin',
        'downloadUrl': fileUrl,
        'comments': comments,
      });

      // Créer une notification pour l'étudiant
      await _firestore.collection('notifications').add({
        'userId': await _getUserIdByEmail(studentEmail),
        'title': 'Document validé',
        'message': 'Votre $documentType a été validé et est disponible',
        'type': 'document',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
        'documentUrl': fileUrl,
      });

      // Enregistrer l'historique
      await _firestore.collection('document_history').add({
        'documentId': documentId,
        'action': 'validated',
        'adminId': 'admin',
        'studentEmail': studentEmail,
        'timestamp': FieldValue.serverTimestamp(),
        'comments': comments,
      });

      return true;
    } catch (e) {
      print('Erreur validation document: $e');
      return false;
    }
  }

  // MÉTHODES POUR LA GESTION DES FORMATIONS

  /// Ajouter une nouvelle formation
  Future<String?> addFormation({
    required String name,
    required String code,
    required String ufr,
    required String level,
    String? description,
    required String department,
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection('formations').add({
        'name': name,
        'code': code,
        'ufr': ufr,
        'level': level,
        'description': description ?? '',
        'department': department,
        'studentCount': 0,
        'status': 'Active',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Erreur ajout formation: $e');
      return null;
    }
  }

  /// Supprimer une formation
  Future<bool> deleteFormation(String formationId) async {
    try {
      await _firestore.collection('formations').doc(formationId).delete();
      return true;
    } catch (e) {
      print('Erreur suppression formation: $e');
      return false;
    }
  }

  /// Mettre à jour une formation
  Future<bool> updateFormation({
    required String formationId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore
          .collection('formations')
          .doc(formationId)
          .update(updates);
      return true;
    } catch (e) {
      print('Erreur mise à jour formation: $e');
      return false;
    }
  }

  // MÉTHODES POUR LA GESTION DES ÉVÉNEMENTS

  /// Créer un nouvel événement
  Future<bool> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String category,
    String? organizer,
    int? maxAttendees,
  }) async {
    try {
      await _firestore.collection('events').add({
        'title': title,
        'description': description,
        'date': date,
        'location': location,
        'category': category,
        'organizer': organizer ?? 'Administration',
        'maxAttendees': maxAttendees,
        'attendees': 0,
        'status': 'upcoming',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Erreur création événement: $e');
      return false;
    }
  }

  /// Récupérer tous les événements
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      final querySnapshot = await _firestore
          .collection('events')
          .orderBy('date', descending: false)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Erreur récupération événements: $e');
      return [];
    }
  }

  // MÉTHODES UTILITAIRES

  /// Récupérer l'ID utilisateur par email
  Future<String?> _getUserIdByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      print('Erreur récupération ID utilisateur: $e');
      return null;
    }
  }

  /// Récupérer tous les utilisateurs étudiants
  Future<List<Map<String, dynamic>>> getStudents() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'etudiant')
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Erreur récupération étudiants: $e');
      return [];
    }
  }

  /// Récupérer toutes les UFRs disponibles
  Future<List<String>> getUFRs() async {
    try {
      final querySnapshot = await _firestore.collection('ufrs').get();
      return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Si la collection n'existe pas, retourner des valeurs par défaut
      return ['UFR SAT', 'UFR SES', 'UFR LSH', 'UFR Médecine'];
    }
  }

  /// Récupérer tous les départements
  Future<List<String>> getDepartments() async {
    try {
      final querySnapshot = await _firestore.collection('departements').get();
      return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Valeurs par défaut
      return [
        'Informatique',
        'Mathématiques',
        'Physique',
        'Chimie',
        'Biologie',
      ];
    }
  }

  // pour les actualités
}
