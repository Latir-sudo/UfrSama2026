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
              
              return Column(
                children: [
                  _TabNote(
                    courses: courses, 
                    onCourseSelected: (id, name) {
                      setState(() {
                        _selectedCourseId = id;
                        _selectedCourseName = name;
                      });
                    },
                    selectedCourseId: _selectedCourseId,
                  ),
                  if (_selectedCourseId != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Étudiants - $_selectedCourseName',
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
              final TextEditingController controller = TextEditingController(
                text: student['grade']?.toString() ?? '',
              );

              return ListTile(
                title: Text(student['studentName'] ?? 'Étudiant'),
                subtitle: Text('Statut: ${student['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: '--',
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save, color: Colors.blue),
                      onPressed: () async {
                        final grade = double.tryParse(controller.text);
                        if (grade != null) {
                          try {
                            await _teacherService.updateStudentGrade(
                              student['id'],
                              grade,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Note enregistrée !')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _TabNote({
  required List<Map<String, dynamic>> courses,
  required Function(String, String) onCourseSelected,
  String? selectedCourseId,
}) {
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
            const Expanded(
              child: Text(
                'Sélectionnez un cours pour saisir les notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
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
            Expanded(child: _enteteTab('Action')),
          ],
        ),
        const Divider(height: 24),
        // Table rows
        ...courses.map((course) {
          final bool isSelected = selectedCourseId == course['id'];
          return Column(
            children: [
              InkWell(
                onTap: () => onCourseSelected(course['id'], course['name']),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        course['name'] ?? 'Sans nom',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.blue : Colors.black87,
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isSelected ? 'Sélectionné' : 'Saisir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 12),
            ],
          );
        }).toList(),
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
