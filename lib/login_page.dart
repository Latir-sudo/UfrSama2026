// login_page.dart
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:sama_ufr/EnsPage/accueil.dart";
import "package:sama_ufr/InscriptionPage.dart";
import "package:sama_ufr/service/auth.dart";
import "package:sama_ufr/constant.dart";
import "package:sama_ufr/EtuPage/EtuPage.dart";
import "package:sama_ufr/AdminPage/AdminHomePage.dart";
import 'package:sama_ufr/service/firestore_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  final Auth _auth = Auth();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String valideInput() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return "Veuillez remplir tous les champs.";
    }

    // Validation de l'email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return "Veuillez entrer une adresse email valide.";
    }

    return ''; // Input valide
  }

  // Méthode pour rediriger selon le rôle
  Future<void> _redirectUserByRole(String uid) async {
    final role = await _firestoreService.getUserRole(uid);

    if (!mounted) return;

    switch (role) {
      case 'student':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EtuPage()),
        );
        break;
      case 'teacher':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EspaceEnseignantPage()),
        );
        break;
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
        break;
      default:
        // Si aucun rôle n'est défini, rediriger vers une page par défaut
        // ou afficher un message d'erreur
        showMessage("Rôle utilisateur non défini. Contactez l'administrateur.");
        await _auth.signOut();
    }
  }

  Future<void> loginUser() async {
    String validationMessage = valideInput();
    if (validationMessage.isNotEmpty) {
      showMessage(validationMessage);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Connexion avec Firebase Auth
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Récupérer l'utilisateur connecté
      final user = _auth.currentUser;
      if (user != null) {
        // Vérifier si le profil existe dans Firestore
        final userProfile = await _firestoreService.getUserProfile(user.uid);

        if (userProfile == null) {
          // Si le profil n'existe pas, déconnecter l'utilisateur
          showMessage(
            "Profil utilisateur non trouvé. Veuillez vous réinscrire.",
          );
          await _auth.signOut();
          return;
        }

        // Rediriger selon le rôle
        await _redirectUserByRole(user.uid);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Aucun utilisateur trouvé pour cet email.";
          break;
        case 'wrong-password':
          errorMessage = "Mot de passe incorrect.";
          break;
        case 'too-many-requests':
          errorMessage =
              "Nombre trop élevé de tentatives de connexion. Veuillez réessayer plus tard.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Échec de la connexion réseau. Vérifiez votre connexion Internet.";
          break;
        case 'invalid-email':
          errorMessage = "Adresse email invalide.";
          break;
        case 'user-disabled':
          errorMessage = "Ce compte a été désactivé.";
          break;
        default:
          errorMessage = "Erreur de connexion : ${e.message}";
      }
      showMessage(errorMessage);
    } catch (e) {
      showMessage("Erreur de connexion : $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildBackgroundImage(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Titre page
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Text(
                    "Sama UFR",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Email
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    labelText: "Email",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    hintText: "Votre email professionnel",
                    prefixIcon: Icon(Icons.mail, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                TextField(
                  obscureText: hidePassword,
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    labelText: "Mot de passe",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    hintText: "Votre mot de passe",
                    prefixIcon: Icon(Icons.password, color: Colors.white),
                    suffixIcon: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Mot de passe oublié
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      showMessage("Fonctionnalité à implémenter");
                    },
                    child: const Text(
                      "Mot de passe oublié ?",
                      style: AppTextStyle.linkText,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Bouton connexion
                ElevatedButton(
                  onPressed: isLoading ? null : loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Se connecter",
                          style: AppTextStyle.buttonText,
                        ),
                ),

                const SizedBox(height: 20),

                // Lien vers l'inscription
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InscriptionPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Créer un compte",
                      style: AppTextStyle.linkText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBackgroundImage() => Container(
    height: double.infinity,
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        fit: BoxFit.cover,
        image: AssetImage("assets/images/image.jpg"),
      ),
    ),
  );
}
