import 'package:flutter/material.dart';
import 'package:sama_ufr/service/firestore_service.dart';

class AddFormationForm extends StatefulWidget {
  const AddFormationForm({super.key});

  @override
  _AddFormationFormState createState() => _AddFormationFormState();
}

class _AddFormationFormState extends State<AddFormationForm> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedUFR;
  String? _selectedLevel;
  String? _selectedDepartment;

  List<String> _ufrList = [];
  List<String> _departmentList = [];
  final List<String> _levelList = ['L1', 'L2', 'L3', 'M1', 'M2', 'Doctorat'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _ufrList = await _firestoreService.getUFRs();
      _departmentList = await _firestoreService.getDepartments();
    } catch (e) {
      print('Erreur chargement données: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUFR == null ||
          _selectedLevel == null ||
          _selectedDepartment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez remplir tous les champs obligatoires'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final success = await _firestoreService.addFormation(
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        ufr: _selectedUFR!,
        level: _selectedLevel!,
        description: _descriptionController.text.trim(),
        department: _selectedDepartment!,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Formation ajoutée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout de la formation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Ajouter une nouvelle formation'),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom de la formation
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom de la formation*',
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le nom de la formation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Code de la formation
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Code formation*',
                        prefixIcon: Icon(Icons.code),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le code de la formation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Sélection UFR
                    DropdownButtonFormField<String>(
                      initialValue: _selectedUFR,
                      decoration: InputDecoration(
                        labelText: 'UFR*',
                        prefixIcon: Icon(Icons.account_balance),
                        border: OutlineInputBorder(),
                      ),
                      items: _ufrList.map((ufr) {
                        return DropdownMenuItem(value: ufr, child: Text(ufr));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUFR = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une UFR';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Sélection Département
                    DropdownButtonFormField<String>(
                      initialValue: _selectedDepartment,
                      decoration: InputDecoration(
                        labelText: 'Département*',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                      items: _departmentList.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un département';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Sélection Niveau
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLevel,
                      decoration: InputDecoration(
                        labelText: 'Niveau*',
                        prefixIcon: Icon(Icons.timeline),
                        border: OutlineInputBorder(),
                      ),
                      items: _levelList.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLevel = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un niveau';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description (optionnel)',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text('Ajouter la formation'),
        ),
      ],
    );
  }
}
