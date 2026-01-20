import 'package:flutter/material.dart';

class Carte {
  String titre;
  Color couleur;
  double taille;
  String contenu;
  IconData icon;

  // constructeur

  Carte({
    required this.titre,
    required this.couleur,
    required this.taille,
    this.contenu = "",
    this.icon = Icons.add,
  });
}
