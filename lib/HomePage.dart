import 'package:flutter/material.dart';
import 'package:sama_ufr/service/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page d\'accueil',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page d\'accueil')),
      body: Column(
        children: [
          Center(child: Text('Bienvenue sur la page d\'accueil !')),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Auth().signOut();
              },
              child: const Text('Se déconnecter'),
            ),
          ),
        ],
      ),
    );
  }
}
