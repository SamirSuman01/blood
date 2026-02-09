import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSAlertScreen extends StatelessWidget {
  final Map<String, dynamic> sosData = {
    'bloodType': 'A+',
    'distance': 3.7,
    'urgency': 'CRITICAL',
    'district': 'Bengaluru Urban',
    'stateCode': 'KA',
    'phone': '9876543210'
  };

  void handleHelp() async {
    final url = 'tel:${sosData['phone']}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${sosData['bloodType']} needed',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                '${sosData['distance'].toStringAsFixed(1)} km    ${sosData['urgency']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '${sosData['district']} (${sosData['stateCode']})',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                sosData['phone'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 24),
              Container(
                height: 1,
                color: Color(0xFFE5E5E5),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: handleHelp,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE5E5E5)),
                    color: Color(0xFFDC2626),
                  ),
                  child: Text(
                    'I CAN HELP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 1,
                color: Color(0xFFE5E5E5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
