import 'package:flutter/material.dart';
import 'accueil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Espace Enseignant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EspaceEnseignantPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
