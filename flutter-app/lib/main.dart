import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/search_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/sos_alert_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(BloodNearMeApp());
}

class BloodNearMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Near Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFDC2626),
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
        fontFamily: '-apple-system',
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF171717)),
        ),
        // Focus indicators for accessibility (P2 - MEDIUM PRIORITY)
        focusColor: Color(0xFFDC2626),
        // Input field focus indicators
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFDC2626),
              width: 3,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
        ),
        // Button focus indicators
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused)) {
                  return Color(0xFFDC2626).withOpacity(0.2);
                }
                return null;
              },
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused)) {
                  return Color(0xFFDC2626).withOpacity(0.2);
                }
                return null;
              },
            ),
            side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused)) {
                  return BorderSide(
                    color: Color(0xFFDC2626),
                    width: 3,
                  );
                }
                return BorderSide(
                  color: Color(0xFFDC2626),
                  width: 1.5,
                );
              },
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SearchScreen(),
        '/sos': (context) => SOSScreen(),
        '/alert': (context) => SOSAlertScreen(),
        '/register': (context) => RegistrationScreen(),
      },
    );
  }
}
