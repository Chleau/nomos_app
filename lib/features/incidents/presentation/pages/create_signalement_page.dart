import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/signalements_providers.dart';

/// Page de création d'un nouveau signalement avec stepper en 3 étapes
class CreateSignalementPage extends ConsumerStatefulWidget {
  const CreateSignalementPage({super.key});

  @override
  ConsumerState<CreateSignalementPage> createState() => _CreateSignalementPageState();
}

class _CreateSignalementPageState extends ConsumerState<CreateSignalementPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Data
  int? _selectedTypeId;
  double? _latitude;
  double? _longitude;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Charger les types de signalement
    Future.microtask(() {
      ref.read(signalementsNotifierProvider.notifier).loadTypesSignalement();
    });
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _photo = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _latitude = 48.8566;
      _longitude = 2.3522;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Position récupérée')),
      );
    }
  }

  Future<void> _createSignalement() async {
    final user = ref.read(authNotifierProvider).user;
    if (user == null) return;

    print('🚀 Création signalement');
    print('   - Photo sélectionnée: ${_photo != null ? "OUI (${_photo!.path})" : "NON"}');

    final success = await ref.read(signalementsNotifierProvider.notifier).createSignalement(
          habitantId: user.id,
          communeId: user.communeId,
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          latitude: _latitude,
          longitude: _longitude,
          typeId: _selectedTypeId,
          nom: user.nom,
          prenom: user.prenom,
          email: user.email,
          telephone: null,
          photo: _photo,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signalement créé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  bool _canContinue() {
    if (_currentStep == 0) {
      // Étape 1 : Type, titre et description requis
      return _selectedTypeId != null &&
          _titreController.text.trim().isNotEmpty &&
          _descriptionController.text.trim().isNotEmpty;
    } else if (_currentStep == 1) {
      // Étape 2 : Au moins la localisation
      return _latitude != null && _longitude != null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final signalementsState = ref.watch(signalementsNotifierProvider);
    final user = ref.watch(authNotifierProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFE6ECEF),
      appBar: AppBar(
        title: const Text('Signaler un incident en ligne'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },
          onStepContinue: () {
            if (_currentStep < 2) {
              if (_canContinue()) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez remplir tous les champs requis')),
                );
              }
            } else {
              // Dernière étape - créer le signalement
              _createSignalement();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: signalementsState.isLoading ? null : details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentStep == 2 ? 'Envoyer' : 'Suivant',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            // Étape 1 : L'incident
            Step(
              title: const Text('Incident'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type d'incident
                  const Text(
                    'Type d\'incident *',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      hintText: 'Sélectionnez la catégorie',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: signalementsState.typesSignalement.map((type) {
                      return DropdownMenuItem<int>(
                        value: type.id,
                        child: Text(type.libelle),
                      );
                    }).toList(),
                    initialValue: _selectedTypeId,
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Titre du problème
                  const Text(
                    'Titre du problème *',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titreController,
                    decoration: InputDecoration(
                      hintText: 'Titre du problème',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description/Message
                  const Text(
                    'Message *',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Expliquez ce qui pose problème avec le plus de détails possibles',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Étape 2 : Localisation et photo
            Step(
              title: const Text('Localisation'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Localisation
                  const Text(
                    'Localisation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Utiliser ma position'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25F0D),
                    ),
                  ),
                  if (_latitude != null && _longitude != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Position : ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Photo
                  const Text(
                    'Ajouter une photo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Appareil photo'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galerie'),
                        ),
                      ),
                    ],
                  ),
                  if (_photo != null) ...[
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _photo!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _photo = null;
                              });
                            },
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Étape 3 : Récapitulatif
            Step(
              title: const Text('Confirmation'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Récapitulatif',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Infos du signalement
                  _buildRecapCard(
                    'Type',
                    () {
                      if (_selectedTypeId == null || signalementsState.typesSignalement.isEmpty) {
                        return 'Non sélectionné';
                      }
                      try {
                        final type = signalementsState.typesSignalement.firstWhere(
                          (t) => t.id == _selectedTypeId,
                        );
                        return type.libelle;
                      } catch (e) {
                        return 'Type inconnu';
                      }
                    }(),
                  ),
                  _buildRecapCard('Titre', _titreController.text),
                  _buildRecapCard('Description', _descriptionController.text),
                  _buildRecapCard(
                    'Localisation',
                    _latitude != null && _longitude != null
                        ? '${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}'
                        : 'Non renseignée',
                  ),
                  _buildRecapCard('Photo', _photo != null ? 'Ajoutée' : 'Aucune'),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Infos personnelles
                  if (user != null) ...[
                    const Text(
                      'Vos informations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildRecapCard('Nom', '${user.prenom} ${user.nom}'),
                    _buildRecapCard('Email', user.email),
                  ],

                  if (signalementsState.error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              signalementsState.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecapCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
