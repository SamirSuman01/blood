import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/location_header.dart';
import '../components/blood_type_selector.dart';
import '../components/bottom_navigation.dart' as custom_nav;

class SOSScreen extends StatefulWidget {
  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  String bloodType = 'A+';
  Map<String, dynamic> location = {
    'district': 'Bengaluru Urban',
    'stateCode': 'KA',
    'area': 'Jayanagar'
  };
  int radius = 3;
  int donorCount = 47;
  bool sent = false;
  bool error = false;
  String errorMessage = '';
  bool isLoading = false;
  String loadingMessage = '';
  DateTime? lastSentTime;
  int remainingCooldown = 0;
  Timer? cooldownTimer;
  static const int RATE_LIMIT_SECONDS = 60;

  @override
  void initState() {
    super.initState();
    loadData();
    checkCooldown();
  }

  @override
  void dispose() {
    cooldownTimer?.cancel();
    super.dispose();
  }

  void checkCooldown() {
    if (lastSentTime != null) {
      final elapsed = DateTime.now().difference(lastSentTime!).inSeconds;
      if (elapsed < RATE_LIMIT_SECONDS) {
        setState(() {
          remainingCooldown = RATE_LIMIT_SECONDS - elapsed;
        });
        startCooldownTimer();
      }
    }
  }

  void startCooldownTimer() {
    cooldownTimer?.cancel();
    cooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingCooldown > 0) {
        setState(() {
          remainingCooldown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  bool get isRateLimited => remainingCooldown > 0;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bloodType = prefs.getString('bloodType') ?? 'A+';
    });
  }

  void updateRadius(int newRadius) {
    setState(() {
      radius = newRadius;
      final counts = {1: 12, 3: 47, 5: 134};
      donorCount = counts[radius] ?? 0;
    });
  }

  Future<void> sendSOS() async {
    // Check rate limit (HIGH PRIORITY - P1)
    if (isRateLimited) {
      return;
    }

    // Show confirmation dialog first (CRITICAL P0)
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text('⚠️', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Confirm Emergency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Blood Type: $bloodType',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Location: ${location['district']}, ${location['stateCode']}',
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 4),
              Text('Radius: ${radius}km',
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              Text('This will notify $donorCount nearby donors.',
                  style: TextStyle(fontSize: 14, color: Color(0xFFDC2626), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: Text('Confirm & Send'),
          ),
        ],
      ),
    );

    // If user cancelled, return
    if (confirmed != true) return;

    // Show loading overlay
    setState(() {
      error = false;
      errorMessage = '';
      isLoading = true;
      loadingMessage = 'Sending emergency alert...';
    });

    try {
      await Future.delayed(Duration(milliseconds: 500));

      // Update loading message
      setState(() {
        loadingMessage = 'Notifying $donorCount donors...';
      });

      await Future.delayed(Duration(milliseconds: 300));

      if (DateTime.now().millisecond % 10 == 0) {
        throw Exception('Failed');
      }

      setState(() {
        sent = true;
        isLoading = false;
        loadingMessage = '';
        lastSentTime = DateTime.now();
        remainingCooldown = RATE_LIMIT_SECONDS;
      });

      // Start cooldown timer
      startCooldownTimer();

      // Auto-dismiss after 4 seconds (HIGH PRIORITY spec)
      await Future.delayed(Duration(seconds: 4));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Determine error message based on error type
      String detailedError = 'Failed to send emergency alert';

      if (e.toString().contains('network') || e.toString().contains('connection')) {
        detailedError = 'Network error. Check your internet connection';
      } else if (e.toString().contains('timeout')) {
        detailedError = 'Request timed out. Please try again';
      } else if (e.toString().contains('server')) {
        detailedError = 'Server error. Please try again in a moment';
      } else {
        detailedError = 'Failed to send alert. Please try again';
      }

      setState(() {
        error = true;
        errorMessage = detailedError;
        isLoading = false;
        loadingMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
          children: [
            LocationHeader(
              district: location['district'],
              stateCode: location['stateCode'],
              area: location['area'],
            ),
            BloodTypeSelector(
              selectedType: bloodType,
              onChanged: (type) {
                setState(() {
                  bloodType = type;
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Radius:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    children: [1, 3, 5].map((r) {
                      return GestureDetector(
                        onTap: () => updateRadius(r),
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: radius == r ? Colors.black : Color(0xFFE5E5E5),
                            ),
                          ),
                          child: Text('${r}km'),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
              ),
              child: Text('$donorCount donors will get alert'),
            ),
            // Rate limit warning (HIGH PRIORITY - P1)
            if (isRateLimited && !sent)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFFEF3C7), // warning yellow background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFD97706), width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Color(0xFFD97706), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate limit active',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Please wait $remainingCooldown seconds before sending another alert.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Enhanced error state with detailed message
            if (error)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFFEE2E2), // error red background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFDC2626), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Failed to send alert',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: ElevatedButton.icon(
                        onPressed: sendSOS,
                        icon: Icon(Icons.refresh, size: 16),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: (sent || isRateLimited) ? null : sendSOS,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE5E5E5)),
                    color: sent
                        ? Color(0xFFE5E5E5)
                        : isRateLimited
                            ? Color(0xFFD4D4D4)
                            : Color(0xFFDC2626),
                  ),
                  child: Text(
                    sent
                        ? 'SENT'
                        : isRateLimited
                            ? 'PLEASE WAIT ($remainingCooldown s)'
                            : 'SEND SOS NOW',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (sent || isRateLimited) ? Color(0xFF737373) : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          // Loading overlay (HIGH PRIORITY - P1)
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(32),
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFDC2626),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 24),
                      Text(
                        loadingMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF171717),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: custom_nav.BottomNavigationBar(currentRoute: '/sos'),
    );
  }
}
