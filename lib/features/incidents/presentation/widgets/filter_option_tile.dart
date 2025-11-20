// dart
import 'package:flutter/material.dart';

class FilterOptionTile extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelect;

  const FilterOptionTile({super.key, required this.label, required this.value, required this.selectedValue, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFFF25F0D) : Colors.black87)),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFF25F0D)) : null,
      onTap: () {
        onSelect(value);
        Navigator.pop(context);
      },
    );
  }
}