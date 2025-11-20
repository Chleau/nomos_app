import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/commune.dart';
import '../providers/auth_providers.dart';

/// Widget de recherche de commune avec autocomplete
class CommuneSearchField extends ConsumerStatefulWidget {
  final Function(Commune?) onCommuneSelected;
  final Commune? initialCommune;

  const CommuneSearchField({
    super.key,
    required this.onCommuneSelected,
    this.initialCommune,
  });

  @override
  ConsumerState<CommuneSearchField> createState() => _CommuneSearchFieldState();
}

class _CommuneSearchFieldState extends ConsumerState<CommuneSearchField> {
  Commune? _selectedCommune;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCommune = widget.initialCommune;
    if (_selectedCommune != null) {
      _textController.text = _selectedCommune.toString();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communesAsync = ref.watch(communesProvider);

    return communesAsync.when(
      data: (communes) => Autocomplete<Commune>(
        displayStringForOption: (commune) => commune.toString(),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<Commune>.empty();
          }
          return communes.where((commune) {
            final searchLower = textEditingValue.text.toLowerCase();
            return commune.nom.toLowerCase().contains(searchLower) ||
                commune.codePostal.contains(textEditingValue.text);
          });
        },
        onSelected: (Commune commune) {
          setState(() {
            _selectedCommune = commune;
          });
          widget.onCommuneSelected(commune);
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted,
        ) {
          return TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: InputDecoration(
              labelText: 'Commune',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_city),
              helperText: 'Recherchez votre commune par nom ou code postal',
              suffixIcon: _selectedCommune != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        fieldTextEditingController.clear();
                        setState(() {
                          _selectedCommune = null;
                        });
                        widget.onCommuneSelected(null);
                      },
                    )
                  : null,
            ),
            validator: (value) {
              if (_selectedCommune == null) {
                return 'Veuillez sélectionner une commune';
              }
              return null;
            },
          );
        },
      ),
      loading: () => TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          labelText: 'Commune',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.location_city),
          helperText: 'Chargement des communes...',
          suffixIcon: SizedBox(
            width: 20,
            height: 20,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
      error: (error, stack) => TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Commune',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.error, color: Colors.red),
          helperText: 'Erreur de chargement des communes',
          errorText: error.toString(),
        ),
      ),
    );
  }
}

