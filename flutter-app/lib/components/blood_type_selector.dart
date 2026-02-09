import 'package:flutter/material.dart';

class BloodTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  BloodTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedType,
            items: bloodTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
          SizedBox(width: 8),
          Text('[change]'),
        ],
      ),
    );
  }
}
