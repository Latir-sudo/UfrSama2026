import 'package:flutter/material.dart';
import 'package:sama_ufr/login_page.dart';

class Accueilprincipal extends StatefulWidget {
  const Accueilprincipal({super.key});

  @override
  _AccueilprincipalState createState() => _AccueilprincipalState();
}

class _AccueilprincipalState extends State<Accueilprincipal> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue Sama ufr',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2c3e50),
              ),
            ),
            Text(
              'Université de Gaston Berger de Saint-Louis',
              style: TextStyle(fontSize: 12, color: Color(0xFF7f8c8d)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          _buildAuthButton('connexion', true),
          SizedBox(width: 8),
          _buildAuthButton('inscription', false),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.shade100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Alerte Santé : Maladie de la Vallée',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Texte principal avec gestion du débordement
                      Text(
                        'Une épidémie de la maladie de la Vallée du Rift sévit actuellement dans la région de Saint-Louis.',
                        style: TextStyle(
                          color: Color(0xFF7f8c8d),
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 16),

                      Text(
                        'Mesures de prévention :',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2c3e50),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Liste des mesures avec des lignes fixes
                      _buildCompactPreventionItem(
                        'Éviter contact animaux malades/morts',
                      ),
                      _buildCompactPreventionItem(
                        'Utiliser répulsifs moustiques',
                      ),
                      _buildCompactPreventionItem(
                        'Vêtements couvrants (soirée)',
                      ),
                      _buildCompactPreventionItem('Éviter lait non pasteurisé'),
                      _buildCompactPreventionItem('Lavage mains régulier'),

                      SizedBox(height: 16),

                      // Bouton "Plus d'informations"
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Plus d\'informations',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Section Événements
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'Événements à l\'UFR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2c3e50),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Carte événement 1
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date et heure sur une ligne
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '10 Déc. 2023 • 14h-16h',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Titre de l'événement
                      Text(
                        'Session d\'information MVR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2c3e50),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),

                      // Détails avec icônes
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF7f8c8d),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Salle 204 - Bâtiment Principal',
                              style: TextStyle(
                                color: Color(0xFF7f8c8d),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: Color(0xFF7f8c8d),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Service de santé universitaire',
                              style: TextStyle(
                                color: Color(0xFF7f8c8d),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Boutons d'action
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Participer',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '+ Calendrier',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Carte événement 2
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '12 Déc. 2023 • 10h-12h',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      Text(
                        'Distribution répulsifs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2c3e50),
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF7f8c8d),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Hall Bâtiment A',
                              style: TextStyle(
                                color: Color(0xFF7f8c8d),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            size: 16,
                            color: Color(0xFF7f8c8d),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Apportez carte étudiante',
                              style: TextStyle(
                                color: Color(0xFF7f8c8d),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Participer'),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('+ Calendrier'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Section Accès rapide
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'Accès rapide',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2c3e50),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Grille d'accès rapide (2x3)
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildQuickAccessItem(Icons.book_rounded, 'Ressources'),
                  _buildQuickAccessItem(
                    Icons.schedule_rounded,
                    'Emploi du temps',
                  ),
                  _buildQuickAccessItem(Icons.description, 'Documents'),
                  _buildQuickAccessItem(Icons.newspaper, 'Actualités'),
                  _buildQuickAccessItem(Icons.assessment, 'Résultats'),
                  _buildQuickAccessItem(Icons.mail, 'Messagerie'),
                ],
              ),

              SizedBox(height: 24),

              // Section Statistiques
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Situation Saint-Louis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2c3e50),
                        ),
                      ),
                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCompactStatItem('28', 'Cas', Colors.orange),
                          _buildCompactStatItem('6', 'Hospital.', Colors.red),
                          _buildCompactStatItem('0', 'Décès', Colors.green),
                          _buildCompactStatItem('5', 'Guéris', Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Section Ressources
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ressources',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2c3e50),
                        ),
                      ),
                      SizedBox(height: 12),

                      _buildResourceItem(
                        'Guide de prévention MVR',
                        'PDF • 2.4 MB',
                      ),
                      SizedBox(height: 12),
                      _buildResourceItem('Fiche info OMS', 'PDF • 1.8 MB'),
                      SizedBox(height: 12),
                      _buildResourceItem('Carte points santé', 'PDF • 3.1 MB'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Résultats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Documents',
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton(String text, bool isOutlined) {
    return Container(
      constraints: BoxConstraints(maxWidth: 110),
      child: isOutlined
          ? OutlinedButton(
              onPressed: () => _redirection(text),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size(0, 36),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : ElevatedButton(
              onPressed: () => _redirection(text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size(0, 36),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }

  Widget _buildCompactPreventionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 18, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem(IconData icon, String label) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildResourceItem(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.download, color: Colors.blue),
        iconSize: 20,
      ),
    );
  }

  void _redirection(String type) {
    if (type == "connexion") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InscriptionPage()),
      );
    }
  }
}
