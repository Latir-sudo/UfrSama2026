import 'package:flutter/material.dart';

class Event {
  String date;
  String duree;
  String titre;
  Color couleur;
  String lieu;
  String organisateur;
  String contenu;

  Event({
    required this.date,
    required this.duree,
    required this.titre,
    required this.couleur,
    required this.lieu,
    required this.organisateur,
    required this.contenu,
  });
}
