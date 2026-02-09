import 'package:flutter/material.dart';
import '../data/indian_locations.dart';

class LocationSelector extends StatefulWidget {
  final String? initialState;
  final String? initialDistrict;
  final Function(String state, String district, String stateCode) onLocationSelected;

  const LocationSelector({
    Key? key,
    this.initialState,
    this.initialDistrict,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? selectedState;
  String? selectedDistrict;
  List<String> states = [];
  List<String> districts = [];

  @override
  void initState() {
    super.initState();
    states = IndianLocations.getStates();
    selectedState = widget.initialState;
    if (selectedState != null) {
      districts = IndianLocations.getDistricts(selectedState!);
      selectedDistrict = widget.initialDistrict;
    }
  }

  void _onStateChanged(String? state) {
    if (state == null) return;

    setState(() {
      selectedState = state;
      districts = IndianLocations.getDistricts(state);
      selectedDistrict = null; // Reset district when state changes
    });
  }

  void _onDistrictChanged(String? district) {
    if (district == null || selectedState == null) return;

    setState(() {
      selectedDistrict = district;
    });

    // Notify parent
    final stateCode = IndianLocations.getStateCode(selectedState!);
    widget.onLocationSelected(selectedState!, district, stateCode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFDC2626), size: 24),
              SizedBox(width: 12),
              Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF171717),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // State/UT Dropdown
          Text(
            'State / Union Territory',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF404040),
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFE5E5E5), width: 1),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedState,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
                hintText: 'Choose state or UT',
                hintStyle: TextStyle(color: Color(0xFF737373)),
              ),
              items: states.map((state) {
                final type = IndianLocations.getType(state);
                final code = IndianLocations.getStateCode(state);
                return DropdownMenuItem(
                  value: state,
                  child: Text(
                    '$state ($code)',
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: _onStateChanged,
            ),
          ),

          if (selectedState != null) ...[
            SizedBox(height: 20),

            // District Dropdown
            Text(
              'District',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF404040),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E5E5), width: 1),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedDistrict,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  hintText: 'Choose district',
                  hintStyle: TextStyle(color: Color(0xFF737373)),
                ),
                items: districts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district, style: TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: _onDistrictChanged,
              ),
            ),
          ],

          if (selectedState != null && selectedDistrict != null) ...[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF059669), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF059669), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Location set to $selectedDistrict, ${IndianLocations.getStateCode(selectedState!)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
