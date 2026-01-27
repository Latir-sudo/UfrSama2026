import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sama_ufr/EtuPage/models.dart';
import 'package:sama_ufr/service/student_service.dart';
import 'package:sama_ufr/EtuPage/detail_pages.dart';
import 'package:sama_ufr/EtuPage/more_detail_pages.dart';
import 'package:sama_ufr/utils/app_colors.dart';
import 'package:sama_ufr/Accueil/accueilprincipale.dart';
import 'package:sama_ufr/service/auth.dart';

class Article extends StatefulWidget {
  final StudentService studentService;
  final UserProfile? userProfile;

  const Article({super.key, required this.studentService, this.userProfile});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'Informatique',
    'Mathématiques',
    'Physique',
    'Développement Mobile',
  ];

  // Système de navigation par onglets
  int _currentTabIndex = 0;
  final List<String> _tabs = ['Accueil', 'Résultats', 'Bibliothèque', 'Forum'];

  // Données
  List<ArticleModel> _articles = [];
  List<EventModel> _events = [];
  List<CourseResult> _results = [];
  List<Schedule> _schedules = [];
  List<Map<String, dynamic>> _documents = [];

  bool _isLoading = true;
  StreamSubscription? _articlesSubscription;
  StreamSubscription? _eventsSubscription;
  StreamSubscription? _schedulesSubscription;
  StreamSubscription? _documentsSubscription;
  StreamSubscription? _resultsSubscription;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _articlesSubscription?.cancel();
    _eventsSubscription?.cancel();
    _schedulesSubscription?.cancel();
    _documentsSubscription?.cancel();
    _resultsSubscription?.cancel();
    super.dispose();
  }

  void _initData() {
    setState(() => _isLoading = true);

    print(' Initialisation des données...');

    // Articles
    _articlesSubscription = widget.studentService
        .getArticlesStream(category: _selectedCategory)
        .listen(
          (articles) {
            if (mounted) {
              print('Articles reçus: ${articles.length}');
              setState(() => _articles = articles);
            }
          },
          onError: (error) {
            print('Erreur articles: $error');
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        );

    // Événements
    _eventsSubscription = widget.studentService.getEventsStream().listen(
      (events) {
        if (mounted) {
          print('Événements reçus: ${events.length}');
          setState(() => _events = events);
        }
      },
      onError: (error) {
        print(' Erreur événements: $error');
      },
    );

    // Emploi du temps (semaine actuelle)
    final now = DateTime.now();
    final weekStart =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    print('Recherche schedules pour semaine: $weekStart');
    _schedulesSubscription = widget.studentService
        .getScheduleStream(weekStart)
        .listen(
          (schedules) {
            if (mounted) {
              print('Schedules reçus: ${schedules.length}');
              setState(() => _schedules = schedules);
            }
          },
          onError: (error) {
            print('Erreur emploi du temps: $error');
          },
        );

    // Documents
    _documentsSubscription = widget.studentService.getStudentDocuments().listen(
      (documents) {
        if (mounted) {
          print('Documents reçus: ${documents.length}');
          setState(() => _documents = documents);
        }
      },
      onError: (error) {
        print('Erreur documents: $error');
      },
    );

    // Charger les résultats en temps réel via Stream
    print('Chargement des résultats en flux...');
    _resultsSubscription = widget.studentService
        .getStudentResultsStream()
        .listen(
          (results) {
            if (mounted) {
              print('Résultats reçus (Stream): ${results.length}');
              setState(() {
                _results = results;
                _isLoading = false;
              });
            }
          },
          onError: (error) {
            print('Erreur flux résultats: $error');
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        );
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _articlesSubscription?.cancel();
    _articlesSubscription = widget.studentService
        .getArticlesStream(category: category)
        .listen((articles) {
          if (mounted) {
            setState(() => _articles = articles);
          }
        });
  }

  /// Gère la navigation des boutons d'accès rapide
  void _handleQuickAccessTap(BuildContext context, String title) {
    switch (title) {
      case "Résultats":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultsPage(results: _results),
          ),
        );
        break;
      case "Emploi du temps":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SchedulePage(schedules: _schedules),
          ),
        );
        break;
      case "Document":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DocumentsPage(documents: _documents),
          ),
        );
        break;
      case "Ressources":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ResourcesPage(studentService: widget.studentService),
          ),
        );
        break;
      case "Actualités":
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const NewsPage()));
        break;
      case "Message":
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const MessagingPage()));
        break;
      default:
        break;
    }
  }

  /// Gère la navigation du menu supérieur (utilise `context` du State)
  void _handleMenuTap(String label) {
    switch (label) {
      case 'Accueil':
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 'Résultats':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultsPage(results: _results)),
        );
        break;
      case 'Bibliothèque':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                ResourcesPage(studentService: widget.studentService),
          ),
        );
        break;
      case 'Forum':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ForumListPage(items: [])));
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Action: $label')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          flexibleSpace: _buildHeader(),
        ),
      ),
      body: Column(
        children: [
          // Menu de navigation des onglets
          _buildTabMenu(),
          // Contenu des onglets
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  /// Construit l'en-tête avec gradient
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientBlueGreen
              .map((c) => Color(c.value))
              .toList(),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Espace Étudiant',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bienvenue ${widget.userProfile?.firstName ?? 'Étudiant'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white, size: 22),
              onPressed: () {
                Auth().signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Accueilprincipal()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le menu de navigation des onglets
  Widget _buildTabMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == _currentTabIndex;
          final icons = [Icons.home, Icons.edit, Icons.book, Icons.forum];

          return InkWell(
            onTap: () {
              setState(() => _currentTabIndex = index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF525760),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? AppColors.primary : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: -6,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Affiche le contenu selon l'onglet sélectionné
  Widget _buildTabContent() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(Duration(seconds: 1));
        _initData();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: _currentTabIndex == 0
            ? _buildHomeTab()
            : _currentTabIndex == 1
            ? _buildResultsTab()
            : _currentTabIndex == 2
            ? _buildLibraryTab()
            : _buildForumTab(),
      ),
    );
  }

  /// Contenu de l'onglet Accueil
  Widget _buildHomeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Tableau de bord",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 54, 53, 53),
            ),
          ),
        ),

        // Événements
        _buildEventsSection(),
        SizedBox(height: 20),

        // Articles récents
        _buildArticlesHomeSection(),
        SizedBox(height: 20),

        // Raccourcis d'accès rapide
        _buildQuickAccessSection(),
        SizedBox(height: 30),
      ],
    );
  }

  /// Contenu de l'onglet Résultats
  Widget _buildResultsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Mes Résultats",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 54, 53, 53),
            ),
          ),
        ),
        _buildResultsSection(),
        SizedBox(height: 30),
      ],
    );
  }

  /// Contenu de l'onglet Bibliothèque
  Widget _buildLibraryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Bibliothèque Numérique",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 54, 53, 53),
            ),
          ),
        ),
        recherche(),
        SizedBox(height: 15),
        _buildCategoryFilter(),
        SizedBox(height: 15),
        _buildArticlesSection(),
        SizedBox(height: 20),
        _buildDocumentsSection(),
        SizedBox(height: 30),
      ],
    );
  }

  /// Contenu de l'onglet Forum
  Widget _buildForumTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Forum d'Échanges",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 54, 53, 53),
            ),
          ),
        ),
        _buildForumSection(),
        SizedBox(height: 30),
      ],
    );
  }

  // === SECTIONS SIMPLIFIÉES ===

  /// Articles pour la page d'accueil (version compacte)
  Widget _buildArticlesHomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Articles Récents",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _currentTabIndex = 2),
              child: Text(
                "Voir plus",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (_articles.isEmpty)
          Center(child: Text("Aucun article disponible"))
        else
          Column(
            children: _articles.take(3).map((article) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailPage(article: article),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 245, 242, 242),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.gradientBlueGreen
                                  .map((c) => Color(c.value))
                                  .toList(),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(Icons.article, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                article.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((category) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: boxCard(
              category,
              isSelected: category == _selectedCategory,
              onTap: () => _onCategoryChanged(category),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArticlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Livres populaires",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        if (_articles.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Aucun article disponible',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ..._articles.take(2).map((article) => _buildArticleCard(article)),
      ],
    );
  }

  Widget _buildArticleCard(ArticleModel article) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(article: article),
          ),
        );
      },
      child: livreBox(
        article.title,
        article.author,
        article.type,
        article.downloads.toString(),
        "${article.rating.toStringAsFixed(1)}/5",
      ),
    );
  }

  Widget _buildForumSection() {
    final forumData = [
      {
        'title': "Cours et TD",
        'color': Colors.black,
        'content': "Questions sur les cours et exercices",
        'icon': Icons.school,
      },
      {
        'title': "Projets",
        'color': Colors.black,
        'content': "Collaboration sur les projets",
        'icon': Icons.electric_bike,
      },
      {
        'title': "Carrière",
        'color': Colors.black,
        'content': "Stages et opportunités professionnelles",
        'icon': Icons.badge,
      },
      {
        'title': "Général",
        'color': Colors.black,
        'content': "Discussion diverses",
        'icon': Icons.people,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Forum d'échanges",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          itemCount: forumData.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            mainAxisExtent: 160,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                final item = forumData[index];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ForumDetailPage(
                      title: item['title'] as String,
                      content: item['content'] as String,
                    ),
                  ),
                );
              },
              child: carte(
                forumData[index]['title'] as String,
                forumData[index]['color'] as Color,
                0.45,
                contenu: forumData[index]['content'] as String,
                icon: forumData[index]['icon'] as IconData,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Événements à l'UFR",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        if (_events.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Aucun événement disponible',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _events.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final eventItem = _events[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(event: eventItem),
                      ),
                    );
                  },
                  child: event(
                    _formatDate(eventItem.date),
                    eventItem.duration,
                    eventItem.title,
                    _getEventColor(eventItem.category),
                    eventItem.location,
                    eventItem.organizer,
                    eventItem.description,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildQuickAccessSection() {
    final quickAccess = [
      {
        'title': "Résultats",
        'icon': Icons.access_alarm,
        'color': Color(0xFF3498DB),
      },
      {
        'title': "Emploi du temps",
        'icon': Icons.schedule,
        'color': Color(0xFF3498DB),
      },
      {
        'title': "Document",
        'icon': Icons.document_scanner,
        'color': Color(0xFF3498DB),
      },
      {
        'title': "Ressources",
        'icon': Icons.library_add_check,
        'color': Color(0xFF3498DB),
      },
      {
        'title': "Actualités",
        'icon': Icons.alarm_rounded,
        'color': Color(0xFF3498DB),
      },
      {
        'title': "Message",
        'icon': Icons.messenger_sharp,
        'color': Color(0xFF3498DB),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Accès rapide",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 8),
        GridView.builder(
          itemCount: quickAccess.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = quickAccess[index];
            return InkWell(
              onTap: () {
                _handleQuickAccessTap(context, item['title'] as String);
              },
              child: carte(
                quickAccess[index]['title'] as String,
                quickAccess[index]['color'] as Color,
                0.3,
                icon: quickAccess[index]['icon'] as IconData,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(Icons.grade, color: Color(0xFF3498DB), size: 24),
              SizedBox(width: 8),
              Text(
                "Mes résultats",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (_results.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.grade_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucun résultat disponible',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Vos résultats apparaîtront ici une fois publiés',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
              children: [
                iconColorText(
                  "📚 Résultats Semestre 1",
                  Color(0xFF3498DB),
                  Icons.school,
                ),
                SizedBox(height: 15),
                tableau(_results),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.bottomRight,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Color(0xFF3498DB),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResultsPage(results: _results),
                        ),
                      );
                    },
                    child: Text(
                      "Voir tous les résultats",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatsSection() {
    final statsData = [
      {'title': "14.2", 'content': "Moyenne générale", 'color': Colors.black},
      {'title': "4", 'content': "UE validés", 'color': Colors.black},
      {'title': "60", 'content': "crédits ECTS", 'color': Colors.black},
      {'title': "1", 'content': "Rang promotion", 'color': Colors.black},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Statistiques académiques",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        GridView.builder(
          itemCount: statsData.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 125,
          ),
          itemBuilder: (context, index) {
            return carte(
              statsData[index]['title'] as String,
              statsData[index]['color'] as Color,
              0.46,
              contenu: statsData[index]['content'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    final schedulesForTable = _schedules
        .map(
          (s) => _ScheduleRow(
            day: s.day,
            course: s.course,
            time: s.time,
            room: s.room,
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Mon emploi du temps",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (_schedules.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Aucun cours cette semaine',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconColorText(
                  "Semaine du ${_schedules.isNotEmpty ? _schedules.first.day : 'lundi'}",
                  Color(0xFF9B59B6),
                  Icons.calendar_month,
                ),
                SizedBox(height: 15),
                emploiTemps(schedulesForTable),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9B59B6),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SchedulePage(schedules: _schedules),
                        ),
                      );
                    },
                    child: Text(
                      'Voir l\'emploi du temps complet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildExamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Examens à venir",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // Push exams page (data may come from Firestore in future)
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ExamsPage(exams: [])),
            );
          },
          child: Card(
            elevation: 2,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  iconColorText(
                    "Session d'examens - Janvier 2024",
                    Color(0xFFF39C12),
                    Icons.document_scanner,
                  ),
                  SizedBox(height: 8),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "Algorithmique",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF7F8C8D),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "15 Janvier 2024 08H-10H Amphi B",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 161, 158, 158),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(34, 158, 158, 158),
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Mes documents",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          elevation: 3,
          color: Colors.white,
          child: Column(
            children: [
              iconColorText(
                "Documents disponibles",
                Color(0xFFF39C12),
                Icons.edit_document,
              ),
              SizedBox(height: 8),
              ..._documents
                  .take(2)
                  .map(
                    (doc) => Column(
                      children: [
                        favoris(
                          doc['title'],
                          doc['description'],
                          Icons.document_scanner,
                          Color(0xFF2ECC71),
                          "Télécharger",
                        ),
                        Divider(
                          color: const Color.fromARGB(78, 158, 158, 158),
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Demandes en cours",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RequestsPage(requests: []),
              ),
            );
          },
          child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconColorText(
                  "Documents en attente",
                  Color(0xFF2C3E50),
                  Icons.timer,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    "Diplôme de Licence",
                    style: TextStyle(
                      fontSize: 19,
                      color: Color(0xFF7F8C8D),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    "En cours de traitement . Estimation : 15 jours",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 134, 132, 132),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Mes Favoris",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        favoris(
          "Introduction à Flutter",
          "Guide complet pour débuter",
          Icons.favorite,
          Color(0xFFE74C3C),
          "Lire",
        ),
        Divider(color: const Color.fromARGB(78, 158, 158, 158), thickness: 1),
        favoris(
          "Programmation Dart",
          "Les bases et fonctionnalités avancées",
          Icons.favorite,
          Color(0xFF3498DB),
          "Lire",
        ),
        Divider(color: const Color.fromARGB(78, 158, 158, 158), thickness: 1),
        favoris(
          "Firebase pour Mobile",
          "Intégration avec Flutter",
          Icons.favorite,
          Color(0xFFF39C12),
          "Lire",
        ),
      ],
    );
  }

  // === MÉTHODES UTILITAIRES ===

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Août',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];
    return "${date.day} ${months[date.month - 1]}. ${date.year}";
  }

  Color _getEventColor(String category) {
    switch (category.toLowerCase()) {
      case 'conférence':
        return Colors.blue;
      case 'atelier':
        return Colors.green;
      case 'sport':
        return Colors.orange;
      case 'culture':
        return Colors.purple;
      default:
        return Colors.red;
    }
  }

  // === VOS MÉTHODES ORIGINALES (gardez-les) ===

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
            onTap: () {
              final label = item['label'] as String;
              _handleMenuTap(label);
            },
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Téléchargement de "$titre" en cours...'),
                    ),
                  );
                },
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
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 3,
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
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
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
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1, color: Colors.blueAccent),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              ),
              child: Text(
                labelButton,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w400,
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
    double taille = 0.50,
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
                    fontSize: 18,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 130, 124, 124),
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

  Widget boxCard(String titre, {bool isSelected = false, VoidCallback? onTap}) {
    final baseBg = isSelected
        ? const Color.fromARGB(255, 57, 201, 220)
        : Color(0xFFF8F9FA);
    final baseFg = isSelected ? Colors.white : Colors.black;

    return ElevatedButton(
      onPressed: onTap ?? () {},
      style:
          ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 16, right: 40, top: 8, bottom: 8),
            backgroundColor: baseBg,
            foregroundColor: baseFg,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered)) {
                return const Color.fromARGB(255, 57, 201, 220);
              }
              return baseBg;
            }),

            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.white;
              }
              return baseFg;
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
      width: MediaQuery.of(context).size.width * 0.75,

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
            height: 110,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 19),
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
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      contenu,
                      overflow: TextOverflow.ellipsis,
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
    return Column(
      children: result.map<Widget>((r) {
        Color gradeColor;
        if (r.grade >= 16) {
          gradeColor = Colors.green;
        } else if (r.grade >= 12) {
          gradeColor = Colors.blue;
        } else if (r.grade >= 10) {
          gradeColor = Colors.orange;
        } else {
          gradeColor = Colors.red;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: gradeColor.withOpacity(0.3), width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.courseName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Statut: ${r.status}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: gradeColor, width: 1),
                ),
                child: Text(
                  r.grade.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
                  r.day,
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
                  r.course,
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
                  r.time,
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
                  r.room,
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
}

// Classe helper pour mapper les données Schedule à la table
class _ScheduleRow {
  final String day;
  final String course;
  final String time;
  final String room;

  _ScheduleRow({
    required this.day,
    required this.course,
    required this.time,
    required this.room,
  });
}
