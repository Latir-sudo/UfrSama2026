import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';
import 'cours.dart';
import 'notes.dart';
import "ressources.dart";
import 'accueil_page.dart';
import 'package:sama_ufr/Accueil/accueilprincipale.dart';
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
      CoursPage(),
      NotesPage(),
      ResourcesPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
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

              return _buildHeader(
                title: 'Espace Enseignant',
                subtitle:
                    'Bienvenue $firstName${lastName.isNotEmpty ? ' $lastName' : ''}',
                onLogoutPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Menu de navigation en haut
          _buildTopNavigation(),
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required String title,
    required String subtitle,
    required VoidCallback onLogoutPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2E3192),
            const Color(0xFF1BFFFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                onPressed: onLogoutPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Accueil', 0),
          _buildNavItem(Icons.menu_book_outlined, 'Cours', 1),
          _buildNavItem(Icons.edit_note_outlined, 'Notes', 2),
          _buildNavItem(Icons.folder_open_outlined, 'Ressources', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E3192).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF2E3192).withOpacity(0.3), width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2E3192) : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF2E3192) : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3192).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFF2E3192),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Êtes-vous sûr de vouloir vous déconnecter ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Auth().signOut();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Accueilprincipal(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3192),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Déconnecter'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}