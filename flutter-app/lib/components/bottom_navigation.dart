import 'package:flutter/material.dart';

class BottomNavigationBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavigationBar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  void _navigateTo(BuildContext context, String route) {
    if (currentRoute != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.search,
            label: 'Search',
            route: '/',
            isActive: currentRoute == '/',
          ),
          _buildNavItem(
            context: context,
            icon: Icons.emergency,
            label: 'SOS',
            route: '/sos',
            isActive: currentRoute == '/sos',
          ),
          _buildNavItem(
            context: context,
            icon: Icons.volunteer_activism,
            label: 'Donate',
            route: '/register',
            isActive: currentRoute == '/register',
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person,
            label: 'Profile',
            route: '/profile',
            isActive: currentRoute == '/profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _navigateTo(context, route),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? Color(0xFFDC2626) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive ? Color(0xFFDC2626) : Color(0xFF737373),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? Color(0xFFDC2626) : Color(0xFF737373),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
