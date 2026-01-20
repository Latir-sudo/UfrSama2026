import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';

class CoursPage extends StatefulWidget {
  const CoursPage({super.key});

  @override
  State<CoursPage> createState() => _CoursPageState();
}

class _CoursPageState extends State<CoursPage> {
  late final TeacherService _teacherService;
  late Stream<List<Map<String, dynamic>>> _coursesStream;
  String? _selectedCourseId;
  String? _selectedCourseName;

  @override
  void initState() {
    super.initState();
    _teacherService = TeacherService();
    _coursesStream = _teacherService.getTeacherCoursesStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Mes cours
            const Text(
              'Mes cours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Tableau dynamique des cours
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _coursesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _TableauVide();
                }

                final courses = snapshot.data!;
                return Column(
                  children: [
                    _Tableau(
                      courses: courses,
                      onCourseTap: (id, name) {
                        setState(() {
                          if (_selectedCourseId == id) {
                            _selectedCourseId = null;
                            _selectedCourseName = null;
                          } else {
                            _selectedCourseId = id;
                            _selectedCourseName = name;
                          }
                        });
                      },
                    ),
                    if (_selectedCourseId != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Liste des étudiants - $_selectedCourseName',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStudentsList(_selectedCourseId!),
                    ],
                  ],
                );
              },
            ),
            // Planning des cours
            const SizedBox(height: 16),
            const Text(
              'Planning des cours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _ProchainsCours(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsList(String courseId) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _teacherService.getCourseStudentsStream(courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Aucun étudiant inscrit à ce cours.'),
            ),
          );
        }

        final students = snapshot.data!;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    student['studentName']?[0] ?? 'E',
                    style: TextStyle(color: Colors.blue.shade800),
                  ),
                ),
                title: Text(student['studentName'] ?? 'Étudiant'),
                trailing: Text(
                  'Note: ${student['grade'] ?? 'N/A'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _ProchainsCours() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 197, 41, 202),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                color: const Color.fromARGB(255, 252, 250, 253),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Semaine du 4 Décembre',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _HeureCours('Lundi-', ' Algorithmique (L2 Info)'),
        _HeureCours(
          '10h-12h.',
          'Amphi A . Chapitre 4: Complxite algorithmique',
        ),
        const SizedBox(height: 16),
        _HeureCours('Mardi -', ' Base de donnees (L1 Info)'),
        _HeureCours('14h-16h. ', ' Salle 204 . TP: Requetes SQL avancees'),
        const SizedBox(height: 16),
        _HeureCours('Jeudi-', ' Resaux (L3 Info)'),
        _HeureCours('10h-12h. ', ' Labo Info . Protocoles de routage'),
      ],
    ),
  );
}

Widget _HeureCours(String time, String cours) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Wrap(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              cours,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _Tableau({
  required List<Map<String, dynamic>> courses,
  required Function(String, String) onCourseTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 248, 248, 249),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.assignment, color: Colors.blue.shade700, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Cours assignés (Cliquez pour voir les étudiants)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Table header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: _enteteTab('Matière')),
              Expanded(child: _enteteTab('Code')),
              Expanded(child: _enteteTab('Étudiants')),
              Expanded(child: _enteteTab('Niveau')),
            ],
          ),
        ),
        // Table rows
        ...courses.map((course) {
          return InkWell(
            onTap: () => onCourseTap(course['id'], course['name']),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      course['name'] ?? 'Sans nom',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 140, 133, 133),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      course['code'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${course['studentCount'] ?? 0}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      course['level'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}

/// Tableau vide en cas de pas de données
Widget _TableauVide() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Aucun cours assigné',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}

// Fonction pour construire un en-tête de tableau
Widget _enteteTab(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}
