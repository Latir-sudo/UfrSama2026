import 'package:flutter/material.dart';
import 'package:sama_ufr/AdminPage/carte.dart';
import 'package:sama_ufr/AdminPage/resultat.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  //boxCard , favoris , card, articleRecent ,
  @override
  Widget build(BuildContext context) {
    final accesRapide = [
      Carte(
        titre: "Gérer utilisateurs",
        couleur: Color(0xFF3498DB),
        taille: 0.3,
        icon: Icons.group_add,
      ),
      Carte(
        titre: "Formations",
        couleur: Color(0xFF3498DB),
        taille: 0.3,
        icon: Icons.house,
      ),
      Carte(
        titre: "Calendrier académique",
        couleur: Color(0xFF3498DB),
        taille: 0.3,
        icon: Icons.calendar_month,
      ),
      Carte(
        titre: "Document officiels",
        couleur: Color(0xFF3498DB),
        taille: 0.3,
        icon: Icons.edit_document,
      ),
      Carte(
        titre: "Statistique",
        couleur: Color(0xFF3498DB),
        taille: 0.3,
        icon: Icons.monitor_rounded,
      ),
      Carte(
        titre: "Paramètre",
        couleur: Color(0xFf3498DB),
        taille: 0.3,
        icon: Icons.settings,
      ),
    ];
    // création d'un tableau pour les évenements

    final stat = [
      Carte(
        titre: "1245",
        couleur: Colors.black,
        taille: 0.46,
        contenu: "Etudiants",
      ),
      Carte(
        titre: "87",
        couleur: Colors.black,
        taille: 0.46,
        contenu: "Enseignants",
      ),
      Carte(
        titre: "24",
        couleur: Colors.black,
        taille: 0.46,
        contenu: "Formations",
      ),
      Carte(
        couleur: Colors.black,
        titre: "342",
        taille: 0.46,
        contenu: "Documents/mois",
      ),
    ];
    final stat2 = [
      Carte(
        titre: "156",
        couleur: Colors.black,
        taille: 0.46,
        contenu: "Attestations/mois",
      ),
      Carte(
        titre: "45",
        couleur: Colors.black,
        taille: 0.46,
        contenu: "Diplomes/mois",
      ),
      Carte(
        titre: "89%",
        couleur: Colors.black,
        taille: 0.46,
        contenu: "Taux de satisfaction",
      ),
      Carte(
        couleur: Colors.black,
        titre: "2.3j",
        taille: 0.46,
        contenu: "Délai moyen",
      ),
    ];
    // tableau pour les résultats matiere note et statut

    final List<Resultat> res = [
      Resultat(
        nom: "Francois Diouf",
        email: "diouf.francois@ugb.edu.sn",
        type: "Etudiant",
      ),
      Resultat(
        nom: "Fatou Badji",
        email: "badji.fatou@gmail.com",
        type: "Enseignant",
      ),
      Resultat(
        nom: "Abdou Ndiaye",
        email: "ndiaye.abdou@gmail.com",
        type: "Administration",
      ),
    ];

    final List<Formation> formation = [
      Formation(
        etudiant: 250,
        formation: "Licence informatique",
        ufr: "UFR SAT",
        niveau: "L1,L2,L3",
        statut: "Active",
      ),
      Formation(
        formation: "licence mathématique",
        ufr: "UFR SAT",
        niveau: "L1,L2,L3",
        etudiant: 196,
        statut: "Active",
      ),
      Formation(
        formation: "Licence physique",
        ufr: "UFR SAT",
        niveau: "L1,L2,L2",
        etudiant: 123,
        statut: "Active",
      ),
    ];

    // Note: La liste shedule n'est pas utilisée dans le build actuel
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                Container(
                  color: Color(0xFFFFFFFF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      menu(
                        items: [
                          {"icon": Icons.home, "label": "Accueil"},
                          {"icon": Icons.school, "label": "Utilisateurs"},
                          {"icon": Icons.book, "label": "Formations"},
                          {"icon": Icons.messenger, "label": "Documents"},
                        ],
                        iconColor: Color(0xFF7F8C8D),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Tableau de bord administratif",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GridView.builder(
                        itemCount: accesRapide.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: carte(
                              accesRapide[index].titre,
                              accesRapide[index].couleur,
                              accesRapide[index].taille,
                              icon: accesRapide[index].icon,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Statistiques générales",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: GridView.builder(
                          itemCount: stat.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 125,
                              ),
                          itemBuilder: (context, index) {
                            return carte(
                              stat[index].titre,
                              stat[index].couleur,
                              stat[index].taille,
                              contenu: stat[index].contenu,
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Alertes système",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              iconColorText(
                                "Maintenance programmé",
                                Color(0xFFF39C12),
                                Icons.document_scanner,
                              ),
                              SizedBox(height: 2),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        "Une maintenance du systeme est prévue le 15 décembre de 22h à 02h.L'application sera temporairement indisponible",
                                        style: TextStyle(
                                          fontSize: 13.6,
                                          color: Color(0xFF7F8C8D),

                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Gestion des utilisateurs",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      gestionUser(
                        res,
                        "Liste des utilisateurs",
                        "ajouter un utilisateur",
                      ),
                      SizedBox(height: 8),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Demandes d'inscription",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          child: Column(
                            children: [
                              iconColorText(
                                "En attente de validation",
                                Color(0xFFF39C12),
                                Icons.person,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Text(
                                        "Mariama Sow",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            margin: EdgeInsets.only(right: 10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFF3498DB,
                                                ),
                                                padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 40,
                                                  top: 3,
                                                  bottom: 3,
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                "valider",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,

                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                              ),

                                              onPressed: () {},
                                              child: Text(
                                                "Refuser",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Nouvelle inscription  Licence informatique En attente depuis 3jours",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: const Color.fromARGB(
                                      255,
                                      111,
                                      109,
                                      109,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Gestion des formations",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      gestionFormation(
                        formation,
                        "Formations disponilbes",
                        "Nouvelle formation",
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Calendrier académique",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              iconColorText(
                                "Année 2023-2024",
                                Color(0xFF2C3E50),
                                Icons.calendar_view_week_sharp,
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  "Rentrée universitaires",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  "15 octobre 2023",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(193, 43, 42, 42),
                                  ),
                                ),
                              ),
                              Divider(
                                color: const Color.fromARGB(64, 158, 158, 158),
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Gestion des documents",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              iconColorText(
                                "Documents à valider",
                                Color(0xFFF39C12),
                                Icons.edit_document,
                              ),
                              SizedBox(height: 8),
                              favoris(
                                "Demande de diplome -Moussa Diop",
                                "Licence informatique",
                                Icons.backpack,
                                Color(0xFF3498DB),
                                "Valider",
                              ),
                              favoris(
                                "Demande d'attestation -Aminata Fall",
                                "Attestation de scolarité 2023-2024 . En attente depuis 1jour",
                                Icons.document_scanner_rounded,
                                Color(0xFF2ECC71),
                                "Valider",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Statistiques des documents",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      SizedBox(
                        child: GridView.builder(
                          itemCount: stat.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 125,
                              ),
                          itemBuilder: (context, index) {
                            return carte(
                              stat2[index].titre,
                              stat2[index].couleur,
                              stat2[index].taille,
                              contenu: stat2[index].contenu,
                            );
                          },
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
    );
  }

  // widget pour menu d'en haut

  Widget menu({
    required List<Map<String, dynamic>> items,
    Color iconColor = Colors.blueAccent,
    Color textColor = Colors.black87,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item['icon'], color: iconColor, size: 26),
                const SizedBox(height: 4),
                Text(
                  item['label'],
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // gestion utilisateur

  Widget gestionUser(final res, String labelText, String labelButton) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            iconColorText(
              labelText,
              Color(0xFF6D338F),
              Icons.account_circle_rounded,
            ),
            tableau(res),
            Container(
              padding: EdgeInsets.only(top: 8),
              alignment: Alignment.bottomRight,
              child: Container(
                width: 180,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Color(0xFFE74C3C), Color(0xFFF39C12)],
                  ),
                ),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  child: Text(
                    labelButton,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gestionFormation(final res, String labelText, String labelButton) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            iconColorText(
              labelText,
              Color(0xFF2ECC71),
              Icons.account_circle_rounded,
            ),
            SizedBox(height: 8),
            tableauFormation(res),
            Container(
              padding: EdgeInsets.only(top: 8),
              alignment: Alignment.bottomRight,
              child: Container(
                width: 180,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Color(0xFFE74C3C), Color(0xFFF39C12)],
                  ),
                ),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  child: Text(
                    labelButton,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // fonction pour le box article

  Widget livreBox(
    String titre,
    String auteur,
    String type,
    String nbTelechargment,
    String note,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 245, 242, 242),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3498DB), Color(0xFF2ECC71)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 70,
            width: 75,
            child: Center(
              child: Icon(Icons.menu, size: 40, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 210,
            child: Column(
              //text
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    titre,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    auteur,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(255, 74, 72, 72),
                    ),
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.document_scanner,
                            size: 14,
                            color: const Color.fromARGB(255, 106, 104, 104),
                          ),
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 106, 104, 104),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.download,
                            size: 14,
                            color: const Color.fromARGB(255, 98, 96, 96),
                          ),
                          Text(
                            nbTelechargment,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 106, 104, 104),
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Icon(
                            Icons.star,
                            size: 15,
                            color: const Color.fromARGB(255, 106, 104, 104),
                          ),
                          Text(
                            note,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: const Color.fromARGB(255, 106, 104, 104),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: 44,
                  height: 85,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3498DB), Color(0xFF2ECC71)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Center(
                    child: Icon(Icons.download, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // pour les articles

  Widget articleRecent(
    String nomArticle,
    String contenu,
    Color couleur,
    IconData icon,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,

      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: couleur,
                  ),
                  width: 60,
                  height: 40,
                  child: Center(
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),

                Container(
                  width: 300,
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    nomArticle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              contenu,
              style: TextStyle(
                fontSize: 13,
                color: const Color.fromARGB(255, 42, 37, 37),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                  child: const Text(
                    "Lire en ligne",
                    style: TextStyle(fontSize: 12, color: Colors.blueAccent),
                  ),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [Color(0xFF3498DB), Color(0xFF2ECC71)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Télécharger",
                      style: TextStyle(fontSize: 12),
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

  // card

  Widget carte(
    String titre,
    Color couleur,
    double taille, {
    String contenu = "",
    IconData icon = Icons.add,
  }) {
    double size;
    if (icon != Icons.add) {
      size = 15;
    } else {
      size = 25;
    }
    return Container(
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon != Icons.add
                  ? Icon(icon, size: 27, color: couleur)
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  titre,
                  style: TextStyle(
                    fontSize: size,
                    color: const Color.fromARGB(255, 57, 56, 56),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              contenu != ""
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        contenu,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 108, 103, 103),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  // favoris

  Widget favoris(
    String titre,
    String referencement,
    IconData icon,
    Color couleur,
    String labelButton,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconColorText(titre, couleur, icon, contenu: referencement),
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.blueAccent),
                  backgroundColor: Color(0xFF3498DB),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                child: Text(
                  labelButton,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // iconColorText

  Widget iconColorText(
    String titre,
    Color couleur,
    IconData icon, {
    String contenu = "",
    double taille = 0.55,
  }) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: couleur,
          ),
          width: 50,
          height: 45,
          margin: EdgeInsets.only(right: 15),
          child: Center(child: Icon(icon, size: 20, color: Colors.white)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * taille,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  titre,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 76, 72, 72),
                  ),
                ),
              ),

              contenu != ""
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        contenu,
                        style: TextStyle(
                          fontSize: 13.6,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
  // boxCard

  Widget boxCard(String titre) {
    return ElevatedButton(
      onPressed: () {},
      style:
          ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 16, right: 40, top: 8, bottom: 8),
            backgroundColor: Color(0xFFF8F9FA),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered)) {
                return const Color.fromARGB(255, 57, 201, 220);
              }
              return Color(0xFFF8F9FA);
            }),

            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.white;
              }
              return Colors.black;
            }),
            elevation: WidgetStateProperty.resolveWith<double>((states) {
              if (states.contains(WidgetState.hovered)) return 0;
              return 0;
            }),
          ),
      child: Text(
        titre,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  //rechercher

  Widget recherche() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Material(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 38,
              child: TextField(
                style: TextStyle(color: const Color.fromARGB(255, 68, 65, 65)),
                decoration: InputDecoration(
                  hintText: "Rechercher un livre, un article...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Color.fromARGB(255, 117, 115, 115),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 20,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 38,
            margin: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Icon(Icons.search, size: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // la fonction pour le box evenement

  Widget event(
    String date,
    String duree,
    String titre,
    Color couleur,
    String lieu,
    String organisateur,
    String contenu,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,

      margin: EdgeInsets.only(right: 15, bottom: 15),
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 19),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                colors: [couleur, const Color.fromARGB(255, 100, 68, 164)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "$date .$duree",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    titre,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                iconText(
                  "Salle 204- Bâtiment Principal",
                  Icons.local_activity_outlined,
                ),
                iconText("Organisé par: Club des Maths", Icons.people),
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      contenu,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      SizedBox(
                        height: 25,
                        child: ElevatedButton(
                          onPressed: () {},
                          style:
                              ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 20,
                                  top: 2,
                                  bottom: 2,
                                ),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                  color: Color(0xFF3498DB),
                                  width: 1,
                                ),
                              ).copyWith(
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return Colors.lightBlue;
                                      }
                                      return null;
                                    }),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return Colors.lightBlue;
                                      }
                                      return Colors.white;
                                    }),
                              ),
                          child: Text(
                            "Participer",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 25,
                              top: 4,
                              bottom: 4,
                            ),
                            backgroundColor: Color(0xFF3498DB),
                          ),
                          child: Text(
                            "+Calendrier",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
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
    );
  }

  Row iconText(String lieu, IconData icon) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Icon(
            icon,
            size: 23,
            color: const Color.fromARGB(255, 142, 138, 138),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            lieu,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 110, 104, 104),
            ),
          ),
        ),
      ],
    );
  }

  // tableau

  Widget tableau(final result) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        top: BorderSide(color: Color(0xFFEEEEEE)),
        bottom: BorderSide(color: Color(0xFFEEEEEE)),
      ),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Nom",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Email",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Type",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        for (final r in result)
          TableRow(
            decoration: BoxDecoration(color: Colors.white),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Text(
                  r.nom,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  r.email.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  r.type,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget tableauFormation(final result) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        top: BorderSide(color: Color(0xFFEEEEEE)),
        bottom: BorderSide(color: Color(0xFFEEEEEE)),
      ),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Formation",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "UFR",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Niveau",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Etudiants",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Text(
                "Statut",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        for (final r in result)
          TableRow(
            decoration: BoxDecoration(color: Colors.white),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Text(
                  r.formation,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(
                  r.ufr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(
                  r.niveau,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(
                  r.etudiant.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Text(
                  r.statut,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget emploiTemps(final shedule) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        top: BorderSide(color: Color(0xFFEEEEEE)),
        bottom: BorderSide(color: Color(0xFFEEEEEE)),
      ),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              child: Text(
                "Jour",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              child: Text(
                "Matiére",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              child: Text(
                "Heure",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              child: Text(
                "Salle",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        for (final r in shedule)
          TableRow(
            decoration: BoxDecoration(color: Colors.white),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Text(
                  r.jour,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  r.matiere,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  r.heure,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  r.salle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  //
}
