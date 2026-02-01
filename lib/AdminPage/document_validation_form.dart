import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:sama_ufr/service/firestore_service.dart';

class DocumentValidationForm extends StatefulWidget {
  final String documentId;
  final String documentTitle;
  final String studentEmail;
  final String documentType;

  const DocumentValidationForm({
    super.key,
    required this.documentId,
    required this.documentTitle,
    required this.studentEmail,
    required this.documentType,
  });

  @override
  _DocumentValidationFormState createState() => _DocumentValidationFormState();
}

class _DocumentValidationFormState extends State<DocumentValidationForm> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _commentsController = TextEditingController();
  File? _selectedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitValidation() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner un fichier PDF'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final success = await _firestoreService.validateAndSendDocument(
      documentId: widget.documentId,
      studentEmail: widget.studentEmail,
      documentType: widget.documentType,
      pdfFile: _selectedFile!,
      comments: _commentsController.text.trim(),
    );

    setState(() {
      _isUploading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document validé et envoyé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la validation'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Valider et Envoyer le Document'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.description, color: Colors.blue),
              title: Text(widget.documentTitle),
              subtitle: Text('Pour: ${widget.studentEmail}'),
            ),
            SizedBox(height: 16),

            // Section fichier PDF
            Text(
              'Document à envoyer (PDF)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _selectedFile != null
                ? ListTile(
                    leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(_selectedFile!.path.split('/').last),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _selectedFile = null),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: Icon(Icons.attach_file),
                    label: Text('Sélectionner un PDF'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
            SizedBox(height: 16),

            // Commentaires
            Text(
              'Commentaires (optionnel)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ajouter des commentaires...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Types de documents communs
            Text(
              'Type de document:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: [
                _buildDocumentChip('Attestation de réussite'),
                _buildDocumentChip('Diplôme'),
                _buildDocumentChip('Relevé de notes'),
                _buildDocumentChip('Attestation de scolarité'),
                _buildDocumentChip('Certificat'),
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
          onPressed: _isUploading ? null : _submitValidation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: _isUploading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text('Valider et Envoyer'),
        ),
      ],
    );
  }

  Widget _buildDocumentChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: widget.documentType == label,
      onSelected: (selected) {
        // Type déjà défini via widget
      },
    );
  }
}
