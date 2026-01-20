// utils/firebase_init.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initializeTestData() async {
    // Vérifier si l'utilisateur est connecté
    final user = _auth.currentUser;
    if (user == null) {
      print("Aucun utilisateur connecté");
      return;
    }

    // 1. Créer des articles de test
    await _initializeArticles(user.uid);

    // 2. Créer des événements de test
    await _initializeEvents(user.uid);

    // 3. Créer des résultats de test
    await _initializeResults(user.uid);

    // 4. Créer un emploi du temps de test
    await _initializeSchedules(user.uid);

    // 5. Créer des documents de test
    await _initializeDocuments(user.uid);

    print("Données de test initialisées avec succès!");
  }

  Future<void> _initializeArticles(String userId) async {
    final articlesRef = _firestore.collection('articles');

    final testArticles = [
      {
        'title': 'Algorithmique et programmation',
        'author': 'Jean-Michel Doudoux',
        'category': 'Informatique',
        'type': 'PDF',
        'description':
            'Un livre complet sur l\'algorithmique et la programmation en Java',
        'downloads': 245,
        'rating': 4.8,
        'publishDate': Timestamp.now(),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'public',
        'tags': ['algorithmique', 'programmation', 'java'],
      },
      {
        'title': 'Mathématiques pour l\'informatique',
        'author': 'Pierre Arnoux',
        'category': 'Mathématiques',
        'type': 'PDF',
        'description': 'Cours de mathématiques appliquées à l\'informatique',
        'downloads': 189,
        'rating': 4.6,
        'publishDate': Timestamp.fromDate(DateTime(2023, 10, 15)),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'students_only',
        'tags': ['mathématiques', 'algèbre', 'analyse'],
      },
    ];

    for (var article in testArticles) {
      await articlesRef.add(article);
    }
  }

  Future<void> _initializeEvents(String userId) async {
    final eventsRef = _firestore.collection('events');

    final testEvents = [
      {
        'title': 'Session de Tutorat de Mathématiques',
        'description':
            'Session de révision pour préparer l\'examen de fin de semestre. Apportez vos exercices!',
        'date': Timestamp.fromDate(DateTime(2024, 12, 10, 14, 0)),
        'endDate': Timestamp.fromDate(DateTime(2024, 12, 10, 16, 0)),
        'duration': '14H-16h',
        'location': 'salle fs13',
        'organizer': 'Club Informatique CI',
        'organizerId': userId,
        'category': 'Tutorat',
        'type': 'academic',
        'maxParticipants': 50,
        'currentParticipants': 25,
        'participants': [userId],
        'status': 'upcoming',
        'isFeatured': false,
        'registrationRequired': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
      },
    ];

    for (var event in testEvents) {
      await eventsRef.add(event);
    }
  }

  Future<void> _initializeResults(String userId) async {
    final resultsRef = _firestore.collection('results');

    final testResults = [
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'courseId': 'INF301',
        'courseName': 'Algorithmique',
        'grade': 15.0,
        'gradeLetter': 'B',
        'credits': 6,
        'semester': 'S5',
        'academicYear': '2023-2024',
        'status': 'validated',
        'session': 'first',
        'examDate': Timestamp.fromDate(DateTime(2024, 1, 15)),
        'publishedDate': Timestamp.now(),
        'coefficient': 2,
        'gradeComment': 'Très bon travail',
        'isPublished': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
      },
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'courseId': 'MAT201',
        'courseName': 'Mathématiques',
        'grade': 12.0,
        'gradeLetter': 'C',
        'credits': 6,
        'semester': 'S5',
        'academicYear': '2023-2024',
        'status': 'validated',
        'session': 'first',
        'examDate': Timestamp.fromDate(DateTime(2024, 1, 18)),
        'publishedDate': Timestamp.now(),
        'coefficient': 2,
        'gradeComment': 'Bon travail',
        'isPublished': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': userId,
      },
    ];

    for (var result in testResults) {
      await resultsRef.add(result);
    }
  }

  Future<void> _initializeSchedules(String userId) async {
    final schedulesRef = _firestore.collection('schedules');

    final testSchedules = [
      {
        'studentId': userId,
        'groupId': 'G1',
        'promotion': 'L3 Informatique',
        'weekStart': '2024-12-04',
        'weekEnd': '2024-12-10',
        'day': 'Lundi',
        'startTime': '10:00',
        'endTime': '12:00',
        'courseId': 'INF301',
        'courseName': 'Algorithmique',
        'type': 'Cours',
        'room': 'Fs12',
        'teacher': 'Dr. Dupont',
        'teacherId': 'teacher123',
        'isCancelled': false,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'studentId': userId,
        'groupId': 'G1',
        'promotion': 'L3 Informatique',
        'weekStart': '2024-12-04',
        'weekEnd': '2024-12-10',
        'day': 'Mardi',
        'startTime': '08:00',
        'endTime': '10:00',
        'courseId': 'DEV401',
        'courseName': 'Développement Web',
        'type': 'TD',
        'room': 'Fs02',
        'teacher': 'Dr. Martin',
        'teacherId': 'teacher456',
        'isCancelled': false,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    for (var schedule in testSchedules) {
      await schedulesRef.add(schedule);
    }
  }

  Future<void> _initializeDocuments(String userId) async {
    final documentsRef = _firestore.collection('documents');

    final testDocuments = [
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'title': 'Attestation de scolarité 2023-2024',
        'description': 'Document certifiant votre inscription',
        'type': 'attestation',
        'fileType': 'PDF',
        'fileSize': 1024,
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': true,
        'canDownload': true,
        'createdBy': userId,
        'downloadCount': 3,
        'lastDownload': Timestamp.now(),
      },
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'title': 'Relevé de notes Semestre 1',
        'description': 'Document officiel des notes du semestre 1',
        'type': 'transcript',
        'fileType': 'PDF',
        'fileSize': 512,
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': true,
        'canDownload': true,
        'createdBy': userId,
        'downloadCount': 1,
        'lastDownload': Timestamp.now(),
      },
    ];

    for (var doc in testDocuments) {
      await documentsRef.add(doc);
    }
  }
}
