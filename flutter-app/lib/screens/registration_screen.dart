import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/bottom_navigation.dart' as custom_nav;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String bloodType = 'A+';
  String state = 'KA';
  String district = 'Bengaluru Urban';
  bool isRegistering = false;

  final Map<String, String> states = {
    'KA': 'Karnataka',
    'MH': 'Maharashtra',
    'TN': 'Tamil Nadu',
    'DL': 'Delhi',
    'WB': 'West Bengal'
  };

  final Map<String, List<String>> districts = {
    'KA': ['Bengaluru Urban', 'Bengaluru Rural', 'Mysuru', 'Mangaluru'],
    'MH': ['Mumbai Suburban', 'Mumbai City', 'Pune', 'Nagpur'],
    'TN': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli'],
    'DL': ['Central Delhi', 'North Delhi', 'South Delhi', 'East Delhi'],
    'WB': ['Kolkata', 'Howrah', 'North 24 Parganas', 'South 24 Parganas']
  };

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bloodType = prefs.getString('bloodType') ?? 'A+';
    });
  }

  Future<void> handleRegister() async {
    setState(() {
      isRegistering = true;
    });

    await Future.delayed(Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bloodType', bloodType);
    await prefs.setString('location', '$district,$state');
    await prefs.setBool('isDonor', true);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('You\'re now registered as a donor!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isDesktop = screenWidth >= 900;
    final maxWidth = 480.0; // Match index.html max-width

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Color(0xFFDC2626), // Match index.html primary color
        centerTitle: false,
        title: Text(
          'Become a Donor',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFDC2626),
                    Color(0xFF991B1B),
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 32,
                24,
                isMobile ? 16 : 32,
                isMobile ? 32 : 40,
              ),
              child: Column(
                children: [
                  Text(
                    '❤️',
                    style: TextStyle(fontSize: 64),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Save Lives',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get instant alerts when someone nearby needs your blood type',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm Your Details',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),

                  // Blood Type Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '🩸',
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Blood Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF404040),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: bloodTypes.map((type) {
                              bool isSelected = bloodType == type;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bloodType = type;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  width: 65,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Color(0xFFDC2626) : Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? Color(0xFFDC2626) : Color(0xFFD4D4D4),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    type,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? Colors.white : Color(0xFF404040),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Location Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE5E5E5), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '📍',
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF404040),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: state,
                            decoration: InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: states.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                state = value!;
                                district = districts[state]![0];
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: district,
                            decoration: InputDecoration(
                              labelText: 'District',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: districts[state]!.map((d) {
                              return DropdownMenuItem(value: d, child: Text(d));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                district = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Info Box
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFDCEBFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFBFDBFE), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ℹ️', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'We\'ll only ask for your contact info when you respond to an SOS',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E3A8A),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isRegistering ? null : handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Color(0xFFDC2626).withOpacity(0.6),
                        elevation: 0,
                        shadowColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ).copyWith(
                        elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return 0;
                            }
                            return 6;
                          },
                        ),
                      ),
                      child: isRegistering
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Register as Donor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: custom_nav.BottomNavigationBar(currentRoute: '/register'),
    );
  }
}
