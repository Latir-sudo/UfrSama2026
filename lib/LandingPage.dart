// Landingpage.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sama_ufr/InscriptionPage.dart';
import 'package:sama_ufr/service/firestore_service.dart';
import 'package:sama_ufr/EtuPage/EtuPage.dart';
import 'package:sama_ufr/EnsPage/accueil.dart';
import 'package:sama_ufr/AdminPage/AdminHomePage.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            return InscriptionPage();
          } else {
            // Si l'utilisateur est connecté, vérifier son rôle et rediriger
            return FutureBuilder<Map<String, dynamic>?>(
              future: firestoreService.getUserProfile(user.uid),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (profileSnapshot.hasError || !profileSnapshot.hasData) {
                  // Si erreur ou pas de profil, déconnecter
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Profil utilisateur non trouvé. Veuillez vous réinscrire.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                  return InscriptionPage();
                }

                final userProfile = profileSnapshot.data!;
                final role = userProfile['role'] as String? ?? 'student';

                // Redirection selon le rôle
                switch (role) {
                  case 'student':
                    return EtuPage();
                  case 'teacher':
                    return EspaceEnseignantPage();
                  case 'admin':
                    return AdminHomePage();
                  default:
                    // Rôle inconnu, rediriger vers une page par défaut
                    return EtuPage();
                }
              },
            );
          }
        } else {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
