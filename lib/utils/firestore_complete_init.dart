import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Script complet d'initialisation de toutes les collections Firestore
class FirestoreCompleteInit {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Initialise TOUTES les collections Firestore
  static Future<void> initializeAllCollections() async {
    final user = _auth.currentUser;
    if (user == null) {
      print(' Utilisateur non authentifié');
      return;
    }

    print(' Initialisation complète de Firestore pour: ${user.uid}');
    print('═' * 60);

    try {
      // Collections principales (essentielles pour l'app)
      await _initArticles(user.uid);
      await _initEvents(user.uid);
      await _initResults(user.uid);
      await _initSchedules(user.uid);
      await _initDocuments(user.uid);

      // Collections secondaires (optionnelles mais utiles)
      await _initUsers(user.uid);
      await _initExams(user.uid);
      await _initRequests(user.uid);
      await _initNews(user.uid);
      await _initCourses(user.uid);
      await _initNotifications(user.uid);

      print('═' * 60);
      print(' INITIALISATION COMPLÈTE RÉUSSIE!');
      print(' Toutes les collections ont été créées et peuplées');
    } catch (e) {
      print(' Erreur initialisation: $e');
    }
  }

  /// 1. COLLECTION 'articles' - Articles et ressources éducatives
  static Future<void> _initArticles(String userId) async {
    print('\n Initialisation des ARTICLES...');
    final articles = [
      {
        'title': 'Introduction à Flutter',
        'author': 'Dr. Marie Sall',
        'category': 'Informatique',
        'type': 'PDF',
        'description': 'Guide complet pour débuter avec Flutter',
        'downloads': 42,
        'rating': 4.5,
        'publishDate': Timestamp.fromDate(DateTime(2024, 9, 15)),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'students_only',
        'tags': ['flutter', 'mobile', 'dart'],
      },
      {
        'title': 'Algorithmes et Structures de Données',
        'author': 'Prof. Amar Diallo',
        'category': 'Informatique',
        'type': 'Word',
        'description': 'Cours fondamental sur les algorithmes',
        'downloads': 89,
        'rating': 4.8,
        'publishDate': Timestamp.fromDate(DateTime(2024, 8, 10)),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'students_only',
        'tags': ['algorithmique', 'structures', 'informatique'],
      },
      {
        'title': 'Analyse Mathématique I',
        'author': 'Prof. Ibrahima Ba',
        'category': 'Mathématiques',
        'type': 'PDF',
        'description': 'Cours d\'analyse pour niveau L1',
        'downloads': 156,
        'rating': 4.3,
        'publishDate': Timestamp.fromDate(DateTime(2024, 7, 5)),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'students_only',
        'tags': ['mathématiques', 'analyse', 'calcul'],
      },
    ];

    await _addCollectionData('articles', articles);
    print('   ${articles.length} articles ajoutés');
  }

  /// 2. COLLECTION 'events' - Événements universitaires
  static Future<void> _initEvents(String userId) async {
    print('\n Initialisation des ÉVÉNEMENTS...');
    final events = [
      {
        'title': 'Session de Tutorat Mathématiques',
        'description': 'Session de révision pour l\'examen de fin de semestre',
        'date': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
        'endDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 7, hours: 2)),
        ),
        'duration': '14:00-16:00',
        'location': 'Salle FS13',
        'organizer': 'Club Informatique CI',
        'organizerId': userId,
        'category': 'Tutorat',
        'type': 'academic',
        'status': 'upcoming',
        'maxParticipants': 50,
        'currentParticipants': 25,
        'participants': [userId],
        'registrationRequired': true,
        'isFeatured': true,
        'createdAt': Timestamp.now(),
        'createdBy': userId,
      },
      {
        'title': 'Conférence sur l\'IA',
        'description':
            'Découvrez les dernières avancées en Intelligence Artificielle',
        'date': Timestamp.fromDate(DateTime.now().add(Duration(days: 14))),
        'endDate': Timestamp.fromDate(
          DateTime.now().add(Duration(days: 14, hours: 3)),
        ),
        'duration': '10:00-13:00',
        'location': 'Amphithéâtre Principal',
        'organizer': 'Département Informatique',
        'organizerId': userId,
        'category': 'Conférence',
        'type': 'seminar',
        'status': 'upcoming',
        'maxParticipants': 200,
        'currentParticipants': 120,
        'participants': [userId],
        'registrationRequired': false,
        'isFeatured': true,
        'createdAt': Timestamp.now(),
        'createdBy': userId,
      },
    ];

    await _addCollectionData('events', events);
    print('   ${events.length} événements ajoutés');
  }

  /// 3. COLLECTION 'results' - Résultats académiques
  static Future<void> _initResults(String userId) async {
    print('\n Initialisation des RÉSULTATS...');
    final results = [
      {
        'studentId': userId,
        'courseName': 'Mathématiques',
        'grade': 15.5,
        'status': 'Valid',
        'semester': 'S1',
        'year': '2025-2026',
        'professor': 'Prof. Ibrahima Ba',
      },
      {
        'studentId': userId,
        'courseName': 'Physique',
        'grade': 14.0,
        'status': 'Valid',
        'semester': 'S1',
        'year': '2025-2026',
        'professor': 'Dr. Amadou Diop',
      },
      {
        'studentId': userId,
        'courseName': 'Chimie',
        'grade': 13.5,
        'status': 'Valid',
        'semester': 'S1',
        'year': '2025-2026',
        'professor': 'Dr. Fatou Ndiaye',
      },
      {
        'studentId': userId,
        'courseName': 'Informatique',
        'grade': 16.0,
        'status': 'Valid',
        'semester': 'S1',
        'year': '2025-2026',
        'professor': 'Prof. Amar Diallo',
      },
      {
        'studentId': userId,
        'courseName': 'Anglais',
        'grade': 12.5,
        'status': 'Valid',
        'semester': 'S1',
        'year': '2025-2026',
        'professor': 'Dr. Mariama Seck',
      },
    ];

    await _addCollectionData('results', results);
    print('   ${results.length} résultats ajoutés');
  }

  /// 4. COLLECTION 'schedules' - Emploi du temps
  static Future<void> _initSchedules(String userId) async {
    print('\n Initialisation des SCHEDULES...');
    final weekStart = _getWeekStartDate();
    final schedules = [
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Lundi',
        'course': 'Mathématiques',
        'time': '09:00 - 11:00',
        'room': 'A101',
        'professor': 'Prof. Ibrahima Ba',
        'type': 'Cours',
      },
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Lundi',
        'course': 'Physique',
        'time': '14:00 - 16:00',
        'room': 'B202',
        'professor': 'Dr. Amadou Diop',
        'type': 'TP',
      },
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Mardi',
        'course': 'Chimie',
        'time': '08:00 - 10:00',
        'room': 'C303',
        'professor': 'Dr. Fatou Ndiaye',
        'type': 'Cours',
      },
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Mardi',
        'course': 'Informatique',
        'time': '10:30 - 12:30',
        'room': 'D404',
        'professor': 'Prof. Amar Diallo',
        'type': 'TD',
      },
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Mercredi',
        'course': 'Mathématiques',
        'time': '09:00 - 11:00',
        'room': 'A101',
        'professor': 'Prof. Ibrahima Ba',
        'type': 'TD',
      },
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Jeudi',
        'course': 'Anglais',
        'time': '14:00 - 16:00',
        'room': 'E505',
        'professor': 'Dr. Mariama Seck',
        'type': 'Cours',
      },
      {
        'studentId': userId,
        'weekStart': weekStart,
        'day': 'Vendredi',
        'course': 'Informatique',
        'time': '10:30 - 12:30',
        'room': 'D404',
        'professor': 'Prof. Amar Diallo',
        'type': 'TP',
      },
    ];

    await _addCollectionData('schedules', schedules);
    print(
      '   ${schedules.length} schedules ajoutés pour la semaine du $weekStart',
    );
  }

  /// 5. COLLECTION 'documents' - Documents étudiants
  static Future<void> _initDocuments(String userId) async {
    print(' Initialisation des DOCUMENTS...');
    final documents = [
      {
        'studentId': userId,
        'title': 'Attestation de scolarité 2025-2026',
        'description': 'Document certifiant votre inscription',
        'type': 'attestation',
        'fileType': 'PDF',
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': true,
        'canDownload': true,
        'category': 'academique',
      },
      {
        'studentId': userId,
        'title': 'Relevé de notes Semestre 1',
        'description': 'Document officiel des notes',
        'type': 'transcript',
        'fileType': 'PDF',
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': true,
        'canDownload': true,
        'category': 'academique',
      },
      {
        'studentId': userId,
        'title': 'Certificat de présence',
        'description': 'Certificat de présence aux cours',
        'type': 'certificate',
        'fileType': 'PDF',
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': false,
        'canDownload': true,
        'category': 'administratif',
      },
    ];

    await _addCollectionData('documents', documents);
    print('   ${documents.length} documents ajoutés');
  }

  /// 6. COLLECTION 'users' - Profils utilisateurs
  static Future<void> _initUsers(String userId) async {
    print('\n👤 Initialisation des PROFILS UTILISATEURS...');
    final users = [
      {
        'uid': userId,
        'email': _auth.currentUser?.email ?? 'student@example.com',
        'displayName': 'Étudiant',
        'firstName': 'Jean',
        'lastName': 'Dupont',
        'role': 'student',
        'department': 'Informatique',
        'level': 'L1',
        'semester': 'S1',
        'registrationNumber': 'ST2025001',
        'phoneNumber': '+221771234567',
        'profilePhoto': '',
        'bio': 'Étudiant en Informatique',
        'joinDate': Timestamp.now(),
        'lastLogin': Timestamp.now(),
        'status': 'active',
      },
    ];

    await _addCollectionData('users', users);
    print('   ${users.length} profil utilisateur créé');
  }

  /// 7. COLLECTION 'exams' - Examens
  static Future<void> _initExams(String userId) async {
    print('\n  Initialisation des EXAMENS...');
    final exams = [
      {
        'title': 'Examen Mathématiques S1',
        'course': 'Mathématiques',
        'date': Timestamp.fromDate(DateTime.now().add(Duration(days: 30))),
        'startTime': '09:00',
        'endTime': '11:00',
        'duration': '2h',
        'location': 'Amphithéâtre Principal',
        'department': 'Informatique',
        'semester': 'S1',
        'year': '2025-2026',
        'examType': 'written',
        'maxScore': 20,
        'passingScore': 10,
        'instructions': 'Aucun document autorisé',
        'status': 'scheduled',
        'isPublished': true,
        'createdAt': Timestamp.now(),
      },
      {
        'title': 'Examen Informatique S1',
        'course': 'Informatique',
        'date': Timestamp.fromDate(DateTime.now().add(Duration(days: 35))),
        'startTime': '14:00',
        'endTime': '16:00',
        'duration': '2h',
        'location': 'Salle Informatique 1',
        'department': 'Informatique',
        'semester': 'S1',
        'year': '2025-2026',
        'examType': 'practical',
        'maxScore': 20,
        'passingScore': 10,
        'instructions': 'Calculatrice autorisée',
        'status': 'scheduled',
        'isPublished': true,
        'createdAt': Timestamp.now(),
      },
    ];

    await _addCollectionData('exams', exams);
    print('   ${exams.length} examens ajoutés');
  }

  /// 8. COLLECTION 'requests' - Demandes administratives
  static Future<void> _initRequests(String userId) async {
    print('\n Initialisation des DEMANDES ADMINISTRATIVES...');
    final requests = [
      {
        'studentId': userId,
        'requestType': 'diploma',
        'title': 'Demande de diplôme',
        'description': 'Demande de diplôme de Licence',
        'requestDate': Timestamp.now(),
        'estimatedCompletion': '15 jours',
        'status': 'pending',
        'priority': 'normal',
        'trackingNumber': 'REQ2025001',
        'assignedTo': 'admin_001',
      },
      {
        'studentId': userId,
        'requestType': 'transcript',
        'title': 'Demande de relevé de notes',
        'description': 'Relevé du semestre 1',
        'requestDate': Timestamp.now(),
        'estimatedCompletion': '5 jours',
        'status': 'in_progress',
        'priority': 'high',
        'trackingNumber': 'REQ2025002',
        'assignedTo': 'admin_002',
      },
    ];

    await _addCollectionData('requests', requests);
    print('   ${requests.length} demandes ajoutées');
  }

  /// 9. COLLECTION 'news' - Actualités universitaires
  static Future<void> _initNews(String userId) async {
    print('\n Initialisation des ACTUALITÉS...');
    final news = [
      {
        'title': 'Ouverture des inscriptions administratives',
        'content':
            'Les inscriptions pour le semestre de printemps débuteront le 15 Janvier 2026',
        'excerpt': 'Les inscriptions débutent bientôt...',
        'author': 'Direction Académique',
        'publishDate': Timestamp.now(),
        'category': 'administration',
        'targetAudience': 'all',
        'status': 'published',
        'isPinned': true,
        'views': 350,
        'likes': 25,
      },
      {
        'title': 'Maintenance système le 20 Janvier',
        'content':
            'Le portail étudiant sera indisponible de 22h à 6h pour maintenance',
        'excerpt': 'Maintenance prévue...',
        'author': 'IT Support',
        'publishDate': Timestamp.now(),
        'category': 'technique',
        'targetAudience': 'all',
        'status': 'published',
        'isPinned': false,
        'views': 200,
        'likes': 12,
      },
    ];

    await _addCollectionData('news', news);
    print('   ${news.length} actualités ajoutées');
  }

  /// 10. COLLECTION 'courses' - Cours/Unités d'enseignement
  static Future<void> _initCourses(String userId) async {
    print('\n Initialisation des COURS...');
    final courses = [
      {
        'courseId': 'INF301',
        'name': 'Algorithmique',
        'description':
            'Introduction à l\'algorithmique et structures de données',
        'credits': 6,
        'semester': 'S1',
        'year': '2025-2026',
        'department': 'Informatique',
        'professor': 'Prof. Amar Diallo',
        'professorId': userId,
        'studentsCount': 45,
        'status': 'active',
        'startDate': Timestamp.now(),
      },
      {
        'courseId': 'MAT201',
        'name': 'Mathématiques I',
        'description': 'Analyse mathématique pour informaticiens',
        'credits': 4,
        'semester': 'S1',
        'year': '2025-2026',
        'department': 'Informatique',
        'professor': 'Prof. Ibrahima Ba',
        'professorId': userId,
        'studentsCount': 50,
        'status': 'active',
        'startDate': Timestamp.now(),
      },
      {
        'courseId': 'PHY101',
        'name': 'Physique',
        'description': 'Mécanique et électricité',
        'credits': 5,
        'semester': 'S1',
        'year': '2025-2026',
        'department': 'Informatique',
        'professor': 'Dr. Amadou Diop',
        'professorId': userId,
        'studentsCount': 48,
        'status': 'active',
        'startDate': Timestamp.now(),
      },
    ];

    await _addCollectionData('courses', courses);
    print('   ${courses.length} cours ajoutés');
  }

  /// 11. COLLECTION 'notifications' - Notifications utilisateurs
  static Future<void> _initNotifications(String userId) async {
    print('\n Initialisation des NOTIFICATIONS...');
    final notifications = [
      {
        'userId': userId,
        'title': 'Bienvenue!',
        'message': 'Bienvenue sur la plateforme SAMA UFR',
        'type': 'welcome',
        'read': false,
        'createdAt': Timestamp.now(),
        'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      },
      {
        'userId': userId,
        'title': 'Nouvel article disponible',
        'message': 'Un nouvel article "Introduction à Flutter" a été publié',
        'type': 'article',
        'read': false,
        'createdAt': Timestamp.now(),
        'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      },
      {
        'userId': userId,
        'title': 'Nouvel événement',
        'message': 'Une session de tutorat est disponible',
        'type': 'event',
        'read': false,
        'createdAt': Timestamp.now(),
        'expiresAt': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
      },
    ];

    await _addCollectionData('notifications', notifications);
    print('   ${notifications.length} notifications ajoutées');
  }

  /// Fonction utilitaire pour ajouter les données d'une collection
  static Future<void> _addCollectionData(
    String collectionName,
    List<Map<String, dynamic>> items,
  ) async {
    try {
      // Supprimer les anciennes données de l'utilisateur
      final snapshot = await _firestore.collection(collectionName).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Ajouter les nouvelles données
      final batch = _firestore.batch();
      for (var item in items) {
        final docRef = _firestore.collection(collectionName).doc();
        batch.set(docRef, item);
      }
      await batch.commit();
    } catch (e) {
      print('    Erreur lors de l\'ajout à $collectionName: $e');
    }
  }

  /// Calcule la date du lundi de la semaine actuelle (format YYYY-MM-DD)
  static String _getWeekStartDate() {
    final now = DateTime.now();
    final daysToMonday = now.weekday - 1;
    final monday = now.subtract(Duration(days: daysToMonday));

    final year = monday.year;
    final month = monday.month.toString().padLeft(2, '0');
    final day = monday.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
