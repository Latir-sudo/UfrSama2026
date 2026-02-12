import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sama_ufr/LandingPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sama_ufr/utils/firestore_initializer.dart'; // Importez votre script 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase initialized');

  // Appeler l'initialisation Firestore
  print('Initializing Firestore collections...');
  await _initializeFirestoreData();
  print('Firestore initialization complete');

  print('Running app...');
  runApp(const MyApp());
}

Future<void> _initializeFirestoreData() async {
  try {
    final initializer = FirestoreInitializer();
    await initializer.initializeAllCollections();
  } catch (e) {
    print('Erreur lors de l\'initialisation Firestore: $e');
    // Continuer même en cas d'erreur pour ne pas bloquer l'application
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp');
    return MaterialApp(
      title: 'Sama UFR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Landingpage(),
    );
  }
}
