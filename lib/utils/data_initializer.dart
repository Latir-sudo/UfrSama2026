// utils/data_initializer.dart - VERSION COMPLÈTE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataInitializer {
  static Future<void> initializeAllCollections(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage(context, "Connectez-vous d'abord");
      return;
    }

    try {
      // 1. Collections de base (déjà créées)
      await _createArticles(FirebaseFirestore.instance, user.uid);
      await _createEvents(FirebaseFirestore.instance, user.uid);
      await _createResults(FirebaseFirestore.instance, user.uid);
      await _createSchedules(FirebaseFirestore.instance, user.uid);
      await _createDocuments(FirebaseFirestore.instance, user.uid);

      // 2. NOUVELLES collections
      await _createExams(FirebaseFirestore.instance, user.uid);
      await _createRequests(FirebaseFirestore.instance, user.uid);
      await _createNews(FirebaseFirestore.instance, user.uid);
      await _createCourses(FirebaseFirestore.instance, user.uid);

      _showMessage(
        context,
        "Toutes les collections créées avec succès!",
        isError: false,
      );
    } catch (e) {
      _showMessage(context, "Erreur: $e");
    }
  }

  // ========== NOUVELLES MÉTHODES POUR LES COLLECTIONS SUPPLÉMENTAIRES ==========

  // 6. COLLECTION 'exams' - Examens à venir
  static Future<void> _createExams(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final exams = [
      {
        'courseId': 'INF301',
        'courseName': 'Algorithmique',
        'examType': 'final',
        'title': 'Examen final d\'Algorithmique',
        'date': Timestamp.fromDate(DateTime(2024, 1, 15, 8, 0)),
        'startTime': '08:00',
        'endTime': '10:00',
        'duration': '2h',
        'location': 'Amphi B',
        'room': 'Amphi B',
        'promotion': 'L3 Informatique',
        'group': 'Tous',
        'materialsAllowed': 'Calculatrice non programmable',
        'instructions': 'Apportez votre carte d\'étudiant',
        'status': 'scheduled',
        'isPublished': true,
        'createdAt': Timestamp.now(),
        'createdBy': userId,
      },
      {
        'courseId': 'MAT201',
        'courseName': 'Mathématiques',
        'examType': 'midterm',
        'title': 'Contrôle continu Mathématiques',
        'date': Timestamp.fromDate(DateTime(2024, 1, 18, 14, 0)),
        'startTime': '14:00',
        'endTime': '16:00',
        'duration': '2h',
        'location': 'Salle Fs12',
        'room': 'Fs12',
        'promotion': 'L3 Informatique',
        'group': 'Groupe A',
        'materialsAllowed': 'Aucun matériel autorisé',
        'instructions': 'Exercices sur feuille double',
        'status': 'scheduled',
        'isPublished': true,
        'createdAt': Timestamp.now(),
        'createdBy': userId,
      },
    ];

    final batch = firestore.batch();
    for (var exam in exams) {
      final docRef = firestore.collection('exams').doc();
      batch.set(docRef, exam);
    }
    await batch.commit();
  }

  // 7. COLLECTION 'requests' - Demandes administratives
  static Future<void> _createRequests(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final requests = [
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'requestType': 'diploma',
        'title': 'Demande de diplôme de Licence',
        'description': 'Diplôme de Licence en Informatique',
        'requestDate': Timestamp.now(),
        'estimatedCompletion': '15 jours',
        'status': 'pending',
        'statusMessage': 'En cours de traitement',
        'assignedTo': 'admin_001',
        'priority': 'normal',
        'trackingNumber': 'REQ202400123',
        'messages': [
          {
            'sender': 'student',
            'message': 'Bonjour, je souhaite recevoir mon diplôme de licence.',
            'timestamp': Timestamp.now(),
            'read': true,
          },
          {
            'sender': 'admin',
            'message': 'Votre demande a bien été reçue. Traitement en cours.',
            'timestamp': Timestamp.now(),
            'read': false,
          },
        ],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'requestType': 'transcript',
        'title': 'Demande de relevé de notes officiel',
        'description': 'Relevé de notes des 3 années de licence',
        'requestDate': Timestamp.fromDate(DateTime(2024, 1, 5)),
        'estimatedCompletion': '7 jours',
        'status': 'in_progress',
        'statusMessage': 'Génération du document en cours',
        'assignedTo': 'admin_002',
        'priority': 'normal',
        'trackingNumber': 'REQ202400124',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    final batch = firestore.batch();
    for (var request in requests) {
      final docRef = firestore.collection('requests').doc();
      batch.set(docRef, request);
    }
    await batch.commit();
  }

  // 8. COLLECTION 'news' - Actualités universitaires
  static Future<void> _createNews(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final news = [
      {
        'title': 'Inscriptions administratives',
        'content':
            'Les inscriptions pour le semestre de printemps débuteront le 15 Janvier 2024. Tous les étudiants doivent régulariser leur situation avant le 31 Janvier.',
        'excerpt': 'Les inscriptions débutent bientôt...',
        'category': 'academic',
        'author': 'Service administratif',
        'authorId': 'admin_001',
        'publishDate': Timestamp.now(),
        'targetAudience': 'all',
        'allowedRoles': ['student', 'teacher', 'admin'],
        'views': 150,
        'likes': 25,
        'commentsCount': 8,
        'status': 'published',
        'isFeatured': true,
        'isPinned': true,
        'tags': ['inscription', 'administration', 'semestre'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Journée portes ouvertes 2024',
        'content':
            'L\'UFR organise sa journée portes ouvertes le 25 Février 2024. Venez découvrir nos formations en Informatique, Mathématiques et Physique.',
        'excerpt': 'Découvrez nos formations lors des portes ouvertes',
        'category': 'event',
        'author': 'Service communication',
        'authorId': 'admin_002',
        'publishDate': Timestamp.fromDate(DateTime(2024, 1, 10)),
        'targetAudience': 'all',
        'views': 89,
        'likes': 15,
        'status': 'published',
        'isFeatured': true,
        'tags': ['portes_ouvertes', 'événement', 'orientation'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'title': 'Maintenance système - Week-end du 20-21 Janvier',
        'content':
            'Le système informatique de l\'UFR sera en maintenance du 20 Janvier 20h au 21 Janvier 8h. L\'accès à la plateforme sera interrompu durant cette période.',
        'excerpt': 'Maintenance système prévue ce week-end',
        'category': 'general',
        'author': 'Service informatique',
        'authorId': 'admin_003',
        'publishDate': Timestamp.fromDate(DateTime(2024, 1, 15)),
        'targetAudience': 'all',
        'views': 203,
        'likes': 12,
        'status': 'published',
        'isPinned': true,
        'tags': ['maintenance', 'système', 'information'],
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    final batch = firestore.batch();
    for (var item in news) {
      final docRef = firestore.collection('news').doc();
      batch.set(docRef, item);
    }
    await batch.commit();
  }

  // 9. COLLECTION 'courses' - Cours/Unités d'Enseignement
  static Future<void> _createCourses(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final courses = [
      {
        'courseId': 'INF301',
        'name': 'Algorithmique',
        'description':
            'Introduction à l\'algorithmique et structures de données',
        'credits': 6,
        'semester': 'S5',
        'year': '2023-2024',
        'teachers': ['teacher_001', 'teacher_002'],
        'teacherNames': ['Dr. Dupont', 'Dr. Martin'],
        'schedule': [
          {'day': 'Lundi', 'time': '10h-12h', 'room': 'Fs12', 'type': 'Cours'},
          {'day': 'Mercredi', 'time': '14h-16h', 'room': 'Fs05', 'type': 'TD'},
        ],
        'department': 'Informatique',
        'level': 'L3',
        'isActive': true,
        'syllabusUrl': 'https://example.com/syllabus/inf301.pdf',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'courseId': 'MAT201',
        'name': 'Mathématiques pour l\'informatique',
        'description':
            'Algèbre linéaire, analyse et probabilités appliquées à l\'informatique',
        'credits': 6,
        'semester': 'S5',
        'year': '2023-2024',
        'teachers': ['teacher_003'],
        'teacherNames': ['Dr. Leroy'],
        'schedule': [
          {
            'day': 'Mardi',
            'time': '8h-10h',
            'room': 'Amphi A',
            'type': 'Cours',
          },
          {'day': 'Jeudi', 'time': '10h-12h', 'room': 'Fs08', 'type': 'TD'},
        ],
        'department': 'Mathématiques',
        'level': 'L3',
        'isActive': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
      {
        'courseId': 'DEV401',
        'name': 'Développement Mobile',
        'description':
            'Développement d\'applications mobiles avec Flutter et React Native',
        'credits': 4,
        'semester': 'S6',
        'year': '2023-2024',
        'teachers': ['teacher_004'],
        'teacherNames': ['Dr. Sanchez'],
        'schedule': [
          {
            'day': 'Vendredi',
            'time': '13h-16h',
            'room': 'Labo Info 3',
            'type': 'TP',
          },
        ],
        'department': 'Informatique',
        'level': 'L3',
        'isActive': true,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    ];

    final batch = firestore.batch();
    for (var course in courses) {
      final docRef = firestore
          .collection('courses')
          .doc(course['courseId'] as String);
      batch.set(docRef, course);
    }
    await batch.commit();
  }

  // ========== MÉTHODES EXISTANTES (À GARDER) ==========

  static Future<void> _createArticles(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final articles = [
      {
        'title': 'Algorithmique et programmation',
        'author': 'Jean-Michel Doudoux',
        'category': 'Informatique',
        'type': 'PDF',
        'downloads': 245,
        'rating': 4.8,
        'publishDate': Timestamp.now(),
        'description':
            'Un livre complet sur l\'algorithmique et la programmation en Java',
        'createdAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'public',
      },
      {
        'title': 'Mathématiques pour l\'informatique',
        'author': 'Pierre Arnoux',
        'category': 'Mathématiques',
        'type': 'PDF',
        'downloads': 189,
        'rating': 4.6,
        'publishDate': Timestamp.fromDate(DateTime(2023, 10, 15)),
        'description': 'Cours de mathématiques appliquées à l\'informatique',
        'createdAt': Timestamp.now(),
        'createdBy': userId,
        'status': 'published',
        'accessLevel': 'students_only',
      },
    ];

    final batch = firestore.batch();
    for (var article in articles) {
      final docRef = firestore.collection('articles').doc();
      batch.set(docRef, article);
    }
    await batch.commit();
  }

  static Future<void> _createEvents(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final events = [
      {
        'title': 'Session de Tutorat de Mathématiques',
        'description':
            'Session de révision pour préparer l\'examen de fin de semestre. Apportez vos exercices!',
        'date': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
        'duration': '14H-16h',
        'location': 'salle fs13',
        'organizer': 'Club Informatique CI',
        'organizerId': userId,
        'category': 'Tutorat',
        'status': 'upcoming',
        'maxParticipants': 50,
        'currentParticipants': 25,
        'participants': [userId],
        'createdAt': Timestamp.now(),
        'createdBy': userId,
      },
      {
        'title': 'Masterclass en Intelligence Artificielle',
        'description':
            'CI présente une masterclass en intelligence artificielle, venez nombreux accompagné de vos amis passionés en IA et en science de données',
        'date': Timestamp.fromDate(DateTime.now().add(Duration(days: 14))),
        'duration': '20h-23h',
        'location': 'CCOS',
        'organizer': 'Club Informatique CI',
        'organizerId': userId,
        'category': 'Conférence',
        'status': 'upcoming',
        'maxParticipants': 100,
        'currentParticipants': 60,
        'participants': [userId],
        'createdAt': Timestamp.now(),
        'createdBy': userId,
      },
    ];

    final batch = firestore.batch();
    for (var event in events) {
      final docRef = firestore.collection('events').doc();
      batch.set(docRef, event);
    }
    await batch.commit();
  }

  static Future<void> _createResults(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final results = [
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'courseName': 'Algorithmique',
        'grade': 15.0,
        'status': 'validated',
        'semester': 'S5',
        'academicYear': '2023-2024',
        'examDate': Timestamp.fromDate(DateTime(2024, 1, 15)),
        'publishedDate': Timestamp.now(),
        'isPublished': true,
        'createdAt': Timestamp.now(),
      },
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'courseName': 'Mathématique',
        'grade': 12.0,
        'status': 'validated',
        'semester': 'S5',
        'academicYear': '2023-2024',
        'examDate': Timestamp.fromDate(DateTime(2024, 1, 18)),
        'publishedDate': Timestamp.now(),
        'isPublished': true,
        'createdAt': Timestamp.now(),
      },
    ];

    final batch = firestore.batch();
    for (var result in results) {
      final docRef = firestore.collection('results').doc();
      batch.set(docRef, result);
    }
    await batch.commit();
  }

  static Future<void> _createSchedules(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final schedules = [
      {
        'studentId': userId,
        'day': 'Lundi',
        'course': 'Algorithmique',
        'time': '10h-12h',
        'room': 'Fs12',
        'type': 'Cours',
        'teacher': 'Dr. Dupont',
        'weekStart': '2024-12-04',
        'createdAt': Timestamp.now(),
      },
      {
        'studentId': userId,
        'day': 'Mardi',
        'course': 'Dev Web',
        'time': '08H-10H',
        'room': 'Fs02',
        'type': 'TD',
        'teacher': 'Dr. Martin',
        'weekStart': '2024-12-04',
        'createdAt': Timestamp.now(),
      },
    ];

    final batch = firestore.batch();
    for (var schedule in schedules) {
      final docRef = firestore.collection('schedules').doc();
      batch.set(docRef, schedule);
    }
    await batch.commit();
  }

  static Future<void> _createDocuments(
    FirebaseFirestore firestore,
    String userId,
  ) async {
    final documents = [
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'title': 'Attestation de scolarité 2023-2024',
        'description': 'Document certifiant votre inscription',
        'type': 'attestation',
        'fileType': 'PDF',
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': true,
        'canDownload': true,
        'createdBy': userId,
      },
      {
        'studentId': userId,
        'studentName': 'Mamadou Badji',
        'title': 'Relevé de notes Semestre 1',
        'description': 'Document officiel des notes du semestre 1',
        'type': 'transcript',
        'fileType': 'PDF',
        'issueDate': Timestamp.now(),
        'uploadDate': Timestamp.now(),
        'status': 'available',
        'isOfficial': true,
        'canDownload': true,
        'createdBy': userId,
      },
    ];

    final batch = firestore.batch();
    for (var doc in documents) {
      final docRef = firestore.collection('documents').doc();
      batch.set(docRef, doc);
    }
    await batch.commit();
  }

  static void _showMessage(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }
}
