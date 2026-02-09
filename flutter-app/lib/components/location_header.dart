import 'package:flutter/material.dart';

class LocationHeader extends StatelessWidget {
  final String district;
  final String stateCode;
  final String? area;

  LocationHeader({
    required this.district,
    required this.stateCode,
    this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$district ($stateCode)',
            style: TextStyle(fontSize: 16),
          ),
          if (area != null)
            Text(
              area!,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
        ],
      ),
    );
  }
}
