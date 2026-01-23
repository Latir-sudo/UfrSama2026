// InscriptionPage.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sama_ufr/login_page.dart';
import 'package:sama_ufr/service/auth.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  String? typeCompte;
  String? role; // Variable pour stocker le rôle technique

  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  @override
  void dispose() {
    prenomController.dispose();
    nomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Convertir le type de compte affiché en rôle technique
  String _convertToRole(String? typeCompte) {
    switch (typeCompte) {
      case "Compte Etudiant":
        return "student";
      case "Compte Professeur":
        return "teacher";
      default:
        return "student"; // Valeur par défaut
    }
  }

  // Méthode d'inscription avec stockage dans Firestore
  Future<void> registerUser() async {
    // Validation des champs
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        prenomController.text.isEmpty ||
        nomController.text.isEmpty ||
        typeCompte == null) {
      showMessage("Veuillez remplir tous les champs");
      return;
    }

    // Validation de l'email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      showMessage("Veuillez entrer un email valide");
      return;
    }

    // Validation du mot de passe
    if (passwordController.text.length < 6) {
      showMessage("Le mot de passe doit contenir au moins 6 caractères");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Convertir le type de compte en rôle technique
      role = _convertToRole(typeCompte);

      // Inscription avec le service Auth qui gère Firestore
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstName: prenomController.text.trim(),
        lastName: nomController.text.trim(),
        role: role!,
      );

      showMessage(
        "Inscription réussie ! Vous pouvez maintenant vous connecter.",
        isError: false,
      );

      // Redirection vers la page de connexion après un délai
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Cet email est déjà utilisé par un autre compte.";
          break;
        case 'invalid-email':
          errorMessage = "L'adresse email n'est pas valide.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "L'inscription par email/mot de passe n'est pas activée.";
          break;
        case 'weak-password':
          errorMessage = "Le mot de passe est trop faible.";
          break;
        default:
          errorMessage = "Erreur lors de l'inscription: ${e.message}";
      }
      showMessage(errorMessage);
    } catch (e) {
      showMessage("Erreur lors de l'inscription: $e");
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
        duration: Duration(seconds: isError ? 3 : 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building InscriptionPage');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xFF3498DB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Champ Prénom
                  _buildTextField(
                    controller: prenomController,
                    label: "Prénom",
                    hintText: 'Entrez votre prénom',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 15),

                  // Champ Nom
                  _buildTextField(
                    controller: nomController,
                    label: "Nom",
                    hintText: 'Entrez votre nom',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 15),

                  // Champ Email
                  _buildTextField(
                    controller: emailController,
                    label: "Email",
                    hintText: 'Votre email professionnel',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 15),

                  // Champ Mot de passe
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: TextField(
                      obscureText: hidePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Définir un mot de passe',
                        labelText: "Mot de passe",
                        icon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sélection du type de compte
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        Text(
                          "Type de compte",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text(
                            "Compte Étudiant",
                            style: TextStyle(fontSize: 16),
                          ),
                          value: "Compte Etudiant",
                          groupValue: typeCompte,
                          onChanged: (value) {
                            setState(() {
                              typeCompte = value;
                            });
                          },
                          activeColor: Color(0xFF3498DB),
                        ),
                        RadioListTile<String>(
                          title: const Text(
                            "Compte Professeur",
                            style: TextStyle(fontSize: 16),
                          ),
                          value: "Compte Professeur",
                          groupValue: typeCompte,
                          onChanged: (value) {
                            setState(() {
                              typeCompte = value;
                            });
                          },
                          activeColor: Color(0xFF3498DB),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bouton d'inscription
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3498DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "S'inscrire",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Lien vers la connexion
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous avez déjà un compte? ",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                              color: Color(0xFF3498DB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget réutilisable pour les champs texte
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 10),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 250, 250, 250),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          labelText: label,
          icon: Icon(icon, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
