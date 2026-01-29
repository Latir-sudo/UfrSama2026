import 'package:flutter/material.dart';
import 'package:sama_ufr/EtuPage/models.dart';
import 'package:sama_ufr/service/student_service.dart';
import 'package:sama_ufr/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Page détaillée pour les événements
class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(event.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPurpleBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Header avec gradient
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/livre.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Contenu
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Informations principales avec cartes
                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: "Date",
                    value: _formatDate(event.date),
                    color: AppColors.accent,
                  ),
                  SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.schedule,
                    label: "Durée",
                    value: event.duration,
                    color: AppColors.warning,
                  ),
                  SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.location_on,
                    label: "Lieu",
                    value: event.location,
                    color: AppColors.success,
                  ),
                  SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.person,
                    label: "Organisateur",
                    value: event.organizer,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.category,
                    label: "Catégorie",
                    value: event.category,
                    color: AppColors.danger,
                  ),
                  SizedBox(height: 24),

                  // Description
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      border: Border(
                        left: BorderSide(color: AppColors.accent, width: 4),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightText,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Bouton d'inscription avec gradient
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.gradientPurpleBlue,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Inscription à "${event.title}" réussie! ✓',
                              ),
                              backgroundColor: AppColors.success,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'S\'inscrire à l\'événement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Page pour les résultats
class ResultsPage extends StatelessWidget {
  final List<CourseResult> results;

  const ResultsPage({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Mes Résultats',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientGreenTurquoise,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // : Implémenter le filtrage
            },
          ),
        ],
      ),
      body: results.isEmpty ? _buildEmptyState() : _buildResultsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.school_outlined,
              size: 64,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun résultat disponible',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos résultats apparaîtront ici une fois publiés',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    // Calculer les statistiques
    final validResults = results
        .where((r) => r.status.toLowerCase() == 'valid')
        .toList();
    final average = validResults.isNotEmpty
        ? validResults.map((r) => r.grade).reduce((a, b) => a + b) /
              validResults.length
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistiques générales
          _buildStatisticsCard(average, validResults.length, results.length),
          const SizedBox(height: 24),

          // Titre des résultats
          Text(
            'Détail des résultats',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Liste des résultats
          ...results.map((result) => _buildResultCard(result)),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(double average, int validCount, int totalCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientGreenTurquoise,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Moyenne',
            '${average.toStringAsFixed(1)}/20',
            Icons.grade,
          ),
          Container(height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
          _buildStatItem(
            'Validés',
            '$validCount/$totalCount',
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(CourseResult result) {
    final grade = result.grade;
    final isValid = result.status.toLowerCase() == 'valid';

    // Déterminer la couleur basée sur la note
    Color gradeColor;
    Color backgroundColor;
    IconData gradeIcon;
    String gradeText;

    if (grade >= 16) {
      gradeColor = const Color(0xFF4CAF50); // Vert
      backgroundColor = const Color(0xFFE8F5E8);
      gradeIcon = Icons.star;
      gradeText = 'Excellent';
    } else if (grade >= 14) {
      gradeColor = const Color(0xFF2196F3); // Bleu
      backgroundColor = const Color(0xFFE3F2FD);
      gradeIcon = Icons.thumb_up;
      gradeText = 'Très bien';
    } else if (grade >= 12) {
      gradeColor = const Color(0xFF009688); // Turquoise
      backgroundColor = const Color(0xFFE0F2F1);
      gradeIcon = Icons.check_circle;
      gradeText = 'Bien';
    } else if (grade >= 10) {
      gradeColor = const Color(0xFFFF9800); // Orange
      backgroundColor = const Color(0xFFFFF3E0);
      gradeIcon = Icons.warning;
      gradeText = 'Passable';
    } else {
      gradeColor = const Color(0xFFF44336); // Rouge
      backgroundColor = const Color(0xFFFFEBEE);
      gradeIcon = Icons.error;
      gradeText = 'Insuffisant';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icône du cours
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCourseIcon(result.courseName),
                    color: gradeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Informations du cours
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.courseName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isValid ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          result.status,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isValid
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: gradeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: gradeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    grade.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barre de progression et appréciation
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gradeText,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: gradeColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: grade / 20,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(gradeColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(gradeIcon, color: gradeColor, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCourseIcon(String courseName) {
    final name = courseName.toLowerCase();
    if (name.contains('math') || name.contains('algèbre')) {
      return Icons.calculate;
    } else if (name.contains('physique')) {
      return Icons.science;
    } else if (name.contains('info') || name.contains('programmation')) {
      return Icons.computer;
    } else if (name.contains('anglais') || name.contains('langue')) {
      return Icons.language;
    } else if (name.contains('base') || name.contains('donnée')) {
      return Icons.storage;
    } else {
      return Icons.school;
    }
  }
}

/// Page pour l'emploi du temps
class SchedulePage extends StatelessWidget {
  final List<Schedule> schedules;

  const SchedulePage({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mon Emploi du Temps'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientNavyBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: schedules.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 80, color: AppColors.lightText),
                  SizedBox(height: 16),
                  Text(
                    'Aucun cours cette semaine',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.lightText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: schedules.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final schedule = schedules[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              schedule.day,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(schedule.time),
                              backgroundColor: Color(0xFF3498DB),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          schedule.course,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Salle: ${schedule.room}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// Page pour les réclamations et demandes de documents
class DocumentsPage extends StatefulWidget {
  final StudentService studentService;
  final List<Map<String, dynamic>>? documents;

  const DocumentsPage({
    super.key,
    required this.studentService,
    this.documents,
  });

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  // Données
  List<ReclamationModel> _reclamations = [];
  List<DocumentRequestModel> _documentRequests = [];
  List<CourseModel> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Charger les réclamations de l'étudiant
      final reclamationsSnapshot = await _firestore
          .collection('reclamations')
          .where('studentId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _reclamations = reclamationsSnapshot.docs.map((doc) {
        final data = doc.data();
        return ReclamationModel(
          id: doc.id,
          studentId: data['studentId'] ?? '',
          studentName: data['studentName'] ?? '',
          courseId: data['courseId'] ?? '',
          courseName: data['courseName'] ?? '',
          type: data['type'] ?? 'exam',
          title: data['title'] ?? 'Réclamation',
          description: data['description'] ?? '',
          initialGrade: (data['initialGrade'] ?? 0).toDouble(),
          requestedGrade: (data['requestedGrade'] ?? 0).toDouble(),
          status: data['status'] ?? 'pending',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedAt:
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          attachments: List<String>.from(data['attachments'] ?? []),
          professorResponse: data['professorResponse'],
          finalGrade: (data['finalGrade'] ?? 0).toDouble(),
        );
      }).toList();

      // Charger les demandes de documents
      final documentRequestsSnapshot = await _firestore
          .collection('document_requests')
          .where('studentId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _documentRequests = documentRequestsSnapshot.docs.map((doc) {
        final data = doc.data();
        return DocumentRequestModel(
          id: doc.id,
          studentId: data['studentId'] ?? '',
          studentName: data['studentName'] ?? '',
          documentType: data['documentType'] ?? '',
          documentTitle: data['documentTitle'] ?? '',
          academicYear: data['academicYear'] ?? '',
          semester: data['semester'] ?? '',
          reason: data['reason'] ?? '',
          status: data['status'] ?? 'pending',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedAt:
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          downloadUrl: data['downloadUrl'],
          expiryDate: (data['expiryDate'] as Timestamp?)?.toDate(),
          additionalInfo: data['additionalInfo'],
        );
      }).toList();

      // Charger les cours/matières
      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('status', isEqualTo: 'Active')
          .get();

      _courses = coursesSnapshot.docs.map((doc) {
        final data = doc.data();
        return CourseModel(
          id: doc.id,
          name: data['name'] ?? '',
          code: data['code'] ?? '',
          ufr: data['ufr'] ?? '',
          level: data['level'] ?? '',
          studentCount: data['studentCount'] ?? 0,
          status: data['status'] ?? 'Active',
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitReclamation({
    required String courseId,
    required String courseName,
    required String type,
    required String title,
    required String description,
    required double initialGrade,
    required double requestedGrade,
    List<String> attachments = const [],
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      final userEmail = _auth.currentUser?.email;
      if (userId == null) return;

      // Récupérer le nom de l'étudiant
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final studentName = userDoc.data()?['name'] ?? 'Étudiant';

      await _firestore.collection('reclamations').add({
        'studentId': userId,
        'studentEmail': userEmail,
        'studentName': studentName,
        'courseId': courseId,
        'courseName': courseName,
        'type': type,
        'title': title,
        'description': description,
        'initialGrade': initialGrade,
        'requestedGrade': requestedGrade,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'attachments': attachments,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Réclamation soumise avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );

      await _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la soumission: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _submitDocumentRequest({
    required String documentType,
    required String documentTitle,
    required String academicYear,
    required String semester,
    required String reason,
    String additionalInfo = '',
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      final userEmail = _auth.currentUser?.email;
      if (userId == null) return;

      // Récupérer le nom de l'étudiant
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final studentName = userDoc.data()?['name'] ?? 'Étudiant';

      await _firestore.collection('document_requests').add({
        'studentId': userId,
        'studentEmail': userEmail,
        'studentName': studentName,
        'documentType': documentType,
        'documentTitle': documentTitle,
        'academicYear': academicYear,
        'semester': semester,
        'reason': reason,
        'additionalInfo': additionalInfo,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Demande de document soumise avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );

      await _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la soumission: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Widget _buildStatisticsCard() {
    final pendingReclamations = _reclamations
        .where((r) => r.status == 'pending')
        .length;
    final inProgressReclamations = _reclamations
        .where((r) => r.status == 'in_progress')
        .length;
    final resolvedReclamations = _reclamations
        .where((r) => r.status == 'resolved')
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientOrangeAmber,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'En attente',
            '$pendingReclamations',
            Icons.access_time,
            Colors.white,
          ),
          _buildDivider(),
          _buildStatItem(
            'En cours',
            '$inProgressReclamations',
            Icons.refresh,
            Colors.white,
          ),
          _buildDivider(),
          _buildStatItem(
            'Résolues',
            '$resolvedReclamations',
            Icons.check_circle,
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: color.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildReclamationCard(ReclamationModel reclamation) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (reclamation.status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusIcon = Icons.access_time;
        statusText = 'En attente';
        break;
      case 'in_progress':
        statusColor = AppColors.info;
        statusIcon = Icons.refresh;
        statusText = 'En traitement';
        break;
      case 'resolved':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = 'Résolue';
        break;
      case 'rejected':
        statusColor = AppColors.danger;
        statusIcon = Icons.cancel;
        statusText = 'Rejetée';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Inconnu';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reclamation.courseName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reclamation.type == 'exam' ? 'Examen' : 'Devoir'} • ${_dateFormat.format(reclamation.createdAt)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reclamation.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.darkText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGradeItem(
                  'Note initiale',
                  '${reclamation.initialGrade}/20',
                  AppColors.danger,
                ),
                _buildGradeItem(
                  'Note demandée',
                  '${reclamation.requestedGrade}/20',
                  AppColors.success,
                ),
                if (reclamation.finalGrade != null &&
                    reclamation.finalGrade! > 0)
                  _buildGradeItem(
                    'Note finale',
                    '${reclamation.finalGrade}/20',
                    AppColors.primary,
                  ),
              ],
            ),
            if (reclamation.professorResponse != null &&
                reclamation.professorResponse!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Réponse du professeur:',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reclamation.professorResponse!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.lightText),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentRequestCard(DocumentRequestModel request) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (request.status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusIcon = Icons.access_time;
        statusText = 'En attente';
        break;
      case 'in_progress':
        statusColor = AppColors.info;
        statusIcon = Icons.refresh;
        statusText = 'En traitement';
        break;
      case 'ready':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = 'Prêt';
        break;
      case 'rejected':
        statusColor = AppColors.danger;
        statusIcon = Icons.cancel;
        statusText = 'Rejetée';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Inconnu';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.documentTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${request.academicYear} • ${request.semester} • ${_dateFormat.format(request.createdAt)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Motif: ${request.reason}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.darkText,
              ),
            ),
            if (request.additionalInfo != null &&
                request.additionalInfo!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Informations supplémentaires: ${request.additionalInfo}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            if (request.downloadUrl != null && request.status == 'ready')
              Column(
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implémenter le téléchargement
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.download, size: 18),
                      label: Text(
                        'Télécharger le document',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showNewReclamationDialog() {
    String? selectedCourseId;
    String? selectedCourseName;
    String? selectedType;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final initialGradeController = TextEditingController();
    final requestedGradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Nouvelle réclamation',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Matière',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedCourseId,
                      items: _courses.map((course) {
                        return DropdownMenuItem(
                          value: course.id,
                          child: Text(
                            course.name,
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCourseId = value;
                          selectedCourseName = _courses
                              .firstWhere((c) => c.id == value)
                              .name;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Type d\'évaluation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedType,
                      items: [
                        DropdownMenuItem(value: 'exam', child: Text('Examen')),
                        DropdownMenuItem(
                          value: 'homework',
                          child: Text('Devoir maison'),
                        ),
                        DropdownMenuItem(
                          value: 'project',
                          child: Text('Projet'),
                        ),
                        DropdownMenuItem(value: 'oral', child: Text('Oral')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: initialGradeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Note initiale',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: requestedGradeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Note demandée',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCourseId == null ||
                        selectedType == null ||
                        titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        initialGradeController.text.isEmpty ||
                        requestedGradeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Veuillez remplir tous les champs'),
                          backgroundColor: AppColors.warning,
                        ),
                      );
                      return;
                    }

                    await _submitReclamation(
                      courseId: selectedCourseId!,
                      courseName: selectedCourseName!,
                      type: selectedType!,
                      title: titleController.text,
                      description: descriptionController.text,
                      initialGrade: double.parse(initialGradeController.text),
                      requestedGrade: double.parse(
                        requestedGradeController.text,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Soumettre'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNewDocumentRequestDialog() {
    String? selectedDocumentType;
    String? selectedAcademicYear;
    String? selectedSemester;
    final reasonController = TextEditingController();
    final additionalInfoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Nouvelle demande de document',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Type de document',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedDocumentType,
                      items: [
                        DropdownMenuItem(
                          value: 'attestation_scolarite',
                          child: Text('Attestation de scolarité'),
                        ),
                        DropdownMenuItem(
                          value: 'certificat_reussite',
                          child: Text('Certificat de réussite'),
                        ),
                        DropdownMenuItem(
                          value: 'releve_notes',
                          child: Text('Relevé de notes'),
                        ),
                        DropdownMenuItem(
                          value: 'attestation_assiduite',
                          child: Text('Attestation d\'assiduité'),
                        ),
                        DropdownMenuItem(
                          value: 'convention_stage',
                          child: Text('Convention de stage'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDocumentType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Année académique',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedAcademicYear,
                      items: [
                        DropdownMenuItem(
                          value: '2022-2023',
                          child: Text('2022-2023'),
                        ),
                        DropdownMenuItem(
                          value: '2023-2024',
                          child: Text('2023-2024'),
                        ),
                        DropdownMenuItem(
                          value: '2024-2025',
                          child: Text('2024-2025'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedAcademicYear = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Semestre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedSemester,
                      items: [
                        DropdownMenuItem(
                          value: 'S1',
                          child: Text('Semestre 1'),
                        ),
                        DropdownMenuItem(
                          value: 'S2',
                          child: Text('Semestre 2'),
                        ),
                        DropdownMenuItem(
                          value: 'Année complète',
                          child: Text('Année complète'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSemester = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        labelText: 'Motif de la demande',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: additionalInfoController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Informations complémentaires',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDocumentType == null ||
                        selectedAcademicYear == null ||
                        selectedSemester == null ||
                        reasonController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Veuillez remplir tous les champs obligatoires',
                          ),
                          backgroundColor: AppColors.warning,
                        ),
                      );
                      return;
                    }

                    final documentTitle = {
                      'attestation_scolarite': 'Attestation de scolarité',
                      'certificat_reussite': 'Certificat de réussite',
                      'releve_notes': 'Relevé de notes',
                      'attestation_assiduite': 'Attestation d\'assiduité',
                      'convention_stage': 'Convention de stage',
                    }[selectedDocumentType];

                    await _submitDocumentRequest(
                      documentType: selectedDocumentType!,
                      documentTitle: documentTitle!,
                      academicYear: selectedAcademicYear!,
                      semester: selectedSemester!,
                      reason: reasonController.text,
                      additionalInfo: additionalInfoController.text,
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Soumettre',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Réclamations & Documents',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientOrangeAmber,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.gavel), text: 'Réclamations'),
            Tab(icon: Icon(Icons.description), text: 'Documents'),
            Tab(icon: Icon(Icons.add_circle), text: 'Nouvelle'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                // Onglet 1: Réclamations
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsCard(),
                      const SizedBox(height: 24),
                      Text(
                        'Mes réclamations',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_reclamations.isEmpty)
                        _buildEmptyState(
                          icon: Icons.gavel,
                          title: 'Aucune réclamation',
                          message: 'Vous n\'avez soumis aucune réclamation',
                        )
                      else
                        ..._reclamations.map(
                          (reclamation) => _buildReclamationCard(reclamation),
                        ),
                    ],
                  ),
                ),

                // Onglet 2: Demandes de documents
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes demandes de documents',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_documentRequests.isEmpty)
                        _buildEmptyState(
                          icon: Icons.description,
                          title: 'Aucune demande',
                          message:
                              'Vous n\'avez soumis aucune demande de document',
                        )
                      else
                        ..._documentRequests.map(
                          (request) => _buildDocumentRequestCard(request),
                        ),
                    ],
                  ),
                ),

                // Onglet 3: Nouvelle demande
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Créer une nouvelle demande',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _showNewReclamationDialog,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.danger.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.gavel,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nouvelle réclamation',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Contester une note d\'examen ou de devoir',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.lightText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.danger,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _showNewDocumentRequestDialog,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.info.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.info,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.description,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Demande de document',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.info,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Attestation, certificat ou autre document administratif',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.lightText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.info,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: _tabController.index == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (_tabController.index == 0) {
                  _showNewReclamationDialog();
                } else {
                  _showNewDocumentRequestDialog();
                }
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add),
              label: Text(
                _tabController.index == 0
                    ? 'Nouvelle réclamation'
                    : 'Nouvelle demande',
              ),
            ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Modèle pour les réclamations
class ReclamationModel {
  final String id;
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseName;
  final String type; // 'exam', 'homework', 'project', 'oral'
  final String title;
  final String description;
  final double initialGrade;
  final double requestedGrade;
  final String status; // 'pending', 'in_progress', 'resolved', 'rejected'
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> attachments;
  final String? professorResponse;
  final double? finalGrade;

  ReclamationModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseName,
    required this.type,
    required this.title,
    required this.description,
    required this.initialGrade,
    required this.requestedGrade,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.attachments,
    this.professorResponse,
    this.finalGrade,
  });
}

/// Modèle pour les demandes de documents
class DocumentRequestModel {
  final String id;
  final String studentId;
  final String studentName;
  final String documentType;
  final String documentTitle;
  final String academicYear;
  final String semester;
  final String reason;
  final String status; // 'pending', 'in_progress', 'ready', 'rejected'
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? downloadUrl;
  final DateTime? expiryDate;
  final String? additionalInfo;

  DocumentRequestModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.documentType,
    required this.documentTitle,
    required this.academicYear,
    required this.semester,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.downloadUrl,
    this.expiryDate,
    this.additionalInfo,
  });
}

/// Modèle pour les cours
class CourseModel {
  final String id;
  final String name;
  final String code;
  final String ufr;
  final String level;
  final int studentCount;
  final String status;
  final String description;

  CourseModel({
    required this.id,
    required this.name,
    required this.code,
    required this.ufr,
    required this.level,
    required this.studentCount,
    required this.status,
    required this.description,
  });
}

class ResourcesPage extends StatelessWidget {
  final StudentService studentService;

  const ResourcesPage({super.key, required this.studentService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ressources'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientBlueGreen,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: studentService.getArticlesStream(category: 'Tous'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune ressource disponible'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final article = articles[index];

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        article.author,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(article.category),
                            backgroundColor: Color(0xFF3498DB),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${article.rating}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Téléchargement de "${article.title}"...',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3498DB),
                          ),
                          child: Text('Télécharger (${article.downloads})'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Widget réutilisable pour les informations
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color = const Color(0xFF3498DB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.lightText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
