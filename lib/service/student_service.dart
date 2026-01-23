import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sama_ufr/EtuPage/models.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Articles avec filtrage par catégorie (optimisé)
  Stream<List<ArticleModel>> getArticlesStream({String? category}) {
    Query query = _firestore
        .collection('articles')
        .orderBy('publishDate', descending: true)
        .limit(20); // Limiter les résultats

    if (category != null && category != 'Tous') {
      query = query.where('category', isEqualTo: category);
    }

    return query
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ArticleModel.fromFirestore(doc);
          }).toList();
        })
        .handleError((error) {
          print('Erreur articles: $error');
          return <ArticleModel>[];
        });
  }

  // 2. Événements à venir (optimisé)
  Stream<List<EventModel>> getEventsStream() {
    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('date')
        .limit(5) // Limiter les événements affichés
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromFirestore(doc);
          }).toList();
        })
        .handleError((error) {
          print('Erreur événements: $error');
          return <EventModel>[];
        });
  }

  // 3. Résultats de l'étudiant (Version Stream pour le temps réel)
  Stream<List<CourseResult>> getStudentResultsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      print('⚠️ Utilisateur non authentifié pour résultats');
      return Stream.value([]);
    }

    return _firestore
        .collection('results')
        .where('studentId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          print('📊 Nombre de résultats trouvés (Stream): ${snapshot.docs.length}');
          return snapshot.docs.map((doc) {
            return CourseResult.fromFirestore(doc);
          }).toList();
        })
        .handleError((error) {
          print('❌ Erreur flux résultats: $error');
          return <CourseResult>[];
        });
  }

  // 3. Résultats de l'étudiant (Future existant conservé pour compatibilité si nécessaire)
  Future<List<CourseResult>> getStudentResults() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('⚠️ Utilisateur non authentifié pour résultats');
      return [];
    }

    try {
      print('🔍 Recherche résultats pour UID: ${user.uid}');
      final query = await _firestore
          .collection('results')
          .where('studentId', isEqualTo: user.uid)
          .get();

      print('📊 Nombre de résultats trouvés: ${query.docs.length}');
      for (var doc in query.docs) {
        print('📄 Résultat: ${doc.data()}');
      }

      final results = query.docs.map((doc) {
        return CourseResult.fromFirestore(doc);
      }).toList();
      return results;
    } catch (e) {
      print('❌ Erreur récupération résultats: $e');
      return [];
    }
  }

  // 4. Emploi du temps (optimisé)
  Stream<List<Schedule>> getScheduleStream(String weekStart) {
    final user = _auth.currentUser;
    if (user == null) {
      print('⚠️ Utilisateur non authentifié pour schedules');
      return Stream.value([]);
    }

    print('🔍 Recherche schedules: UID=${user.uid}, weekStart=$weekStart');
    return _firestore
        .collection('schedules')
        .where('studentId', isEqualTo: user.uid)
        .where('weekStart', isEqualTo: weekStart)
        .snapshots()
        .map((snapshot) {
          print(
            '📅 Schedules snapshot reçu: ${snapshot.docs.length} documents',
          );
          for (var doc in snapshot.docs) {
            print('📄 Schedule: ${doc.data()}');
          }
          return snapshot.docs.map((doc) {
            return Schedule.fromFirestore(doc);
          }).toList();
        })
        .handleError((error) {
          print('❌ Erreur emploi du temps: $error');
          return <Schedule>[];
        });
  }

  // 5. Documents de l'étudiant
  Stream<List<Map<String, dynamic>>> getStudentDocuments() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('documents')
        .where('studentId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? '',
              'description': data['description'] ?? '',
            };
          }).toList();
        })
        .handleError((error) {
          print('Erreur récupération documents: $error');
          return <Map<String, dynamic>>[];
        });
  }

  // 6. Statistiques étudiant (simplifié)
  Future<StudentStats?> getStudentStats() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final stats = data['stats'] as Map<String, dynamic>? ?? {};
        return StudentStats.fromFirestore(stats);
      }
      return null;
    } catch (e) {
      print('Erreur récupération stats: $e');
      return null;
    }
  }

  // 7. Favoris
  Stream<List<String>> getFavoritesStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore.collection('users').doc(user.uid).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return List<String>.from(data['favorites'] ?? []);
      }
      return [];
    });
  }

  // 8. Profil utilisateur
  Stream<UserProfile?> getUserProfileStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return UserProfile.fromFirestore(snapshot);
          }
          return null;
        })
        .handleError((error) {
          print('Erreur récupération profil: $error');
          return null;
        });
  }
}
