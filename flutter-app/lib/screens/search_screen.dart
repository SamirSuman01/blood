import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/bottom_navigation.dart' as custom_nav;
import '../components/location_selector.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  String bloodType = 'A+';
  Map<String, dynamic> location = {
    'district': 'Bengaluru Urban',
    'stateCode': 'KA',
    'area': 'Jayanagar'
  };

  bool isLoading = true;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> banks = [
    {
      'distance': 2.3,
      'units': 12,
      'verified': true,
      'verificationSource': 'official',
      'lastUpdatedMinutes': 8,
      'name': 'Victoria Hospital Blood Bank',
      'phone': '080-2670-1150',
      'latitude': 12.9716,
      'longitude': 77.5946
    },
    {
      'distance': 3.7,
      'units': 3,
      'verified': true,
      'verificationSource': 'official',
      'lastUpdatedMinutes': 34,
      'name': 'Jayadeva Hospital Blood Bank',
      'phone': '080-2294-4464',
      'latitude': 12.9141,
      'longitude': 77.5963
    },
    {
      'distance': 5.1,
      'units': 0,
      'verified': false,
      'verificationSource': null,
      'lastUpdatedMinutes': 23,
      'name': 'Apollo Blood Bank',
      'phone': '080-2630-4050',
      'latitude': 12.8996,
      'longitude': 77.6055
    },
    {
      'distance': 8.9,
      'units': 18,
      'verified': true,
      'verificationSource': 'official',
      'lastUpdatedMinutes': 15,
      'name': 'Manipal Hospital Blood Bank',
      'phone': '080-2502-4444',
      'latitude': 12.9611,
      'longitude': 77.6387
    },
    {
      'distance': 11.2,
      'units': 5,
      'verified': true,
      'verificationSource': 'crowdsourced',
      'confirmationCount': 47,
      'lastUpdatedMinutes': 120,
      'name': 'BGS Global Hospital',
      'phone': '080-4696-9696',
      'latitude': 12.9082,
      'longitude': 77.4850
    }
  ];

  @override
  void initState() {
    super.initState();
    // Card entrance animation - slow timing (350ms per spec)
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 500));

    // Sort banks: Priority 1 = Availability, Priority 2 = Distance
    banks.sort((a, b) {
      // Available banks come first
      if (a['units'] > 0 && b['units'] == 0) return -1;
      if (a['units'] == 0 && b['units'] > 0) return 1;

      // If both have stock, sort by distance
      if (a['units'] > 0 && b['units'] > 0) {
        return a['distance'].compareTo(b['distance']);
      }

      // If both are out of stock, sort by distance
      return a['distance'].compareTo(b['distance']);
    });

    setState(() {
      bloodType = prefs.getString('bloodType') ?? 'A+';
      isLoading = false;
    });
    _animationController.forward();
  }

  Future<void> saveBloodType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bloodType', type);
    setState(() {
      bloodType = type;
    });
  }

  void showLocationSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: LocationSelector(
            initialState: location['state'],
            initialDistrict: location['district'],
            onLocationSelected: (state, district, stateCode) {
              setState(() {
                location = {
                  'state': state,
                  'district': district,
                  'stateCode': stateCode,
                };
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> autoDetectLocation() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate geolocation API call (in real app, use geolocator package)
      await Future.delayed(Duration(seconds: 1));

      // For demo: Set to detected location
      // In real app, use: Position position = await Geolocator.getCurrentPosition();
      // Then reverse geocode to get district and state

      setState(() {
        location = {
          'district': 'Bengaluru Urban',
          'stateCode': 'KA',
          'area': 'Auto-detected',
        };
        isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📍 Location detected successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF059669),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to detect location. Please select manually.'),
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final isDesktop = screenWidth >= 900;

    // Max width matching index.html
    final maxWidth = 480.0;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Color(0xFFDC2626),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Near Me',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Find blood. Save lives.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 20,
                    vertical: isMobile ? 12 : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFFDC2626), size: isMobile ? 18 : 22),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${location['district']} (${location['stateCode']})',
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (location['area'] != null)
                                  Text(
                                    location['area'],
                                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Auto-detect location button
                              IconButton(
                                icon: Icon(Icons.my_location, size: 20),
                                color: Color(0xFF059669),
                                onPressed: autoDetectLocation,
                                tooltip: 'Auto-detect location',
                                padding: EdgeInsets.all(8),
                                constraints: BoxConstraints(),
                              ),
                              SizedBox(width: 4),
                              // Change location button
                              IconButton(
                                icon: Icon(Icons.edit_location_alt, size: 20),
                                color: Color(0xFFDC2626),
                                onPressed: showLocationSelector,
                                tooltip: 'Change location',
                                padding: EdgeInsets.all(8),
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.bloodtype, color: Color(0xFFDC2626), size: 20),
                          SizedBox(width: 8),
                          Text('Blood Type:', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: bloodType,
                              underline: SizedBox(),
                              dropdownColor: Color(0xFFDC2626),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((type) {
                                return DropdownMenuItem(value: type, child: Text(type));
                              }).toList(),
                              onChanged: (value) => saveBloodType(value!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 1),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 20,
                    vertical: isMobile ? 10 : 12,
                  ),
                  child: isMobile
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/sos'),
                                icon: Icon(Icons.emergency, size: 20),
                                label: Text('Emergency SOS'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                                icon: Icon(Icons.volunteer_activism, size: 20),
                                label: Text('Register as Donor'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color(0xFFDC2626),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(color: Color(0xFFDC2626), width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/sos'),
                                icon: Icon(Icons.emergency, size: 20),
                                label: Text('Emergency SOS'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                                icon: Icon(Icons.volunteer_activism, size: 20),
                                label: Text('Register'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color(0xFFDC2626),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  side: BorderSide(color: Color(0xFFDC2626), width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 16,
                      vertical: isMobile ? 8 : 12,
                    ),
                    itemCount: banks.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _animationController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                          )),
                          child: BloodBankCard(
                            bank: banks[index],
                            isMobile: isMobile,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
                ),
              ),
            ),
      bottomNavigationBar: custom_nav.BottomNavigationBar(currentRoute: '/'),
    );
  }
}

class BloodBankCard extends StatelessWidget {
  final Map<String, dynamic> bank;
  final bool isMobile;

  BloodBankCard({required this.bank, this.isMobile = true});

  // Calculate trust score (0-5 scale)
  double getTrustScore() {
    if (bank['verified']) {
      if (bank['verificationSource'] == 'official') return 5.0;
      if (bank['verificationSource'] == 'crowdsourced') {
        int count = bank['confirmationCount'] ?? 0;
        if (count >= 40) return 4.5;
        if (count >= 20) return 4.0;
        if (count >= 10) return 3.5;
        return 3.0;
      }
    }
    return 1.5;
  }

  String getTrustDisplay() {
    if (bank['verified']) {
      if (bank['verificationSource'] == 'official') return 'Official';
      if (bank['verificationSource'] == 'crowdsourced') {
        return '${bank['confirmationCount']} verifications';
      }
    }
    return 'Unverified';
  }

  Color getTrustColor() {
    if (bank['verified']) {
      if (bank['verificationSource'] == 'official') return Color(0xFF059669); // success green
      if (bank['verificationSource'] == 'crowdsourced') return Color(0xFF0284C7); // info blue
    }
    return Color(0xFF737373); // neutral gray
  }

  // Build star rating widget
  Widget buildStarRating() {
    double score = getTrustScore();
    int fullStars = score.floor();
    bool hasHalfStar = (score - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, size: 14, color: Color(0xFFD97706)); // warning/gold color
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, size: 14, color: Color(0xFFD97706));
        } else {
          return Icon(Icons.star_border, size: 14, color: Color(0xFFD4D4D4));
        }
      }),
    );
  }

  String getTimestampDisplay() {
    int minutes = bank['lastUpdatedMinutes'];
    if (minutes > 60) {
      int hours = (minutes / 60).floor();
      return 'Updated $hours hr ago';
    }
    return 'Updated $minutes min ago';
  }

  void call() async {
    final url = 'tel:${bank['phone']}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void openMaps() async {
    final url = 'https://maps.google.com/?q=${bank['latitude']},${bank['longitude']}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool shouldStrike = bank['lastUpdatedMinutes'] > 1440;
    bool lowStock = bank['units'] < 5 && bank['units'] > 0;
    bool unavailable = bank['units'] == 0;

    // Determine left border color based on availability
    Color leftBorderColor;
    if (unavailable) {
      leftBorderColor = Color(0xFFD4D4D4); // gray
    } else if (lowStock) {
      leftBorderColor = Color(0xFFD97706); // orange/warning
    } else {
      leftBorderColor = Color(0xFF059669); // green/success
    }

    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 10 : 12),
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
      child: Stack(
        children: [
          // Colored left border
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: leftBorderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          // Card content
          InkWell(
            onTap: openMaps,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 20,
                isMobile ? 12 : 16,
                isMobile ? 12 : 16,
                isMobile ? 12 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Color(0xFFDC2626)),
                        SizedBox(width: 4),
                        Text(
                          '${bank['distance'].toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Star rating
                      buildStarRating(),
                      SizedBox(height: 4),
                      // Trust badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getTrustColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: getTrustColor(), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              bank['verified'] ? Icons.verified : Icons.info_outline,
                              size: 12,
                              color: getTrustColor(),
                            ),
                            SizedBox(width: 4),
                            Text(
                              getTrustDisplay(),
                              style: TextStyle(fontSize: 11, color: getTrustColor(), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 10 : 12),
              Text(
                bank['name'],
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              // Phone number - visible before button (CRITICAL for emergency)
              GestureDetector(
                onTap: call,
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Color(0xFFDC2626)),
                    SizedBox(width: 6),
                    Text(
                      bank['phone'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 10 : 12),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: lowStock
                          ? Colors.orange.withOpacity(0.1)
                          : bank['units'] == 0
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 18,
                          color: lowStock
                              ? Colors.orange
                              : bank['units'] == 0
                                  ? Colors.red
                                  : Colors.green,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${bank['units']} units',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: lowStock
                                ? Colors.orange[800]
                                : bank['units'] == 0
                                    ? Colors.red[800]
                                    : Colors.green[800],
                            decoration: shouldStrike ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    getTimestampDisplay(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 10 : 12),
              isMobile
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: call,
                            icon: Icon(Icons.phone, size: 18),
                            label: Text(
                              bank['phone'],
                              style: TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDC2626),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: openMaps,
                            icon: Icon(Icons.directions, size: 18),
                            label: Text('Get Directions'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFFDC2626),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Color(0xFFDC2626)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: call,
                            icon: Icon(Icons.phone, size: 18),
                            label: Text(bank['phone']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDC2626),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: openMaps,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFFDC2626),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            elevation: 0,
                            side: BorderSide(color: Color(0xFFDC2626)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Icon(Icons.directions),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }
}
