import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final TeacherService _teacherService;
  late Stream<List<Map<String, dynamic>>> _coursesStream;

  @override
  void initState() {
    super.initState();
    _teacherService = TeacherService();
    _coursesStream = _teacherService.getTeacherCoursesStream();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saisie des notes
          const Text(
            'Saisie des notes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Affichage des cours pour la saisie des notes
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _coursesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _TabNoteVide();
              }

              final courses = snapshot.data!;
              return _TabNote(courses: courses);
            },
          ),
          const SizedBox(height: 32),
          // Notes déjà saisies
          const Text(
            'Notes déjà saisies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _noteSaisi(),
        ],
      ),
    );
  }
}

Widget _TabNote({required List<Map<String, dynamic>> courses}) {
  // Afficher le premier cours disponible
  final firstCourse = courses.isNotEmpty ? courses.first : null;

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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: Colors.green.shade700, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                firstCourse != null
                    ? '${firstCourse['name'] ?? 'Cours'} - ${firstCourse['level'] ?? 'N/A'}'
                    : 'Aucun cours',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Table header
        Row(
          children: [
            Expanded(flex: 2, child: _enteteTab('Cours')),
            Expanded(child: _enteteTab('Code')),
            Expanded(child: _enteteTab('Étudiants')),
          ],
        ),
        const Divider(height: 24),
        // Table rows
        ...courses.take(3).map((course) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      course['name'] ?? 'Sans nom',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
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
                ],
              ),
              const Divider(height: 12),
            ],
          );
        }),
      ],
    ),
  );
}

Widget _TabNoteVide() {
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

Widget _noteSaisi() {
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
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: Colors.green.shade700,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Exemple de note déjà saisie',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Notes publiées',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
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
      color: const Color.fromARGB(255, 46, 43, 43),
    ),
  );
}
