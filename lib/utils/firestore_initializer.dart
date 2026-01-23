import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Script d'initialisation complète de Firestore

class FirestoreInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String TAG = ' FirestoreInit';

  /// Initialiser toutes les collections
  Future<void> initializeAllCollections() async {
    try {
      print('$TAG: Démarrage de l\'initialisation des collections...');

      // Création forcée d'un admin par défaut pour la connexion si besoin
      await _createDefaultAdmin();

      // Créer les utilisateurs de base
      await _initializeUsers();

      // Créer les enseignants de base
      await _initializeTeachers();

      // Créer les départements
      await _initializeDepartments();

      // Créer les formations
      await _initializeCourses();

      // Créer les articles
      await _initializeArticles();

      // Créer les événements
      await _initializeEvents();

      // Créer les résultats pour l'utilisateur actuel
      await _initializeResults();

      // Créer les calendriers/emplois de temps
      await _initializeSchedules();

      // Créer les documents officiels
      await _initializeDocuments();

      // Créer les examens
      await _initializeExams();

      // Créer les demandes
      await _initializeRequests();

      // Créer les actualités
      await _initializeNews();

      // Créer les notifications
      await _initializeNotifications();

      // Ajouter des favoris par défaut pour l'utilisateur actuel
      await _initializeFavorites();

      // Créer les données spécifiques aux enseignants
      await _initializeTeacherData();

      print('$TAG:  Initialisation complète réussie!');
    } catch (e) {
      print('$TAG:  Erreur lors de l\'initialisation: $e');
    }
  }

  Future<void> _createDefaultAdmin() async {
    try {
      final String adminEmail = 'admin_user@uadb.edu.sn';
      final String adminPass = 'AdminPass123';

      // Vérifier si l'admin existe déjà dans Firestore
      final adminSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: adminEmail)
          .limit(1)
          .get();

      if (adminSnapshot.docs.isEmpty) {
        print('$TAG: Création de l\'admin par défaut dans Firebase Auth...');
        try {
          // Tenter de créer l'utilisateur dans Firebase Auth
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: adminEmail,
            password: adminPass,
          );

          if (userCredential.user != null) {
            // Créer le profil dans Firestore
            await _firestore.collection('users').doc(userCredential.user!.uid).set({
              'name': 'Admin User',
              'email': adminEmail,
              'role': 'admin',
              'status': 'Active',
              'createdAt': FieldValue.serverTimestamp(),
            });
            print('$TAG: ✅ Admin créé avec succès!');
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            print('$TAG: ⏭️ L\'email admin est déjà utilisé dans Auth');
            // Si l'utilisateur existe dans Auth mais pas dans Firestore (cas rare), on pourrait le recréer dans Firestore ici
          } else {
            print('$TAG: ❌ Erreur Auth lors de la création de l\'admin: ${e.message}');
          }
        }
      } else {
        print('$TAG: ⏭️ L\'admin par défaut existe déjà dans Firestore');
      }
    } catch (e) {
      print('$TAG: ❌ Erreur lors de la création de l\'admin par défaut: $e');
    }
  }

  /// Initialiser la collection des départements
  Future<void> _initializeDepartments() async {
    try {
      print('$TAG: Initialisation des départements...');
      final batch = _firestore.batch();
      final departmentsRef = _firestore.collection('departements');

      // Vérifier si les départements existent déjà
      final existing = await departmentsRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG: ⏭️  Les départements existent déjà');
        return;
      }

      // Créer les départements de base
      List<Map<String, dynamic>> departments = [
        {
          'name': 'Informatique',
          'code': 'INFO',
          'description':
              'Département d\'Informatique et de Science des Données',
          'responsable': 'Pr. Maissa Mbaye',
          'email': 'informatique@uadb.edu.sn',
          'telephone': '+221 33 864 99 99',
          'logo': 'assets/images/info.png',
          'etudiants': 450,
          'enseignants': 25,
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Mathématiques',
          'code': 'MATH',
          'description': 'Département de Mathématiques et Physique',
          'responsable': 'Pr. Moussa Diallo',
          'email': 'mathematiques@uadb.edu.sn',
          'telephone': '+221 33 864 99 98',
          'logo': 'assets/images/math.png',
          'etudiants': 380,
          'enseignants': 20,
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Sciences de la Vie',
          'code': 'SVT',
          'description': 'Département de Biologie et de Sciences de la Vie',
          'responsable': 'Dr. Aïta Sow',
          'email': 'biologie@uadb.edu.sn',
          'telephone': '+221 33 864 99 97',
          'logo': 'assets/images/svt.png',
          'etudiants': 320,
          'enseignants': 18,
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Chimie',
          'code': 'CHIM',
          'description': 'Département de Chimie et de Génie Chimique',
          'responsable': 'Pr. Samba Ba',
          'email': 'chimie@uadb.edu.sn',
          'telephone': '+221 33 864 99 96',
          'logo': 'assets/images/chimie.png',
          'etudiants': 280,
          'enseignants': 15,
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var department in departments) {
        final docRef = departmentsRef.doc();
        batch.set(docRef, department);
      }

      await batch.commit();
      print('$TAG: ✅ ${departments.length} départements créés');
    } catch (e) {
      print('$TAG: ❌ Erreur initialisation départements: $e');
    }
  }

  /// Initialiser la collection des utilisateurs
  Future<void> _initializeUsers() async {
    try {
      print('$TAG: Initialisation des utilisateurs...');
      final batch = _firestore.batch();
      final usersRef = _firestore.collection('users');

      // Vérifier si les utilisateurs existent déjà
      final existingUsers = await usersRef.limit(1).get();
      if (existingUsers.docs.isNotEmpty) {
        print('$TAG:   Les utilisateurs existent déjà');
        return;
      }

      // Créer des utilisateurs de test
      List<Map<String, dynamic>> users = [
        {
          'name': 'Mama Seck',
          'email': 'mama.seck@uadb.edu.sn',
          'role': 'etudiant',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Pr. Maissa Mbaye',
          'email': 'maissa.mbaye@uadb.edu.sn',
          'role': 'enseignant',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Admin Sama UFR',
          'email': 'admin@uadb.edu.sn',
          'role': 'admin',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Fatou Sarr',
          'email': 'adminfatou@gmail.com',
          'role': 'admin',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },

        {
          'name': 'Fatou Sarr',
          'email': 'fatou.sarr@uadb.edu.sn',
          'role': 'etudiant',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Karim Ndiaye',
          'email': 'karim.ndiaye@uadb.edu.sn',
          'role': 'etudiant',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var user in users) {
        final docRef = usersRef.doc();
        batch.set(docRef, user);
      }

      await batch.commit();
      print('$TAG:  ${users.length} utilisateurs créés');
    } catch (e) {
      print('$TAG:  Erreur initialisation utilisateurs: $e');
    }
  }

  /// Initialiser les enseignants
  Future<void> _initializeTeachers() async {
    try {
      print('$TAG: Initialisation des enseignants...');
      final batch = _firestore.batch();
      final usersRef = _firestore.collection('users');

      // On vérifie s'il y a déjà des enseignants
      final existingTeachers = await usersRef
          .where('role', isEqualTo: 'enseignant')
          .limit(1)
          .get();
      if (existingTeachers.docs.isNotEmpty) {
        print('$TAG: Des enseignants existent déjà');
        return;
      }

      // Note : Dans un environnement réel, on créerait ces utilisateurs via Firebase Auth.
      // Pour ce test, on définit un mot de passe par défaut "Passer123" pour tous les comptes.
      List<Map<String, dynamic>> teachers = [
        {
          'firstName': 'Maissa',
          'lastName': 'Mbaye',
          'email': 'maissa.mbaye@uadb.edu.sn',
          'password': 'Passer123', // Information indicative pour l'utilisateur
          'role': 'enseignant',
          'department': 'Informatique',
          'phone': '771234567',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'firstName': 'Ibrahima',
          'lastName': 'Fall',
          'email': 'ibrahima.fall@uadb.edu.sn',
          'password': 'Passer123', // Information indicative pour l'utilisateur
          'role': 'enseignant',
          'department': 'Mathématiques',
          'phone': '772345678',
          'status': 'Active',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var teacher in teachers) {
        final docRef = usersRef.doc();
        batch.set(docRef, teacher);
      }

      await batch.commit();
      print(
<<<<<<< HEAD
        '$TAG: ✅ ${teachers.length} enseignants créés (Mot de passe par défaut: Passer123)',
=======
        '$TAG:  ${teachers.length} enseignants créés (Mot de passe par défaut: Passer123)',
>>>>>>> c8fe6792b9ca757d37ccf66a58fc1a405a9fd84c
      );
    } catch (e) {
      print('$TAG:  Erreur initialisation enseignants: $e');
    }
  }

  /// Initialiser la collection des formations
  Future<void> _initializeCourses() async {
    try {
      print('$TAG: Initialisation des formations...');
      final batch = _firestore.batch();
      final coursesRef = _firestore.collection('courses');

      final existing = await coursesRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:  Les formations existent déjà');
        return;
      }

      List<Map<String, dynamic>> courses = [
        {
          'name': 'Licence Informatique',
          'code': 'LIC-INF-001',
          'ufr': 'UFR SAT',
          'level': 'L1, L2, L3',
          'studentCount': 150,
          'status': 'Active',
          'description': 'Formation complète en informatique',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Licence Mathématiques',
          'code': 'LIC-MATH-001',
          'ufr': 'UFR SAT',
          'level': 'L1, L2, L3',
          'studentCount': 120,
          'status': 'Active',
          'description': 'Programme en mathématiques pures et appliquées',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Licence Physique',
          'code': 'LIC-PHY-001',
          'ufr': 'UFR SAT',
          'level': 'L1, L2, L3',
          'studentCount': 100,
          'status': 'Active',
          'description': 'Études avancées en physique',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Master Ingénierie Informatique',
          'code': 'MAS-INF-001',
          'ufr': 'UFR SAT',
          'level': 'M1, M2',
          'studentCount': 80,
          'status': 'Active',
          'description': 'Spécialisation en ingénierie logicielle',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var course in courses) {
        final docRef = coursesRef.doc();
        batch.set(docRef, course);
      }

      await batch.commit();
      print('$TAG:  ${courses.length} formations créées');
    } catch (e) {
      print('$TAG:  Erreur initialisation formations: $e');
    }
  }

  /// Initialiser la collection des articles
  Future<void> _initializeArticles() async {
    try {
      print('$TAG: Initialisation des articles...');
      final batch = _firestore.batch();
      final articlesRef = _firestore.collection('articles');

      final existing = await articlesRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:   Les articles existent déjà');
        return;
      }

      List<Map<String, dynamic>> articles = [
        {
          'title': 'Nouvelles modalités de candidature',
          'content':
              'Les modalités de candidature pour la rentrée prochaine ont été mises à jour. Veuillez consulter le portail pour plus de détails.',
          'category': 'Actualités',
          'publishDate': FieldValue.serverTimestamp(),
          'author': 'Admin Sama UFR',
          'views': 245,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Guide de l\'étudiant',
          'content':
              'Découvrez le guide complet de l\'étudiant avec tous les ressources utiles.',
          'category': 'Guide',
          'publishDate': FieldValue.serverTimestamp(),
          'author': 'Support Académique',
          'views': 567,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Orientation académique',
          'content':
              'Des sessions d\'orientation sont organisées pour aider les nouveaux étudiants.',
          'category': 'Orientation',
          'publishDate': FieldValue.serverTimestamp(),
          'author': 'Bureau de l\'Orientation',
          'views': 321,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var article in articles) {
        final docRef = articlesRef.doc();
        batch.set(docRef, article);
      }

      await batch.commit();
      print('$TAG:  ${articles.length} articles créés');
    } catch (e) {
      print('$TAG:  Erreur initialisation articles: $e');
    }
  }

  /// Initialiser la collection des événements
  Future<void> _initializeEvents() async {
    try {
      print('$TAG: Initialisation des événements...');
      final batch = _firestore.batch();
      final eventsRef = _firestore.collection('events');

      final existing = await eventsRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:   Les événements existent déjà');
        return;
      }

      final now = DateTime.now();
      List<Map<String, dynamic>> events = [
        {
          'title': 'Journée portes ouvertes',
          'description': 'Visite campus et rencontre avec enseignants',
          'date': now.add(Duration(days: 7)),
          'location': 'Campus principal',
          'category': 'Campus',
          'attendees': 150,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Conférence sur l\'IA',
          'description':
              'Conférencier invité discutera des dernières tendances en IA',
          'date': now.add(Duration(days: 14)),
          'location': 'Amphi A',
          'category': 'Académique',
          'attendees': 200,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Forum de l\'emploi',
          'description': 'Rencontrez les entreprises partenaires',
          'date': now.add(Duration(days: 21)),
          'location': 'Espace étudiant',
          'category': 'Carrière',
          'attendees': 300,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var event in events) {
        final docRef = eventsRef.doc();
        batch.set(docRef, event);
      }

      await batch.commit();
      print('$TAG:  ${events.length} événements créés');
    } catch (e) {
      print('$TAG:  Erreur initialisation événements: $e');
    }
  }

  /// Initialiser les résultats d'examen
  Future<void> _initializeResults() async {
    try {
      print('$TAG: Initialisation des résultats...');
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print('$TAG:   Pas d\'utilisateur connecté, résultats non créés');
        return;
      }

      final batch = _firestore.batch();
      final resultsRef = _firestore.collection('results');

      // Supprimer les anciens résultats de cet utilisateur
      final oldResults = await resultsRef
          .where('studentId', isEqualTo: userId)
          .get();
      for (var doc in oldResults.docs) {
        batch.delete(doc.reference);
      }

      List<Map<String, dynamic>> results = [
        {
          'studentId': userId,
          'courseName': 'Structures de Données',
          'grade': 16.5,
          'status': 'Validé',
          'credits': 3,
          'date': DateTime.now().subtract(Duration(days: 30)),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'courseName': 'Programmation Orientée Objet',
          'grade': 17.0,
          'status': 'Validé',
          'credits': 4,
          'date': DateTime.now().subtract(Duration(days: 25)),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'courseName': 'Bases de Données',
          'grade': 15.5,
          'status': 'Validé',
          'credits': 3,
          'date': DateTime.now().subtract(Duration(days: 20)),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'courseName': 'Calcul Scientifique',
          'grade': 14.0,
          'status': 'Validé',
          'credits': 2,
          'date': DateTime.now().subtract(Duration(days: 15)),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'courseName': 'Algorithmes Avancés',
          'grade': 18.0,
          'status': 'Validé',
          'credits': 4,
          'date': DateTime.now().subtract(Duration(days: 10)),
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var result in results) {
        final docRef = resultsRef.doc();
        batch.set(docRef, result);
      }

      await batch.commit();
      print(
        '$TAG:  ${results.length} résultats créés pour utilisateur $userId',
      );
    } catch (e) {
      print('$TAG:  Erreur initialisation résultats: $e');
    }
  }

  /// Initialiser l'emploi du temps
  Future<void> _initializeSchedules() async {
    try {
      print('$TAG: Initialisation de l\'emploi du temps...');
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print(
          '$TAG:   Pas d\'utilisateur connecté, emploi du temps non créé',
        );
        return;
      }

      final batch = _firestore.batch();
      final schedulesRef = _firestore.collection('schedules');

      // Supprimer les anciens emplois du temps
      final oldSchedules = await schedulesRef
          .where('studentId', isEqualTo: userId)
          .get();
      for (var doc in oldSchedules.docs) {
        batch.delete(doc.reference);
      }

      final weekStart = DateTime.now();
      final mondayDate = weekStart.subtract(
        Duration(days: weekStart.weekday - 1),
      );

      List<Map<String, dynamic>> schedules = [
        {
          'studentId': userId,
          'course': 'Structures de Données',
          'day': 'Monday',
          'time': '08:00 - 10:00',
          'room': 'Room 101',
          'professor': 'Dr. Ahmed',
          'weekStart':
              '${mondayDate.year}-${mondayDate.month.toString().padLeft(2, '0')}-${mondayDate.day.toString().padLeft(2, '0')}',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'course': 'Programmation Orientée Objet',
          'day': 'Tuesday',
          'time': '10:00 - 12:00',
          'room': 'Room 102',
          'professor': 'Pr. Mbaye',
          'weekStart':
              '${mondayDate.year}-${mondayDate.month.toString().padLeft(2, '0')}-${mondayDate.day.toString().padLeft(2, '0')}',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'course': 'Bases de Données',
          'day': 'Wednesday',
          'time': '14:00 - 16:00',
          'room': 'Lab 201',
          'professor': 'Dr. Sow',
          'weekStart':
              '${mondayDate.year}-${mondayDate.month.toString().padLeft(2, '0')}-${mondayDate.day.toString().padLeft(2, '0')}',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'course': 'Algorithmes',
          'day': 'Thursday',
          'time': '09:00 - 11:00',
          'room': 'Room 105',
          'professor': 'Pr. Fall',
          'weekStart':
              '${mondayDate.year}-${mondayDate.month.toString().padLeft(2, '0')}-${mondayDate.day.toString().padLeft(2, '0')}',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentId': userId,
          'course': 'Calcul Scientifique',
          'day': 'Friday',
          'time': '10:00 - 12:00',
          'room': 'Room 110',
          'professor': 'Dr. Kane',
          'weekStart':
              '${mondayDate.year}-${mondayDate.month.toString().padLeft(2, '0')}-${mondayDate.day.toString().padLeft(2, '0')}',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var schedule in schedules) {
        final docRef = schedulesRef.doc();
        batch.set(docRef, schedule);
      }

      await batch.commit();
      print(
        '$TAG:  ${schedules.length} créneaux créés pour utilisateur $userId',
      );
    } catch (e) {
      print('$TAG:  Erreur initialisation emploi du temps: $e');
    }
  }

  /// Initialiser les documents officiels
  Future<void> _initializeDocuments() async {
    try {
      print('$TAG: Initialisation des documents...');
      final batch = _firestore.batch();
      final docsRef = _firestore.collection('documents');

      final existing = await docsRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:   Les documents existent déjà');
        return;
      }

      List<Map<String, dynamic>> documents = [
        {
          'title': 'Règlement académique',
          'type': 'PDF',
          'size': 1024,
          'uploadDate': DateTime.now().subtract(Duration(days: 60)),
          'uploadedBy': 'admin@uadb.edu.sn',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Guide de la vie étudiante',
          'type': 'PDF',
          'size': 2048,
          'uploadDate': DateTime.now().subtract(Duration(days: 45)),
          'uploadedBy': 'admin@uadb.edu.sn',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Charte de l\'université',
          'type': 'PDF',
          'size': 512,
          'uploadDate': DateTime.now().subtract(Duration(days: 30)),
          'uploadedBy': 'admin@uadb.edu.sn',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var doc in documents) {
        final docRef = docsRef.doc();
        batch.set(docRef, doc);
      }

      await batch.commit();
      print('$TAG:  ${documents.length} documents créés');
    } catch (e) {
      print('$TAG:  Erreur initialisation documents: $e');
    }
  }

  /// Initialiser les examens
  Future<void> _initializeExams() async {
    try {
      print('$TAG: Initialisation des examens...');
      final batch = _firestore.batch();
      final examsRef = _firestore.collection('exams');

      final existing = await examsRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:   Les examens existent déjà');
        return;
      }

      final now = DateTime.now();
      List<Map<String, dynamic>> exams = [
        {
          'course': 'Structures de Données',
          'date': now.add(Duration(days: 7)),
          'time': '09:00 - 11:00',
          'location': 'Amphi A',
          'duration': 120,
          'coefficient': 2,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'course': 'Programmation Orientée Objet',
          'date': now.add(Duration(days: 9)),
          'time': '14:00 - 16:00',
          'location': 'Amphi B',
          'duration': 120,
          'coefficient': 2,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'course': 'Bases de Données',
          'date': now.add(Duration(days: 12)),
          'time': '10:00 - 12:00',
          'location': 'Amphi C',
          'duration': 120,
          'coefficient': 2,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var exam in exams) {
        final docRef = examsRef.doc();
        batch.set(docRef, exam);
      }

      await batch.commit();
      print('$TAG:  ${exams.length} examens créés');
    } catch (e) {
      print('$TAG:  Erreur initialisation examens: $e');
    }
  }

  /// Initialiser les demandes
  Future<void> _initializeRequests() async {
    try {
      print('$TAG: Initialisation des demandes...');
      final batch = _firestore.batch();
      final requestsRef = _firestore.collection('requests');

      final existing = await requestsRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:   Les demandes existent déjà');
        return;
      }

      List<Map<String, dynamic>> requests = [
        {
          'studentName': 'Mama Seck',
          'type': 'Attestation de scolarité',
          'description': 'Demande d\'attestation pour bourse',
          'status': 'Approuvé',
          'requestDate': DateTime.now().subtract(Duration(days: 5)),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentName': 'Fatou Sarr',
          'type': 'Certificat de résultats',
          'description': 'Certificat de résultats pour emploi',
          'status': 'En cours',
          'requestDate': DateTime.now().subtract(Duration(days: 2)),
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'studentName': 'Karim Ndiaye',
          'type': 'Demande de report',
          'description': 'Report d\'examen pour raison médicale',
          'status': 'Approuvé',
          'requestDate': DateTime.now().subtract(Duration(days: 1)),
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var request in requests) {
        final docRef = requestsRef.doc();
        batch.set(docRef, request);
      }

      await batch.commit();
      print('$TAG:  ${requests.length} demandes créées');
    } catch (e) {
      print('$TAG:  Erreur initialisation demandes: $e');
    }
  }

  /// Initialiser les actualités
  Future<void> _initializeNews() async {
    try {
      print('$TAG: Initialisation des actualités...');
      final batch = _firestore.batch();
      final newsRef = _firestore.collection('news');

      final existing = await newsRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        print('$TAG:   Les actualités existent déjà');
        return;
      }

      List<Map<String, dynamic>> news = [
        {
          'title': 'Nouvelle plateforme de gestion des notes',
          'content':
              'La plateforme de gestion des notes a été entièrement rénovée',
          'date': DateTime.now(),
          'priority': 'high',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Augmentation des bourses étudiantes',
          'content':
              'Les taux de bourses ont été augmentés pour cette année académique',
          'date': DateTime.now().subtract(Duration(days: 1)),
          'priority': 'medium',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'title': 'Reprise des activités sportives',
          'content': 'Les associations sportives reprennent leurs activités',
          'date': DateTime.now().subtract(Duration(days: 3)),
          'priority': 'low',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var newsItem in news) {
        final docRef = newsRef.doc();
        batch.set(docRef, newsItem);
      }

      await batch.commit();
      print('$TAG:  ${news.length} actualités créées');
    } catch (e) {
      print('$TAG:  Erreur initialisation actualités: $e');
    }
  }

  /// Initialiser les notifications
  Future<void> _initializeNotifications() async {
    try {
      print('$TAG: Initialisation des notifications...');
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print(
          '$TAG:   Pas d\'utilisateur connecté, notifications non créées',
        );
        return;
      }

      final batch = _firestore.batch();
      final notificationsRef = _firestore.collection('notifications');

      List<Map<String, dynamic>> notifications = [
        {
          'userId': userId,
          'title': 'Nouvelle note disponible',
          'message': 'Votre résultat pour Structures de Données est disponible',
          'type': 'grade',
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'userId': userId,
          'title': 'Nouvel événement',
          'message': 'Une journée portes ouvertes est programmée',
          'type': 'event',
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'userId': userId,
          'title': 'Demande approuvée',
          'message': 'Votre demande d\'attestation a été approuvée',
          'type': 'request',
          'read': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var notification in notifications) {
        final docRef = notificationsRef.doc();
        batch.set(docRef, notification);
      }

      await batch.commit();
      print(
        '$TAG:  ${notifications.length} notifications créées pour utilisateur $userId',
      );
    } catch (e) {
      print('$TAG:  Erreur initialisation notifications: $e');
    }
  }

  /// Initialiser les favoris pour l'utilisateur actuel
  Future<void> _initializeFavorites() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      print('$TAG: Initialisation des favoris pour $userId...');

      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data['favorites'] == null || (data['favorites'] as List).isEmpty) {
          await userRef.update({
            'favorites': [
              'Introduction à Flutter',
              'Programmation Dart',
              'Firebase pour Mobile',
            ],
          });
          print('$TAG: Favoris mis à jour pour $userId');
        }
      }
    } catch (e) {
      print('$TAG:  Erreur initialisation favoris: $e');
    }
  }

  /// Initialiser les données pour l'interface enseignant
  Future<void> _initializeTeacherData() async {
    try {
      print('$TAG: Initialisation des données enseignant...');
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print(
<<<<<<< HEAD
          '$TAG: ⚠️ Pas d\'utilisateur connecté pour les données enseignant',
=======
          '$TAG:  Pas d\'utilisateur connecté pour les données enseignant',
>>>>>>> c8fe6792b9ca757d37ccf66a58fc1a405a9fd84c
        );
        return;
      }

      final batch = _firestore.batch();

      // 1. Assurer que l'utilisateur actuel a le rôle enseignant pour le test si nécessaire
      // Note: On ne change pas le rôle si l'utilisateur est déjà configuré
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        batch.set(_firestore.collection('users').doc(userId), {
          'firstName': 'Professeur',
          'lastName': 'Test',
          'email': _auth.currentUser?.email ?? 'prof@uadb.edu.sn',
          'role': 'enseignant',
          'department': 'Informatique',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 2. Créer des cours assignés à cet enseignant
      final coursesRef = _firestore.collection('courses');
      final existingTeacherCourses = await coursesRef
          .where('teacherId', isEqualTo: userId)
          .limit(1)
          .get();

      if (existingTeacherCourses.docs.isEmpty) {
        List<Map<String, dynamic>> teacherCourses = [
          {
            'name': 'Développement Mobile Flutter',
            'code': 'INF301',
            'teacherId': userId,
            'level': 'L3 Informatique',
            'studentCount': 45,
            'schedule': 'Lundi 08:00 - 12:00',
            'time': '08:00',
            'date': 'Aujourd\'hui',
            'room': 'Salle fs02',
            'createdAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Génie logiciel',
            'code': 'INF311',
            'teacherId': userId,
            'level': 'L3 Informatique',
            'studentCount': 45,
            'schedule': 'Lundi 15:00 - 18:00',
            'time': '15:00',
            'date': 'Aujourd\'hui',
            'room': 'Salle fs02',
            'createdAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Architecture des Systèmes',
            'code': 'INF302',
            'teacherId': userId,
            'level': 'M1 Informatique',
            'studentCount': 30,
            'schedule': 'Mercredi 14:00 - 17:00',
            'time': '14:00',
            'date': 'Demain',
            'room': 'Amphi A',
            'createdAt': FieldValue.serverTimestamp(),
          },
        ];

        for (var course in teacherCourses) {
          final docRef = coursesRef.doc();
          batch.set(docRef, course);

          // 3. Ajouter quelques notes pour ce cours
          final resultsRef = _firestore.collection('results');
          batch.set(resultsRef.doc(), {
            'courseId': docRef.id,
            'courseName': course['name'],
            'studentName': 'Mama Seck',
            'studentId': 'student_mama_seck_001',
            'grade': 15.5,
            'assignmentGrade': 14.0,
            'examGrade': 16.0,
            'status': 'Validé',
            'createdAt': FieldValue.serverTimestamp(),
          });
          batch.set(resultsRef.doc(), {
            'courseId': docRef.id,
            'courseName': course['name'],
            'studentName': 'Fatou Sarr',
            'studentId': 'student_fatou_sarr_001',
            'grade': 14.0,
            'assignmentGrade': 12.5,
            'examGrade': 15.0,
            'status': 'Validé',
            'createdAt': FieldValue.serverTimestamp(),
          });
          batch.set(resultsRef.doc(), {
            'courseId': docRef.id,
            'courseName': course['name'],
            'studentName': 'Yacine Diop',
            'studentId': 'student_yacine_diop_001',
            'grade': 16.5,
            'assignmentGrade': 17.0,
            'examGrade': 16.0,
            'status': 'Validé',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // 4. Créer des documents pédagogiques
      final docsRef = _firestore.collection('documents');
      final existingDocs = await docsRef
          .where('uploadedBy', isEqualTo: userId)
          .limit(1)
          .get();
      if (existingDocs.docs.isEmpty) {
        batch.set(docsRef.doc(), {
          'title': 'Support de cours Flutter - Introduction',
          'type': 'PDF',
          'uploadedBy': userId,
          'uploadDate': FieldValue.serverTimestamp(),
          'courseId': 'INF301',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 5. Créer des requêtes assignées à l'enseignant
      final requestsRef = _firestore.collection('requests');
      final existingRequests = await requestsRef
          .where('assignedTo', isEqualTo: userId)
          .limit(1)
          .get();
      if (existingRequests.docs.isEmpty) {
        batch.set(requestsRef.doc(), {
          'studentName': 'Karim Ndiaye',
          'type': 'Demande de complément',
          'status': 'Pending',
          'assignedTo': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      print('$TAG:  Données enseignant initialisées pour $userId');
    } catch (e) {
      print('$TAG:  Erreur initialisation données enseignant: $e');
    }
  }
}
