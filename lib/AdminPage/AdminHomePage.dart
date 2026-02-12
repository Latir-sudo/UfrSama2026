import 'package:flutter/material.dart';
import 'package:sama_ufr/AdminPage/admin.dart';
import 'package:sama_ufr/login_page.dart';
import 'package:sama_ufr/service/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // hauteur de l'entête
        child: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          flexibleSpace: entete(
            titre: 'Espace Administrateur',
            sousTitre: 'Bienvenue, Admin',
            couleurs: const [], // Pas utilisé, mais gardé pour compatibilité
            icon: Icons.logout,
            onIconPressed: () {
              Auth().signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ),
      ),
      body: Admin(),
    );
  }

  // definition de la fonction entête

  Widget entete({
    required String titre,
    required String sousTitre,
    required List<Color> couleurs,
    required IconData icon,
    VoidCallback? onIconPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF2E3192), const Color(0xFF1BFFFF)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Texte centré
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titre,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sousTitre,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          // Icône à droite
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
}
