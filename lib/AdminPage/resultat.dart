class Resultat {
  String nom;
  String email;
  String type;

  Resultat({required this.nom, required this.email, required this.type});
}

class Shedule {
  String jour;
  String matiere;
  String heure;
  String salle;

  Shedule({
    required this.jour,
    required this.matiere,
    required this.heure,
    required this.salle,
  });
}

class Formation {
  String formation;
  String ufr;
  String niveau;
  double etudiant;
  String statut;

  Formation({
    required this.formation,
    required this.ufr,
    required this.niveau,
    required this.etudiant,
    required this.statut,
  });
}
