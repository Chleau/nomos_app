// dart
import 'package:flutter/material.dart';

class SignalementFilterChip extends StatelessWidget {
  final String label;
  final String value;
  final int count;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const SignalementFilterChip({
    super.key,
    required this.label,
    required this.value,
    required this.count,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      selectedColor: const Color(0xFFF25F0D),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
    );
  }
}