import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';

class CourseStudentsPage extends StatefulWidget {
  final String courseId;
  final String courseName;

  const CourseStudentsPage({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<CourseStudentsPage> createState() => _CourseStudentsPageState();
}

class _CourseStudentsPageState extends State<CourseStudentsPage> {
  final TeacherService _teacherService = TeacherService();
  final Map<String, TextEditingController> _assignmentControllers = {};
  final Map<String, TextEditingController> _examControllers = {};

  @override
  void dispose() {
    for (var controller in _assignmentControllers.values) {
      controller.dispose();
    }
    for (var controller in _examControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitGrade(String resultId, String value, String type) async {
    final grade = double.tryParse(value.replaceAll(',', '.'));
    if (value.isEmpty || (grade != null && grade >= 0 && grade <= 20)) {
      try {
        await _teacherService.updateStudentGrade(
          resultId,
          grade,
          type: type,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Note de ${type == 'assignment' ? 'devoir' : 'examen'} mise à jour !',
              ),
              backgroundColor: Colors.blue.shade600,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir une note valide (0-20)'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _teacherService.getCourseStudentsStream(widget.courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final students = snapshot.data ?? [];

          if (students.isEmpty) {
            return const Center(
              child: Text('Aucun étudiant inscrit à ce cours.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final resultId = student['id'];

              if (!_assignmentControllers.containsKey(resultId)) {
                _assignmentControllers[resultId] = TextEditingController(
                  text: student['assignmentGrade']?.toString() ?? '',
                );
              }
              if (!_examControllers.containsKey(resultId)) {
                _examControllers[resultId] = TextEditingController(
                  text: student['examGrade']?.toString() ?? '',
                );
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Text(
                              (student['studentName'] ?? 'U')[0].toUpperCase(),
                              style: TextStyle(color: Colors.blue.shade800),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student['studentName'] ?? 'Étudiant inconnu',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'ID: ${student['studentId'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Note Devoir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _assignmentControllers[resultId],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintText: '-',
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onSubmitted: (value) => _submitGrade(
                                    resultId,
                                    value,
                                    'assignment',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Note Examen',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _examControllers[resultId],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintText: '-',
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onSubmitted: (value) => _submitGrade(
                                    resultId,
                                    value,
                                    'exam',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            _submitGrade(
                              resultId,
                              _assignmentControllers[resultId]!.text,
                              'assignment',
                            );
                            _submitGrade(
                              resultId,
                              _examControllers[resultId]!.text,
                              'exam',
                            );
                          },
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text('Enregistrer'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                          ),
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
