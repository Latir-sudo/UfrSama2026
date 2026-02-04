import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../EtuPage/models.dart';

/// Page de gestion des actualités pour l'administrateur
class AdminNewsPage extends StatefulWidget {
  const AdminNewsPage({super.key});

  @override
  State<AdminNewsPage> createState() => _AdminNewsPageState();
}

class _AdminNewsPageState extends State<AdminNewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  List<NewsModel> _news = [];
  List<NewsModel> _draftNews = [];
  bool _isLoading = true;

  // Catégories disponibles
  final List<String> _categories = [
    'Général',
    'Événements',
    'Bourses',
    'Concours',
    'Administratif',
    'Académique',
    'Sport',
    'Culture',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les actualités publiées
      final publishedSnapshot = await _firestore
          .collection('news')
          .where('isPublished', isEqualTo: true)
          .orderBy('publishDate', descending: true)
          .get();

      _news = publishedSnapshot.docs.map((doc) {
        return NewsModel.fromFirestore(doc);
      }).toList();

      // Charger les brouillons
      final draftSnapshot = await _firestore
          .collection('news')
          .where('isPublished', isEqualTo: false)
          .orderBy('publishDate', descending: true)
          .get();

      _draftNews = draftSnapshot.docs.map((doc) {
        return NewsModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Erreur lors du chargement des actualités: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCreateNewsDialog({NewsModel? existingNews}) {
    final isEditing = existingNews != null;

    String? selectedCategory = existingNews?.category ?? _categories.first;
    final titleController = TextEditingController(
      text: existingNews?.title ?? '',
    );
    final contentController = TextEditingController(
      text: existingNews?.content ?? '',
    );
    final tagsController = TextEditingController(
      text: existingNews?.tags.join(', ') ?? '',
    );
    bool isPublished = existingNews?.isPublished ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Modifier l\'actualité' : 'Nouvelle actualité',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titre
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Titre*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Titre de l\'actualité',
                      ),
                      maxLength: 100,
                    ),
                    const SizedBox(height: 12),

                    // Catégorie
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Catégorie*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialValue: selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Contenu
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Contenu*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Contenu de l\'actualité...',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tags
                    TextField(
                      controller: tagsController,
                      decoration: InputDecoration(
                        labelText: 'Tags (séparés par des virgules)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'ex: bourse, événement, inscription',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Statut de publication
                    Row(
                      children: [
                        Checkbox(
                          value: isPublished,
                          onChanged: (value) {
                            setState(() {
                              isPublished = value ?? true;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Publier immédiatement',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Veuillez remplir le titre et le contenu',
                          ),
                          backgroundColor: AppColors.warning,
                        ),
                      );
                      return;
                    }

                    await _saveNews(
                      id: existingNews?.id,
                      title: titleController.text,
                      content: contentController.text,
                      category: selectedCategory!,
                      tags: tagsController.text
                          .split(',')
                          .map((tag) => tag.trim())
                          .where((tag) => tag.isNotEmpty)
                          .toList(),
                      isPublished: isPublished,
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(isEditing ? 'Mettre à jour' : 'Créer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveNews({
    String? id,
    required String title,
    required String content,
    required String category,
    required List<String> tags,
    required bool isPublished,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      final userEmail = _auth.currentUser?.email;
      if (userId == null) return;

      final newsData = {
        'title': title,
        'content': content,
        'category': category,
        'tags': tags,
        'isPublished': isPublished,
        'publishDate': isPublished ? FieldValue.serverTimestamp() : null,
        'author': userEmail,
        'views': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (id == null) {
        // Créer une nouvelle actualité
        await _firestore.collection('news').add(newsData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Actualité créée avec succès!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        // Mettre à jour une actualité existante
        await _firestore.collection('news').doc(id).update(newsData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Actualité mise à jour avec succès!'),
            backgroundColor: AppColors.success,
          ),
        );
      }

      await _loadNews();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _deleteNews(String id) async {
    try {
      await _firestore.collection('news').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Actualité supprimée avec succès!'),
          backgroundColor: AppColors.success,
        ),
      );
      await _loadNews();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _publishNews(String id) async {
    try {
      await _firestore.collection('news').doc(id).update({
        'isPublished': true,
        'publishDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Actualité publiée avec succès!'),
          backgroundColor: AppColors.success,
        ),
      );
      await _loadNews();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Widget _buildNewsCard(NewsModel news, {bool isDraft = false}) {
    Color categoryColor;
    switch (news.category) {
      case 'Bourses':
        categoryColor = Colors.green;
        break;
      case 'Événements':
        categoryColor = Colors.blue;
        break;
      case 'Concours':
        categoryColor = Colors.orange;
        break;
      case 'Administratif':
        categoryColor = Colors.purple;
        break;
      default:
        categoryColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              news.category,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isDraft)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.warning.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Brouillon',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      _showCreateNewsDialog(existingNews: news);
                    } else if (value == 'delete') {
                      await _deleteNews(news.id);
                    } else if (value == 'publish' && isDraft) {
                      await _publishNews(news.id);
                    }
                  },
                  itemBuilder: (context) => [
                    if (isDraft)
                      const PopupMenuItem(
                        value: 'publish',
                        child: Row(
                          children: [
                            Icon(Icons.publish, size: 18),
                            SizedBox(width: 8),
                            Text('Publier'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Modifier'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Supprimer',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              news.content.length > 150
                  ? '${news.content.substring(0, 150)}...'
                  : news.content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.lightText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${news.views} vues • ${_dateFormat.format(news.publishDate)}',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                ),
                Row(
                  children: news.tags.take(2).map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final totalNews = _news.length + _draftNews.length;
    final publishedNews = _news.length;
    final draftNews = _draftNews.length;
    final totalViews = _news.fold<int>(0, (sum, news) => sum + news.views);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientPurpleBlue,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', '$totalNews', Icons.article, Colors.white),
          _buildDivider(),
          _buildStatItem(
            'Publiés',
            '$publishedNews',
            Icons.public,
            Colors.white,
          ),
          _buildDivider(),
          _buildStatItem(
            'Brouillons',
            '$draftNews',
            Icons.drafts,
            Colors.white,
          ),
          _buildDivider(),
          _buildStatItem(
            'Vues',
            '$totalViews',
            Icons.remove_red_eye,
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: color.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Gestion des Actualités',
          style: GoogleFonts.poppins(
            fontSize: 20,
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.public), text: 'Publiées'),
            Tab(icon: Icon(Icons.drafts), text: 'Brouillons'),
            Tab(icon: Icon(Icons.analytics), text: 'Statistiques'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                // Onglet 1: Actualités publiées
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsCard(),
                      const SizedBox(height: 24),
                      Text(
                        'Actualités publiées (${_news.length})',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_news.isEmpty)
                        _buildEmptyState(
                          icon: Icons.article,
                          title: 'Aucune actualité publiée',
                          message:
                              'Créez votre première actualité pour qu\'elle apparaisse ici',
                        )
                      else
                        ..._news.map((news) => _buildNewsCard(news)),
                    ],
                  ),
                ),

                // Onglet 2: Brouillons
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brouillons (${_draftNews.length})',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_draftNews.isEmpty)
                        _buildEmptyState(
                          icon: Icons.drafts,
                          title: 'Aucun brouillon',
                          message:
                              'Créez des actualités et sauvegardez-les comme brouillons',
                        )
                      else
                        ..._draftNews.map(
                          (news) => _buildNewsCard(news, isDraft: true),
                        ),
                    ],
                  ),
                ),

                // Onglet 3: Statistiques
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsCard(),
                      const SizedBox(height: 24),

                      // Statistiques par catégorie
                      Text(
                        'Par catégorie',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Column(
                          children: _categories.map((category) {
                            final categoryNews = _news
                                .where((n) => n.category == category)
                                .toList();
                            final categoryViews = categoryNews.fold<int>(
                              0,
                              (sum, news) => sum + news.views,
                            );

                            return ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(
                                    category,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    category.substring(0, 1),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: _getCategoryColor(category),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(category),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${categoryNews.length} articles',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$categoryViews vues',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Actualités les plus vues
                      Text(
                        'Actualités les plus populaires',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_news.isNotEmpty)
                        ..._news
                            .sortedBy((news) => news.views, descending: true)
                            .take(5)
                            .map(
                              (news) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.trending_up,
                                      color: AppColors.success,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${news.views} vues',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
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
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: _tabController.index == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showCreateNewsDialog(),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle actualité'),
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
}

// Extension pour trier les listes
extension ListExtensions<T> on List<T> {
  List<T> sortedBy(Comparable Function(T) selector, {bool descending = false}) {
    final list = [...this];
    list.sort((a, b) {
      final aVal = selector(a);
      final bVal = selector(b);
      return descending ? bVal.compareTo(aVal) : aVal.compareTo(bVal);
    });
    return list;
  }
}
