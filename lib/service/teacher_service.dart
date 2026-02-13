import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Get teacher's courses
  Future<List<Map<String, dynamic>>> getTeacherCourses() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('courses')
          .where('teacherId', isEqualTo: userId)
          .limit(20)
          .get();

      print(' Cours professeur reçus: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'name': doc['name'] ?? 'Sans nom',
              'code': doc['code'] ?? '',
              'level': doc['level'] ?? 'N/A',
              'studentCount': doc['studentCount'] ?? 0,
              'schedule': doc['schedule'] ?? 'A définir',
            },
          )
          .toList();
    } catch (e) {
      print(' Erreur récupération cours: $e');
      return [];
    }
  }

  // Get grades for a specific course
  Future<List<Map<String, dynamic>>> getCourseGrades(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('results')
          .where('courseId', isEqualTo: courseId)
          .limit(100)
          .get();

      print(' Notes récues pour cours $courseId: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'studentName': doc['studentName'] ?? 'Sans nom',
              'grade': doc['grade'] ?? 0,
              'status': doc['status'] ?? 'En cours',
            },
          )
          .toList();
    } catch (e) {
      print(' Erreur récupération notes: $e');
      return [];
    }
  }

  // Get teaching resources
  Future<List<Map<String, dynamic>>> getTeachingResources() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('documents')
          .where('uploadedBy', isEqualTo: userId)
          .limit(50)
          .get();

      print(' Ressources pédagogiques reçues: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'title': doc['title'] ?? 'Sans titre',
              'type': doc['type'] ?? 'PDF',
              'uploadDate': doc['uploadDate']?.toString() ?? '',
              'courseId': doc['courseId'] ?? '',
            },
          )
          .toList();
    } catch (e) {
      print(' Erreur récupération ressources: $e');
      return [];
    }
  }

  // Stream of teacher's courses (real-time)
  Stream<List<Map<String, dynamic>>> getTeacherCoursesStream() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('courses')
        .where('teacherId', isEqualTo: userId)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'name': doc['name'] ?? 'Sans nom',
                  'code': doc['code'] ?? '',
                  'studentCount': doc['studentCount'] ?? 0,
                  'time': doc['time'],
                  'date': doc['date'],
                },
              )
              .toList(),
        )
        .handleError((e) {
          print(' Erreur flux cours: $e');
          return [];
        });
  }

  // Stream of student requests for teacher
  Stream<List<Map<String, dynamic>>> getStudentRequestsStream() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('requests')
        .where('assignedTo', isEqualTo: userId)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'studentName': doc['studentName'] ?? 'Sans nom',
                  'type': doc['type'] ?? 'Demande',
                  'status': doc['status'] ?? 'Pending',
                  'createdAt': doc['createdAt']?.toString() ?? '',
                },
              )
              .toList(),
        )
        .handleError((e) {
          print(' Erreur flux requêtes étudiants: $e');
          return [];
        });
  }

  // Get students for a specific course
  Stream<List<Map<String, dynamic>>> getCourseStudentsStream(String courseId) {
    // Dans cette structure simple, on récupère les notes/résultats liés au cours
    // car chaque résultat lie un étudiant à un cours
    return _firestore
        .collection('results')
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            try {
              final data = doc.data();
              return {
                'id': doc.id,
                'studentName': data['studentName'] ?? 'Sans nom',
                'studentId': data['studentId'] ?? 'N/A',
                'grade': data['grade'],
                'assignmentGrade': data['assignmentGrade'],
                'examGrade': data['examGrade'],
                'status': data['status'] ?? 'N/A',
              };
            } catch (e) {
              print('Erreur parsing étudiant: $e');
              return {
                'id': doc.id,
                'studentName': 'Erreur',
                'studentId': 'N/A',
                'grade': null,
                'assignmentGrade': null,
                'examGrade': null,
                'status': 'N/A',
              };
            }
          }).toList(),
        );
  }

  // Update student grade
  Future<void> updateStudentGrade(
    String resultId,
    double? grade, {
    String? type,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (type == 'assignment') {
        updates['assignmentGrade'] = grade;
      } else if (type == 'exam') {
        updates['examGrade'] = grade;
      } else {
        updates['grade'] = grade;
      }

      // Optionnel: Calculer la note globale si on a les deux
      // Pour l'instant on garde la logique simple demandée par l'utilisateur

      await _firestore.collection('results').doc(resultId).update(updates);
      print('Note mise à jour ($type): $resultId -> $grade');
    } catch (e) {
      print(' Erreur mise à jour note: $e');
      rethrow;
    }
  }

  // Enroll a student to a course (create a result record)
  Future<void> enrollStudent(
    String courseId,
    String courseName,
    String studentId,
    String studentName,
  ) async {
    try {
      // Check if already enrolled
      final existing = await _firestore
          .collection('results')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection('results').add({
          'courseId': courseId,
          'courseName': courseName,
          'studentId': studentId,
          'studentName': studentName,
          'grade': null,
          'status': 'En cours',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Update studentCount in course
        await _firestore.collection('courses').doc(courseId).update({
          'studentCount': FieldValue.increment(1),
        });

        print('Étudiant $studentName inscrit au cours $courseName');
      }
    } catch (e) {
      print('Erreur inscription étudiant: $e');
      rethrow;
    }
  }

  // Get student attendance/grades statistics
  Future<Map<String, dynamic>> getTeacherStatistics() async {
    try {
      final userId = currentUserId;
      if (userId == null) return {};

      final coursesSnap = await _firestore
          .collection('courses')
          .where('teacherId', isEqualTo: userId)
          .count()
          .get();

      final gradesSnap = await _firestore
          .collection('results')
          .where('courseId', arrayContains: userId)
          .count()
          .get();

      return {
        'totalCourses': coursesSnap.count,
        'totalGradesSubmitted': gradesSnap.count,
        'averageStudentsPerCourse': 25,
      };
    } catch (e) {
      print(' Erreur stats professeur: $e');
      return {
        'totalCourses': 0,
        'totalGradesSubmitted': 0,
        'averageStudentsPerCourse': 0,
      };
    }
  }

  // Stream of teaching resources (real-time)
  Stream<List<Map<String, dynamic>>> getTeachingResourcesStream() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('documents')
        .where('uploadedBy', isEqualTo: userId)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'title': doc['title'] ?? 'Sans titre',
                  'type': doc['type'] ?? 'PDF',
                  'uploadDate': doc['uploadDate']?.toDate()?.toString() ?? '',
                  'courseId': doc['courseId'] ?? '',
                },
              )
              .toList(),
        )
        .handleError((e) {
          print('Erreur flux ressources: $e');
          return [];
        });
  }

  // Add teaching resource
  Future<void> addTeachingResource({
    required String title,
    required String type,
    required String courseId,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('Utilisateur non connecté');

      await _firestore.collection('documents').add({
        'title': title,
        'type': type,
        'courseId': courseId,
        'uploadedBy': userId,
        'uploadDate': FieldValue.serverTimestamp(),
      });
      print('Ressource ajoutée: $title');
    } catch (e) {
      print('Erreur ajout ressource: $e');
      rethrow;
    }
  }

  // Get available documents from Firestore (official documents)
  Future<List<Map<String, dynamic>>> getAvailableDocuments() async {
    try {
      final userId = currentUserId;

      final snapshot = await _firestore
          .collection('documents')
          .where('uploadedBy', isNotEqualTo: userId ?? '')
          .limit(50)
          .get();

      print(' Documents disponibles reçus: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'title': doc['title'] ?? 'Sans titre',
              'type': doc['type'] ?? 'PDF',
              'description': doc['description'] ?? '',
              'uploadDate': doc['uploadDate']?.toString() ?? '',
              'category': doc['category'] ?? 'Général',
            },
          )
          .toList();
    } catch (e) {
      print(' Erreur récupération documents disponibles: $e');
      return [];
    }
  }

  // Get teacher profile information
  Future<Map<String, dynamic>> getTeacherProfile() async {
    try {
      final userId = currentUserId;
      if (userId == null) return {};

      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        String firstName = data['firstName'] ?? '';
        String lastName = data['lastName'] ?? '';

        // Si firstName et lastName sont vides, on essaie de parser 'name'
        if (firstName.isEmpty && lastName.isEmpty && data.containsKey('name')) {
          String name = data['name'] ?? '';
          if (name.isNotEmpty) {
            List<String> parts = name.split(' ');
            if (parts.length > 1) {
              firstName = parts[0];
              lastName = parts.sublist(1).join(' ');
            } else {
              firstName = name;
            }
          }
        }

        if (firstName.isEmpty) firstName = 'Enseignant';

        return {
          'firstName': firstName,
          'lastName': lastName,
          'email': data['email'] ?? '',
          'department': data['department'] ?? '',
          'phone': data['phone'] ?? '',
          'profileImage': data['profileImage'] ?? '',
        };
      }
      return {
        'firstName': 'Enseignant',
        'lastName': '',
        'email': _auth.currentUser?.email ?? '',
      };
    } catch (e) {
      print(' Erreur récupération profil: $e');
      return {
        'firstName': 'Enseignant',
        'lastName': '',
        'email': _auth.currentUser?.email ?? '',
      };
    }
  }

  // Stream of teacher profile (real-time)
  Stream<Map<String, dynamic>> getTeacherProfileStream() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value({
        'firstName': 'Enseignant',
        'lastName': '',
        'email': '',
      });
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            String firstName = data['firstName'] ?? '';
            String lastName = data['lastName'] ?? '';

            // Si firstName et lastName sont vides, on essaie de parser 'name'
            if (firstName.isEmpty &&
                lastName.isEmpty &&
                data.containsKey('name')) {
              String name = data['name'] ?? '';
              if (name.isNotEmpty) {
                List<String> parts = name.split(' ');
                if (parts.length > 1) {
                  firstName = parts[0];
                  lastName = parts.sublist(1).join(' ');
                } else {
                  firstName = name;
                }
              }
            }

            if (firstName.isEmpty) firstName = 'Enseignant';

            return {
              'firstName': firstName,
              'lastName': lastName,
              'email': data['email'] ?? '',
              'department': data['department'] ?? '',
              'phone': data['phone'] ?? '',
              'profileImage': data['profileImage'] ?? '',
            };
          }
          return {
            'firstName': 'Enseignant',
            'lastName': '',
            'email': _auth.currentUser?.email ?? '',
          };
        })
        .handleError((e) {
          print(' Erreur flux profil: $e');
          return {'firstName': 'Enseignant', 'lastName': '', 'email': ''};
        });
  }
}
