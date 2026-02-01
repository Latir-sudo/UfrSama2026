import 'package:flutter/material.dart';
import 'package:sama_ufr/service/teacher_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sama_ufr/EnsPage/resource_detail.dart';
import 'package:file_picker/file_picker.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  late final TeacherService _teacherService;
  late Future<List<Map<String, dynamic>>> _resourcesFuture;
  late Future<List<Map<String, dynamic>>> _availableDocumentsFuture;
  String? _selectedCourse;
  String? _selectedResourceType;
  String? _selectedFileName;
  PlatformFile? _selectedFile;
  final List<String> _resourceTypes = [
    'Cours',
    'TD',
    'TP',
    'Examen',
    'Correction',
  ];
  final List<String> _coursesList = [
    'Algorithmique - L2 Info',
    'Base de données - L1 Info',
    'Réseaux - L3 Info',
    'Programmation - L1 Info',
  ];

  @override
  void initState() {
    super.initState();
    _teacherService = TeacherService();
    _loadResources();
    _loadAvailableDocuments();
  }

  void _loadResources() {
    _resourcesFuture = _teacherService.getTeachingResources();
  }

  void _loadAvailableDocuments() {
    _availableDocumentsFuture = _teacherService.getAvailableDocuments();
  }

  void _updateResource(Map<String, dynamic> updatedResource) {
    setState(() {
      _loadResources();
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        _selectedFileName = _selectedFile!.name;
      });
    }
  }

  Future<void> _uploadResource() async {
    if (_selectedCourse == null ||
        _selectedResourceType == null ||
        _selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez remplir tous les champs et sélectionner un fichier',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Simuler l'upload
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Téléchargement en cours...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ressource téléchargée avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      // Réinitialiser les sélections
      setState(() {
        _selectedCourse = null;
        _selectedResourceType = null;
        _selectedFileName = null;
        _selectedFile = null;
      });

      // Recharger les ressources
      _loadResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Déposer une ressource
                  _buildUploadSection(),

                  const SizedBox(height: 32),

                  // Section Mes ressources
                  Text(
                    'Mes ressources',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Affichage dynamique des ressources
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _resourcesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingResources();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyResources();
                      }

                      return _buildResourcesList(resources: snapshot.data!);
                    },
                  ),

                  const SizedBox(height: 32),

                  // Section Documents disponibles
                  Text(
                    'Documents disponibles',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Affichage des documents disponibles
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _availableDocumentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingDocuments();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyDocuments();
                      }

                      return _buildAvailableDocumentsList(
                        documents: snapshot.data!,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 132, 69, 150),
                      const Color.fromARGB(255, 53, 120, 186),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Déposer une ressource',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sélection du cours
          _buildDropdownField(
            label: 'Sélectionner un cours',
            value: _selectedCourse,
            items: _coursesList,
            icon: Icons.book,
            onChanged: (value) {
              setState(() {
                _selectedCourse = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Type de ressource
          _buildDropdownField(
            label: 'Type de ressource',
            value: _selectedResourceType,
            items: _resourceTypes,
            icon: Icons.category,
            onChanged: (value) {
              setState(() {
                _selectedResourceType = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Sélection de fichier
          _buildFilePicker(),

          const SizedBox(height: 24),

          // Bouton Déposer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _uploadResource,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 141, 81, 158),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Déposer la ressource',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              isExpanded: true,
              hint: Row(
                children: [
                  Icon(icon, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Sélectionner...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        item,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fichier',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.attach_file,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedFileName ?? 'Sélectionner un fichier',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _selectedFileName != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                          fontWeight: _selectedFileName != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                      if (_selectedFileName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Taille: ${_selectedFile != null ? '${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB' : 'N/A'}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.file_upload, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
        if (_selectedFileName != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.green.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Fichier sélectionné: $_selectedFileName',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 16, color: Colors.red.shade600),
                onPressed: () {
                  setState(() {
                    _selectedFileName = null;
                    _selectedFile = null;
                  });
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingResources() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyResources() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Aucune ressource',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par déposer vos premières ressources',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesList({required List<Map<String, dynamic>> resources}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ressources téléchargées (${resources.length})',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: _showSortOptions,
              ),
            ],
          ),
        ),
        ...resources.map((resource) {
          return _buildResourceItem(resource);
        }),
      ],
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> resource) {
    final iconColor = _getIconColorForType(resource['type'] ?? 'PDF');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResourceDetailPage(
              resource: resource,
              onUpdate: _updateResource,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: iconColor.withOpacity(0.3)),
              ),
              child: Icon(
                _getIconForType(resource['type'] ?? 'PDF'),
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['title'] ?? 'Sans titre',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          resource['type'] ?? 'PDF',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: iconColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.book, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        resource['courseId'] ?? 'Général',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Téléchargé le: ${resource['uploadDate'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.download, color: Colors.blue.shade600),
                  onPressed: () => _downloadResource(resource),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
                  onPressed: () => _showResourceActions(resource),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDocuments() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyDocuments() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.library_books, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Aucun document disponible',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les documents officiels apparaîtront ici',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableDocumentsList({
    required List<Map<String, dynamic>> documents,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.library_books,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Documents officiels',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ),
            ],
          ),
        ),
        ...documents.map((document) {
          return _buildDocumentItem(document);
        }),
      ],
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> document) {
    final iconColor = _getIconColorForType(document['type'] ?? 'PDF');

    return GestureDetector(
      onTap: () => _openDocument(document),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: iconColor.withOpacity(0.3)),
              ),
              child: Icon(
                _getIconForType(document['type'] ?? 'PDF'),
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document['title'] ?? 'Sans titre',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    document['description'] ?? 'Document officiel',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          document['category'] ?? 'Général',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          document['type'] ?? 'PDF',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue.shade600),
              onPressed: () => _openDocument(document),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'word':
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'excel':
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'powerpoint':
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'word':
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'excel':
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'powerpoint':
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _downloadResource(Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Télécharger'),
        content: Text('Télécharger "${resource['title']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Téléchargement de "${resource['title']}"'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Télécharger'),
          ),
        ],
      ),
    );
  }

  void _showResourceActions(Map<String, dynamic> resource) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('Voir les détails'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResourceDetailPage(
                      resource: resource,
                      onUpdate: _updateResource,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: const Text('Télécharger'),
              onTap: () {
                Navigator.pop(context);
                _downloadResource(resource);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                _showEditResourceDialog(resource);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Supprimer'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteResourceDialog(resource);
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditResourceDialog(Map<String, dynamic> resource) {
    // Similaire à la fonction dans resource_detail.dart
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la ressource'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: resource['title'],
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: resource['description'],
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ressource modifiée avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteResourceDialog(Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer "${resource['title']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete resource logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${resource['title']}" supprimé'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _openDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document['title'] ?? 'Document'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              Icon(
                _getIconForType(document['type'] ?? 'PDF'),
                size: 80,
                color: Colors.blue.shade300,
              ),
              const SizedBox(height: 20),
              Text(
                document['description'] ?? 'Document officiel',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ce document est disponible en téléchargement',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadResource(document);
            },
            child: const Text('Télécharger'),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Trier par',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Nom (A-Z)'),
              trailing: const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.pop(context);
                // Sort logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Date (récent)'),
              onTap: () {
                Navigator.pop(context);
                // Sort logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Type'),
              onTap: () {
                Navigator.pop(context);
                // Sort logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Cours'),
              onTap: () {
                Navigator.pop(context);
                // Sort logic
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
