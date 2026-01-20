// EtuPage/EtuPage.dart
import 'package:flutter/material.dart';
import 'package:sama_ufr/EtuPage/article.dart';
import 'package:sama_ufr/service/auth.dart';
import 'package:sama_ufr/service/student_service.dart';
import 'package:sama_ufr/login_page.dart';
import 'package:sama_ufr/EtuPage/models.dart';

class EtuPage extends StatefulWidget {
  const EtuPage({super.key});

  @override
  State<EtuPage> createState() => _EtuPageState();
}

class _EtuPageState extends State<EtuPage> {
  late StudentService _studentService;

  @override
  void initState() {
    super.initState();
    _studentService = StudentService();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: _studentService.getUserProfileStream(),
      builder: (context, snapshot) {
        final userProfile = snapshot.data;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Article(
            studentService: _studentService,
            userProfile: userProfile,
          ),
        );
      },
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
}
