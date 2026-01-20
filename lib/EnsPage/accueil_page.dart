import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';

class AccueilPage extends StatefulWidget {
  final TeacherService teacherService;
  final Function(int)? onTabChange;

  const AccueilPage({super.key, required this.teacherService, this.onTabChange});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  late Stream<List<Map<String, dynamic>>> coursesStream;
  late Stream<List<Map<String, dynamic>>> requestsStream;

  @override
  void initState() {
    super.initState();
    coursesStream = widget.teacherService.getTeacherCoursesStream();
    requestsStream = widget.teacherService.getStudentRequestsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Tableau de bord",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1); // Index pour "Cours"
                      }
                    },
                    child: carte(
                      titre: "Mes cours",
                      icon: Icons.menu_book,
                      couleur: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(2); // Index pour "Notes"
                      }
                    },
                    child: carte(
                      titre: "Saisie des notes",
                      icon: Icons.edit,
                      couleur: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // On peut imaginer ouvrir l'onglet Planifier si existant
                      // Pour l'instant on affiche un message ou on redirige vers Cours
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1); 
                      }
                    },
                    child: carte(
                      titre: "Planifier un cours",
                      icon: Icons.calendar_today,
                      couleur: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(3); // Index pour "Ressources"
                      }
                    },
                    child: carte(
                      titre: "Déposer ressources",
                      icon: Icons.upload,
                      couleur: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1); // Index pour "Cours"
                      }
                    },
                    child: carte(
                      titre: "Liste étudiants",
                      icon: Icons.group,
                      couleur: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Action pour Messagerie si nécessaire, ou laisser tel quel
                    },
                    child: carte(
                      titre: "Messagerie",
                      icon: Icons.message,
                      couleur: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Prochains cours",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // Affichage dynamique des prochains cours
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: coursesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                      child: const Center(
                        child: Text(
                          'Aucun cours disponible',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final courses = snapshot.data!.take(3).toList();
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
                        ...courses.map((course) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course['name'] ?? 'Cours sans nom',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Code: ${course['code'] ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${course['studentCount'] ?? 0} étudiants',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        if (course['time'] != null)
                                          Text(
                                            'Horaire: ${course['time']} (${course['date'] ?? ''})',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.book,
                                    color: Colors.blue.withOpacity(0.6),
                                    size: 28,
                                  ),
                                ],
                              ),
                              if (courses.indexOf(course) < courses.length - 1)
                                Divider(
                                  color: Colors.grey.withOpacity(0.2),
                                  thickness: 1,
                                  height: 24,
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Alertes et notifications",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Affichage dynamique des requêtes étudiantes
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: requestsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return AlertCard(
                      icon: Icons.notifications_off,
                      iconColor: Colors.grey,
                      title: 'Aucune notification',
                      description:
                          'Vous n\'avez pas de notification en ce moment',
                      time: 'À jour',
                    );
                  }

                  final requests = snapshot.data!.take(2).toList();
                  return Column(
                    children: [
                      ...requests.asMap().entries.map((entry) {
                        int index = entry.key;
                        var request = entry.value;

                        return Column(
                          children: [
                            AlertCard(
                              icon: Icons.pending_actions,
                              iconColor: const Color.fromARGB(255, 212, 34, 22),
                              title: request['type'] ?? 'Demande',
                              description:
                                  '${request['studentName'] ?? 'Étudiant'} - Statut: ${request['status'] ?? 'En attente'}',
                              time:
                                  request['createdAt']?.toString().split(
                                    ' ',
                                  )[0] ??
                                  'Récemment',
                            ),
                            if (index < requests.length - 1)
                              const SizedBox(height: 12),
                          ],
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // les cartes du tableau de bord
  Widget carte({
    required String titre,
    required IconData icon,
    required Color couleur,
  }) {
    return SizedBox(
      width: 118,
      height: 100,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: couleur),
            const SizedBox(height: 8),
            Text(
              titre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //prochains cours

  Widget ProchainsCours() {
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
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Aujourd\'hui',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          HeureCours('10h00 - 12h00', 'Cours d\'Algorithmique - L2 Info'),
          const Divider(height: 24),
          HeureCours('14h00 - 16h00', 'TD Base de données - L1 Info'),
        ],
      ),
    );
  }

  // widget pour chaque horaire de cours
  Widget HeureCours(String time, String cours) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                cours,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget AlertCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
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
