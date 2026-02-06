import 'package:flutter/material.dart';
import 'models.dart';
import 'package:sama_ufr/utils/app_colors.dart';
import 'package:sama_ufr/service/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sama_ufr/EtuPage/models.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// Page de détail pour un article
class ArticleDetailPage extends StatelessWidget {
  final ArticleModel article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Article'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientBlueGreen,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec gradient
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/livre.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Par ${article.author}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    article.description ?? 'Article intéressant',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightText,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.gradientBlueGreen,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Téléchargement de "${article.title}" en cours... ✓',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(Icons.download, color: Colors.white),
                        label: Text(
                          'Télécharger',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
    );
  }
}

// Page liste/forum simple
class ForumListPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const ForumListPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Général', 'icon': Icons.chat, 'color': AppColors.primary},
      {'name': 'Études', 'icon': Icons.school, 'color': AppColors.accent},
      {'name': 'Événements', 'icon': Icons.event, 'color': AppColors.warning},
      {'name': 'Divers', 'icon': Icons.more_horiz, 'color': AppColors.success},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Forum d\'Échanges'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPurpleBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: categories.map((cat) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ForumDetailPage(
                  title: cat['name'] as String,
                  content: 'Catégorie: ${cat['name'] as String}',
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (cat['color'] as Color).withOpacity(0.1),
                    (cat['color'] as Color).withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: (cat['color'] as Color).withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cat['color'] as Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['name'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Accédez à la catégorie',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: AppColors.lightText),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ForumDetailPage extends StatelessWidget {
  final String title;
  final String content;
  const ForumDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPurpleBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  border: Border(
                    left: BorderSide(color: AppColors.accent, width: 4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkText,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Exams page
class ExamsPage extends StatelessWidget {
  final List<Map<String, dynamic>> exams;
  const ExamsPage({super.key, required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mes Examens'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientOrangeAmber,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: exams.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 80,
                    color: AppColors.lightText,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun examen',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.lightText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final e = exams[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ExamDetailPage(data: e)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.warning.withOpacity(0.1),
                          AppColors.warning.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.assignment,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                e['title'] ?? 'Examen',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Date: ${e['date']?.toString() ?? 'À définir'}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ExamDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const ExamDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(data['title'] ?? 'Examen'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientOrangeAmber,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? 'Examen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightText,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Requests page
class RequestsPage extends StatelessWidget {
  final List<Map<String, dynamic>> requests;
  const RequestsPage({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mes Demandes'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientNavyBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: requests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 80,
                    color: AppColors.lightText,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune demande',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.lightText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final r = requests[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RequestDetailPage(data: r),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.description,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['title'] ?? 'Demande',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      r['status'] ?? 'En attente',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class RequestDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const RequestDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Détails Demande'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientNavyBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? 'Demande',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightText,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Courses page
class CoursesPage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  const CoursesPage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mes Cours'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientBlueGreen,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Center(child: Text('Cours bientôt disponibles')),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const CourseDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(data['title'] ?? 'Cours')),
      body: Padding(padding: EdgeInsets.all(16), child: Text(data.toString())),
    );
  }
}

// Notifications page
class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  const NotificationsPage({super.key, this.notifications = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPinkPurple,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: AppColors.lightText,
            ),
            SizedBox(height: 16),
            Text(
              'Aucune notification',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.lightText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page des Actualités
/// Page des Actualités pour les étudiants
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late FirestoreService _firestoreService;

  List<NewsModel> _news = [];
  List<NewsModel> _filteredNews = [];
  List<String> _categories = [];
  String _selectedCategory = 'Tous';
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadNews();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Vous pouvez implémenter le chargement infini ici
      }
    });
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Charger les catégories
      _categories = await _firestoreService.newsService.getNewsCategories();
      _categories.insert(0, 'Tous');

      // Charger les actualités avec stream pour mise à jour en temps réel
      _firestoreService.newsService.getPublishedNewsStream().listen(
        (newsList) {
          if (mounted) {
            setState(() {
              _news = newsList;
              _filteredNews = newsList;
              _isLoading = false;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          }
        },
      );

      _animationController.forward();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _filterNews() {
    final searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredNews = _news.where((news) {
        // Filtre par catégorie
        final categoryMatch =
            _selectedCategory == 'Tous' || news.category == _selectedCategory;

        // Filtre par recherche
        final searchMatch =
            searchQuery.isEmpty ||
            news.title.toLowerCase().contains(searchQuery) ||
            news.content.toLowerCase().contains(searchQuery) ||
            news.tags.any((tag) => tag.toLowerCase().contains(searchQuery)) ||
            news.category.toLowerCase().contains(searchQuery);

        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  void _showNewsDetail(NewsModel news) async {
    // Incrémenter le compteur de vues
    await _firestoreService.newsService.incrementViews(news.id);

    // Afficher les détails
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailModal(news: news),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
        _filterNews();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          category,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.darkText,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(NewsModel news) {
    final categoryColor = _getCategoryColor(news.category);
    final timeAgo = _getTimeAgo(news.publishDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showNewsDetail(news),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec catégorie et date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        news.category,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: categoryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Titre
                Text(
                  news.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Contenu résumé
                Text(
                  news.content.length > 150
                      ? '${news.content.substring(0, 150)}...'
                      : news.content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Pied de carte avec infos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tags
                    if (news.tags.isNotEmpty)
                      Row(
                        children: news.tags.take(2).map((tag) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    // Statistiques
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${news.views}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.person, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          news.author.split('@').first,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article, size: 80, color: AppColors.lightText),
          const SizedBox(height: 16),
          Text(
            'Aucune actualité disponible',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: AppColors.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revenez plus tard pour découvrir les dernières actualités',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: AppColors.danger),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: AppColors.danger,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Impossible de charger les actualités. Vérifiez votre connexion.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.lightText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadNews,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Réessayer',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Actualités',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientPurpleBlue,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNews,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Barre de recherche
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une actualité...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: GoogleFonts.poppins(),
                onChanged: (value) => _filterNews(),
              ),
            ),

            // Catégories (chips)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _categories.map(_buildCategoryChip).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Liste des actualités
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _hasError
                  ? _buildErrorState()
                  : _filteredNews.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadNews,
                      color: AppColors.primary,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredNews.length,
                        itemBuilder: (context, index) {
                          return _buildNewsCard(_filteredNews[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bourses':
        return Colors.green;
      case 'Événements':
        return Colors.blue;
      case 'Concours':
        return Colors.orange;
      case 'Administratif':
        return Colors.purple;
      case 'Académique':
        return Colors.indigo;
      case 'Sport':
        return Colors.red;
      case 'Culture':
        return Colors.pink;
      default:
        return AppColors.primary;
    }
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} j';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks sem';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years ans';
    }
  }
}

// Modal pour les détails des actualités
class NewsDetailModal extends StatelessWidget {
  final NewsModel news;

  const NewsDetailModal({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Catégorie
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(
                          news.category,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        news.category,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _getCategoryColor(news.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Titre
                    Text(
                      news.title,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Métadonnées
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          news.author,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy à HH:mm',
                          ).format(news.publishDate),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.remove_red_eye,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${news.views} vues',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Contenu
                    Text(
                      news.content,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),

                    // Tags
                    if (news.tags.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        children: news.tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: Colors.grey[100],
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Partager l'actualité
                            },
                            icon: const Icon(Icons.share),
                            label: Text(
                              'Partager',
                              style: GoogleFonts.poppins(),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: AppColors.accent),
                              foregroundColor: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (news.pdfUrl != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Télécharger le PDF
                              },
                              icon: const Icon(Icons.download),
                              label: Text(
                                'Télécharger',
                                style: GoogleFonts.poppins(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bourses':
        return Colors.green;
      case 'Événements':
        return Colors.blue;
      case 'Concours':
        return Colors.orange;
      case 'Administratif':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }
}

/// Page de Messagerie
class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Prof. Diallo',
      'lastMessage': 'N\'oubliez pas de rendre le projet avant vendredi',
      'time': '10:30',
      'unreadCount': 2,
      'avatar': 'D',
      'isOnline': true,
      'subject': 'Projet Algorithmique',
    },
    {
      'name': 'Administration',
      'lastMessage': 'Les inscriptions pour le second semestre sont ouvertes',
      'time': '09:15',
      'unreadCount': 0,
      'avatar': 'A',
      'isOnline': false,
      'subject': 'Inscriptions',
    },
    {
      'name': 'Dr. Sow',
      'lastMessage': 'Bonne chance pour vos examens !',
      'time': 'Hier',
      'unreadCount': 1,
      'avatar': 'S',
      'isOnline': true,
      'subject': 'Encouragement',
    },
    {
      'name': 'Bibliothèque',
      'lastMessage': 'Votre livre "Introduction à Flutter" est disponible',
      'time': 'Hier',
      'unreadCount': 0,
      'avatar': 'B',
      'isOnline': false,
      'subject': 'Réservation',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadTotal = _conversations.fold<int>(
      0,
      (sum, conv) => sum + (conv['unreadCount'] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Messagerie',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientGreenTurquoise,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // TODO: Ouvrir les notifications
                },
              ),
              if (unreadTotal > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadTotal.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Barre de recherche rapide
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une conversation...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
            ),

            // Liste des conversations
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationItem(_conversations[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Nouveau message
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    final unreadCount = conversation['unreadCount'] as int;
    final isOnline = conversation['isOnline'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: unreadCount > 0
            ? AppColors.secondary.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _openConversation(conversation);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar avec indicateur en ligne
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.secondary.withOpacity(0.2),
                      child: Text(
                        conversation['avatar'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Contenu du message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            conversation['time'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        conversation['subject'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['lastMessage'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: unreadCount > 0
                                    ? Colors.black87
                                    : Colors.grey[600],
                                fontWeight: unreadCount > 0
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Icône de navigation
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openConversation(Map<String, dynamic> conversation) {
    // Marquer comme lu
    setState(() {
      conversation['unreadCount'] = 0;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientGreenTurquoise,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        conversation['avatar'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            conversation['subject'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bouton fermer
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Messages
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildMessage(
                      conversation['lastMessage'],
                      isMe: false,
                      time: conversation['time'],
                    ),
                    const SizedBox(height: 16),
                    _buildMessage(
                      'Merci pour l\'information. Je vais en prendre note.',
                      isMe: true,
                      time: '10:45',
                    ),
                    const SizedBox(height: 16),
                    _buildMessage(
                      'De rien ! N\'hésitez pas si vous avez d\'autres questions.',
                      isMe: false,
                      time: '10:46',
                    ),
                  ],
                ),
              ),

              // Zone de saisie
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tapez votre message...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: GoogleFonts.poppins(),
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
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
  }

  Widget _buildMessage(
    String message, {
    required bool isMe,
    required String time,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isMe ? Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.poppins(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey[500],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
