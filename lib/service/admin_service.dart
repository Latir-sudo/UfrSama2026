import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get users statistics
  Future<Map<String, dynamic>> getUsersStatistics() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final teachersSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'enseignant')
          .get();
      final studentsSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'etudiant')
          .get();

      return {
        'totalUsers': usersSnapshot.docs.length,
        'teachers': teachersSnapshot.docs.length,
        'students': studentsSnapshot.docs.length,
      };
    } catch (e) {
      print(' Erreur stats utilisateurs: $e');
      return {'totalUsers': 0, 'teachers': 0, 'students': 0};
    }
  }

  // Get formations
  Future<List<Map<String, dynamic>>> getFormations() async {
    try {
      final snapshot = await _firestore.collection('courses').limit(20).get();
<<<<<<< HEAD
      print('✅ Formations reçues: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? data['title'] ?? 'Sans nom',
          'ufr':
              data['ufr'] ??
              data['faculty'] ??
              data['department'] ??
              'Sans UFR',
          'level': data['level'] ?? data['niveau'] ?? 'N/A',
          'studentCount': data['studentCount'] ?? data['studentNumber'] ?? 0,
          'status': data['status'] ?? 'Active',
        };
      }).toList();
=======
      print(' Formations reçues: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'name': doc['name'] ?? 'Sans nom',
              'ufr': doc['ufr'] ?? 'Sans UFR',
              'level': doc['level'] ?? 'N/A',
              'studentCount': doc['studentCount'] ?? 0,
              'status': doc['status'] ?? 'Active',
            },
          )
          .toList();
>>>>>>> c8fe6792b9ca757d37ccf66a58fc1a405a9fd84c
    } catch (e) {
      print(' Erreur récupération formations: $e');
      return [];
    }
  }

  // Get users list
  Future<List<Map<String, dynamic>>> getUsersList() async {
    try {
      final snapshot = await _firestore.collection('users').limit(50).get();
<<<<<<< HEAD
      print('✅ Utilisateurs reçus: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        final fullName = '$firstName $lastName'.trim();

        return {
          'id': doc.id,
          'firstName': firstName,
          'lastName': lastName,
          'fullName': fullName.isNotEmpty ? fullName : 'Sans nom',
          'email': data['email'] ?? 'Sans email',
          'role': data['role'] ?? 'etudiant',
          'status': data['status'] ?? 'Active',
        };
      }).toList();
=======
      print(' Utilisateurs reçus: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'name': doc['name'] ?? 'Sans nom',
              'email': doc['email'] ?? 'Sans email',
              'role': doc['role'] ?? 'etudiant',
              'status': doc['status'] ?? 'Active',
            },
          )
          .toList();
>>>>>>> c8fe6792b9ca757d37ccf66a58fc1a405a9fd84c
    } catch (e) {
      print(' Erreur récupération utilisateurs: $e');
      return [];
    }
  }

  // Get official documents
  Future<List<Map<String, dynamic>>> getOfficialDocuments() async {
    try {
      final snapshot = await _firestore.collection('documents').limit(30).get();
<<<<<<< HEAD
      print('✅ Documents officiels reçus: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? 'Sans titre',
          'type': data['type'] ?? data['documentType'] ?? 'PDF',
          'uploadDate': data['uploadDate']?.toString() ?? '',
          'size': data['size'] ?? 0,
        };
      }).toList();
=======
      print(' Documents officiels reçus: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
            (doc) => {
              'id': doc.id,
              'title': doc['title'] ?? 'Sans titre',
              'type': doc['type'] ?? 'PDF',
              'uploadDate': doc['uploadDate']?.toString() ?? '',
              'size': doc['size'] ?? 0,
            },
          )
          .toList();
>>>>>>> c8fe6792b9ca757d37ccf66a58fc1a405a9fd84c
    } catch (e) {
      print(' Erreur récupération documents: $e');
      return [];
    }
  }

  // Get activity statistics
  Future<Map<String, dynamic>> getActivityStatistics() async {
    try {
      final documentsCount = await _firestore
          .collection('documents')
          .count()
          .get();
      final attestationsCount = await _firestore
          .collection('requests')
          .count()
          .get();

      return {
        'documentsPerMonth': documentsCount.count ?? 0,
        'attestationsPerMonth': ((attestationsCount.count ?? 0) * 0.45).toInt(),
        'diplomasPerMonth': ((attestationsCount.count ?? 0) * 0.26).toInt(),
        'satisfactionRate': '89%',
        'averageDelay': '2.3j',
      };
    } catch (e) {
      print('Erreur stats activité: $e');
      return {
        'documentsPerMonth': 342,
        'attestationsPerMonth': 156,
        'diplomasPerMonth': 45,
        'satisfactionRate': '89%',
        'averageDelay': '2.3j',
      };
    }
  }

  // Stream of users for real-time updates
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore
        .collection('users')
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final firstName = data['firstName'] ?? '';
            final lastName = data['lastName'] ?? '';
            final fullName = '$firstName $lastName'.trim();

            return {
              'id': doc.id,
              'firstName': firstName,
              'lastName': lastName,
              'fullName': fullName.isNotEmpty ? fullName : 'Sans nom',
              'email': data['email'] ?? 'Sans email',
              'role': data['role'] ?? 'etudiant',
            };
          }).toList(),
        )
        .handleError((e) {
          print('Erreur flux utilisateurs: $e');
          return [];
        });
  }

  // Stream of formations
  Stream<List<Map<String, dynamic>>> getFormationsStream() {
    return _firestore
        .collection('courses')
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'name': data['name'] ?? data['title'] ?? 'Sans nom',
              'ufr':
                  data['ufr'] ??
                  data['faculty'] ??
                  data['department'] ??
                  'Sans UFR',
              'level': data['level'] ?? data['niveau'] ?? 'N/A',
              'studentCount':
                  data['studentCount'] ?? data['studentNumber'] ?? 0,
            };
          }).toList(),
        )
        .handleError((e) {
          print('Erreur flux formations: $e');
          return [];
        });
  }

  // Stream of pending registration requests
  Stream<List<Map<String, dynamic>>> getPendingRegistrationRequests() {
    return _firestore
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final studentFirstName = data['studentFirstName'] ?? '';
            final studentLastName = data['studentLastName'] ?? '';
            final studentName = '$studentFirstName $studentLastName'.trim();

            return {
              'id': doc.id,
              'studentFirstName': studentFirstName,
              'studentLastName': studentLastName,
              'studentName': studentName.isNotEmpty ? studentName : 'Sans nom',
              'requestType': data['requestType'] ?? 'Inscription',
              'formation': data['formation'] ?? data['course'] ?? 'N/A',
              'createdAt': data['createdAt'],
              'daysPending': _calculateDaysPending(data['createdAt']),
            };
          }).toList(),
        )
        .handleError((e) {
          print('Erreur flux demandes inscription: $e');
          return [];
        });
  }

  // Stream of pending documents to validate
  Stream<List<Map<String, dynamic>>> getPendingDocuments() {
    return _firestore
        .collection('documents')
        .where('status', isEqualTo: 'pending')
        .orderBy('uploadDate', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final studentFirstName = data['studentFirstName'] ?? '';
            final studentLastName = data['studentLastName'] ?? '';
            final studentName = '$studentFirstName $studentLastName'.trim();

            return {
              'id': doc.id,
              'title': data['title'] ?? 'Sans titre',
              'type': data['type'] ?? data['documentType'] ?? 'PDF',
              'studentFirstName': studentFirstName,
              'studentLastName': studentLastName,
              'studentName': studentName.isNotEmpty ? studentName : 'Sans nom',
              'formation': data['formation'] ?? data['course'] ?? 'N/A',
              'uploadDate': data['uploadDate'],
              'daysPending': _calculateDaysPending(data['uploadDate']),
            };
          }).toList(),
        )
        .handleError((e) {
          print('Erreur flux documents en attente: $e');
          return [];
        });
  }

  // Stream of academic calendar events
  Stream<List<Map<String, dynamic>>> getAcademicCalendar() {
    return _firestore
        .collection('events')
        .orderBy('date', descending: false)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? 'Événement',
              'date': data['date'] ?? '',
              'description': data['description'] ?? '',
              'eventType':
                  data['eventType'] ??
                  data['category'] ??
                  data['type'] ??
                  'Général',
            };
          }).toList(),
        )
        .handleError((e) {
          print('Erreur flux calendrier: $e');
          return [];
        });
  }

  // Stream of system alerts
  Stream<List<Map<String, dynamic>>> getSystemAlerts() {
    return _firestore
        .collection('notifications')
        .where('type', isEqualTo: 'system')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'title': data['title'] ?? 'Alerte système',
              'message': data['message'] ?? '',
              'priority': data['priority'] ?? 'normal',
              'createdAt': data['createdAt'],
            };
          }).toList(),
        )
        .handleError((e) {
          print('Erreur flux alertes: $e');
          return [];
        });
  }

  // Helper method to calculate days pending
  int _calculateDaysPending(dynamic timestamp) {
    if (timestamp == null) return 0;
    try {
      DateTime createdDate;
      if (timestamp is Timestamp) {
        createdDate = timestamp.toDate();
      } else if (timestamp is String) {
        createdDate = DateTime.parse(timestamp);
      } else {
        return 0;
      }
      final now = DateTime.now();
      return now.difference(createdDate).inDays;
    } catch (e) {
      return 0;
    }
  }

  // Approve registration request
  Future<void> approveRegistrationRequest(String requestId) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erreur approbation demande: $e');
      rethrow;
    }
  }

  // Reject registration request
  Future<void> rejectRegistrationRequest(String requestId) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erreur rejet demande: $e');
      rethrow;
    }
  }

  // Approve document
  Future<void> approveDocument(String documentId) async {
    try {
      await _firestore.collection('documents').doc(documentId).update({
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erreur approbation document: $e');
      rethrow;
    }
  }
}
