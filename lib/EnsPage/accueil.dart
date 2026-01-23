import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';
import 'cours.dart';
import 'notes.dart';
import "ressources.dart";
import 'accueil_page.dart';
import 'package:sama_ufr/login_page.dart';
import 'package:sama_ufr/Accueil/accueilPrincipal.dart';
import 'package:sama_ufr/service/auth.dart';

class EspaceEnseignantPage extends StatefulWidget {
  const EspaceEnseignantPage({super.key});

  @override
  State<EspaceEnseignantPage> createState() => _EspaceEnseignantPageState();
}

class _EspaceEnseignantPageState extends State<EspaceEnseignantPage> {
  int _currentIndex = 0;
  final TeacherService _teacherService = TeacherService();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AccueilPage(
        teacherService: _teacherService,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const CoursPage(),
      const NotesPage(),
      const ResourcesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          flexibleSpace: StreamBuilder<Map<String, dynamic>>(
            stream: _teacherService.getTeacherProfileStream(),
            builder: (context, snapshot) {
              String firstName = 'Enseignant';
              String lastName = '';

              if (snapshot.hasData) {
                final profile = snapshot.data!;
                firstName = profile['firstName'] ?? 'Enseignant';
                lastName = profile['lastName'] ?? '';
              }

              return entete(
                titre: 'Espace Enseignant',
                sousTitre:
                    'Bienvenue $firstName${lastName.isNotEmpty ? ' $lastName' : ''}',
                couleurs: [
                  const Color.fromARGB(255, 132, 69, 150),
                  const Color.fromARGB(255, 53, 120, 186),
                ],
                icon: Icons.logout,
                onIconPressed: () {
                  Auth().signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Accueilprincipal()),
                  );
                },
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Menu de navigation
          menu(
            currentIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              {'icon': Icons.home, 'label': 'Accueil'},
              {'icon': Icons.book, 'label': 'Cours'},
              {'icon': Icons.edit, 'label': 'Notes'},
              {'icon': Icons.folder, 'label': 'Ressources'},
            ],
            iconColor: const Color.fromARGB(255, 82, 87, 96),
            textColor: const Color.fromARGB(221, 12, 11, 11),
            selectedColor: Colors.blue,
          ),
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Cours'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Ressources',
          ),
        ],
      ),
    );
  }
}

Widget menu({
  required List<Map<String, dynamic>> items,
  int currentIndex = 0,
  Color iconColor = Colors.blueAccent,
  Color textColor = Colors.black87,
  Color selectedColor = Colors.blue,
  Function(int)? onItemSelected,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isSelected = index == currentIndex;

        return InkWell(
          onTap: () {
            if (onItemSelected != null) {
              onItemSelected(index);
            }
            print(item['label']);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item['icon'],
                color: isSelected ? selectedColor : iconColor,
                size: 26,
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? selectedColor : textColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: -6,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
    ),
  );
}

Widget entete({
  required String titre,
  required String sousTitre,
  required List<Color> couleurs,
  required IconData icon,
  VoidCallback? onIconPressed,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: couleurs,
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sousTitre,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onIconPressed,
          ),
        ),
      ],
    ),
  );
}
