import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Script pour initialiser les données de test dans Firestore
class TestDataInitializer {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Ajoute les données de test (résultats et emplois du temps)
  static Future<void> initializeTestData() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('❌ Utilisateur non authentifié');
      return;
    }

    print('🚀 Initialisation des données de test pour: ${user.uid}');

    try {
      await _addTestResults(user.uid);
      await _addTestSchedules(user.uid);
      print('✅ Données de test ajoutées avec succès!');
    } catch (e) {
      print('❌ Erreur initialisation: $e');
    }
  }

  /// Ajoute des résultats de test
  static Future<void> _addTestResults(String studentId) async {
    print('📊 Ajout des résultats de test...');

    final results = [
      {
        'studentId': studentId,
        'courseName': 'Mathématiques',
        'grade': 15.5,
        'status': 'Valid',
        'semester': 'S1',
      },
      {
        'studentId': studentId,
        'courseName': 'Physique',
        'grade': 14.0,
        'status': 'Valid',
        'semester': 'S1',
      },
      {
        'studentId': studentId,
        'courseName': 'Chimie',
        'grade': 13.5,
        'status': 'Valid',
        'semester': 'S1',
      },
      {
        'studentId': studentId,
        'courseName': 'Informatique',
        'grade': 16.0,
        'status': 'Valid',
        'semester': 'S1',
      },
      {
        'studentId': studentId,
        'courseName': 'Anglais',
        'grade': 12.5,
        'status': 'Valid',
        'semester': 'S1',
      },
    ];

    // Supprimer les anciens résultats
    final oldResults = await _firestore
        .collection('results')
        .where('studentId', isEqualTo: studentId)
        .get();

    for (var doc in oldResults.docs) {
      await doc.reference.delete();
    }
    print('🗑️  Anciens résultats supprimés');

    // Ajouter les nouveaux
    for (var result in results) {
      await _firestore.collection('results').add(result);
      print('  ✅ ${result['courseName']} (${result['grade']})');
    }

    print('✅ ${results.length} résultats ajoutés');
  }

  /// Ajoute l'emploi du temps de test
  static Future<void> _addTestSchedules(String studentId) async {
    print('📅 Ajout de l\'emploi du temps de test...');

    final weekStart = _getWeekStartDate();

    final schedules = [
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Lundi',
        'course': 'Mathématiques',
        'time': '09:00 - 11:00',
        'room': 'A101',
      },
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Lundi',
        'course': 'Physique',
        'time': '14:00 - 16:00',
        'room': 'B202',
      },
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Mardi',
        'course': 'Chimie',
        'time': '08:00 - 10:00',
        'room': 'C303',
      },
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Mardi',
        'course': 'Informatique',
        'time': '10:30 - 12:30',
        'room': 'D404',
      },
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Mercredi',
        'course': 'Mathématiques',
        'time': '09:00 - 11:00',
        'room': 'A101',
      },
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Jeudi',
        'course': 'Anglais',
        'time': '14:00 - 16:00',
        'room': 'E505',
      },
      {
        'studentId': studentId,
        'weekStart': weekStart,
        'day': 'Vendredi',
        'course': 'Informatique',
        'time': '10:30 - 12:30',
        'room': 'D404',
      },
    ];

    // Supprimer les anciens schedules
    final oldSchedules = await _firestore
        .collection('schedules')
        .where('studentId', isEqualTo: studentId)
        .where('weekStart', isEqualTo: weekStart)
        .get();

    for (var doc in oldSchedules.docs) {
      await doc.reference.delete();
    }
    print('🗑️  Anciens schedules supprimés');

    // Ajouter les nouveaux
    for (var schedule in schedules) {
      await _firestore.collection('schedules').add(schedule);
      print(
        '  ✅ ${schedule['day']} - ${schedule['course']} (${schedule['time']})',
      );
    }

    print(
      '✅ ${schedules.length} schedules ajoutés pour la semaine du $weekStart',
    );
  }

  /// Calcule la date du lundi de la semaine actuelle (format YYYY-MM-DD)
  static String _getWeekStartDate() {
    final now = DateTime.now();
    // 0 = Lundi, 1 = Mardi, ..., 6 = Dimanche
    final daysToMonday = now.weekday - 1;
    final monday = now.subtract(Duration(days: daysToMonday));

    final year = monday.year;
    final month = monday.month.toString().padLeft(2, '0');
    final day = monday.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
