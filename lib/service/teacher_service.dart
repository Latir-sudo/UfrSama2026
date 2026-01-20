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

      print('✅ Cours professeur reçus: ${snapshot.docs.length}');
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
      print('❌ Erreur récupération cours: $e');
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

      print('✅ Notes récues pour cours $courseId: ${snapshot.docs.length}');
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
      print('❌ Erreur récupération notes: $e');
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

      print('✅ Ressources pédagogiques reçues: ${snapshot.docs.length}');
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
      print('❌ Erreur récupération ressources: $e');
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
          print('❌ Erreur flux cours: $e');
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
          print('❌ Erreur flux requêtes étudiants: $e');
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
          (snapshot) => snapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'studentName': doc['studentName'] ?? 'Sans nom',
                  'studentId': doc['studentId'] ?? '',
                  'grade': doc['grade'],
                  'status': doc['status'] ?? 'N/A',
                },
              )
              .toList(),
        );
  }

  // Update student grade
  Future<void> updateStudentGrade(String resultId, double newGrade) async {
    try {
      await _firestore.collection('results').doc(resultId).update({
        'grade': newGrade,
        'status': 'Validé',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Note mise à jour: $resultId -> $newGrade');
    } catch (e) {
      print('❌ Erreur mise à jour note: $e');
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
      print('❌ Erreur stats professeur: $e');
      return {
        'totalCourses': 0,
        'totalGradesSubmitted': 0,
        'averageStudentsPerCourse': 0,
      };
    }
  }

  // Get teacher profile information
  Future<Map<String, dynamic>> getTeacherProfile() async {
    try {
      final userId = currentUserId;
      if (userId == null) return {};

      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return {
          'firstName': doc['firstName'] ?? 'Enseignant',
          'lastName': doc['lastName'] ?? '',
          'email': doc['email'] ?? '',
          'department': doc['department'] ?? '',
          'phone': doc['phone'] ?? '',
          'profileImage': doc['profileImage'] ?? '',
        };
      }
      return {
        'firstName': 'Enseignant',
        'lastName': '',
        'email': _auth.currentUser?.email ?? '',
      };
    } catch (e) {
      print('❌ Erreur récupération profil: $e');
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
            return {
              'firstName': doc['firstName'] ?? 'Enseignant',
              'lastName': doc['lastName'] ?? '',
              'email': doc['email'] ?? '',
              'department': doc['department'] ?? '',
              'phone': doc['phone'] ?? '',
              'profileImage': doc['profileImage'] ?? '',
            };
          }
          return {
            'firstName': 'Enseignant',
            'lastName': '',
            'email': _auth.currentUser?.email ?? '',
          };
        })
        .handleError((e) {
          print('❌ Erreur flux profil: $e');
          return {'firstName': 'Enseignant', 'lastName': '', 'email': ''};
        });
  }
}
