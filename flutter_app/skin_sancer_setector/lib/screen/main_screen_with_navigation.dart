import 'package:flutter/material.dart';

import 'history_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';

// Brand Color Palette
const Color deepBlue = Color(0xFF0038E3);
const Color midBlue = Color(0xFF2D6AFF);
const Color accentCyan = Color(0xFF00C6FF);
const Color backgroundColor = Color(0xFFF8FAFF); // Soft blue-tinted background

class MainScreenWithNavigation extends StatefulWidget {
  const MainScreenWithNavigation({super.key});

  @override
  State<MainScreenWithNavigation> createState() => _MainScreenWithNavigationState();
}

class _MainScreenWithNavigationState extends State<MainScreenWithNavigation> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const LibraryScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Applying global background color
      extendBody: true, // Allows content to flow behind the curved navbar
      body: _pages[currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(

      margin: const EdgeInsets.fromLTRB(20, 0, 20, 35), // Floating effect

      height: 78,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepBlue, midBlue,deepBlue],
          stops: [0.0, 0.55,0.99],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color:Colors.blueAccent,width: 2),
        boxShadow: [
          BoxShadow(
            color: deepBlue.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, Icons.grid_view_rounded, "Home"),
          _navItem(1, Icons.auto_stories_rounded, "Library"),
          _navItem(2, Icons.history_rounded, "History"),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Top indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isSelected ? 14 : 0,
            decoration: BoxDecoration(
              color: accentCyan,
              borderRadius: BorderRadius.circular(2),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: accentCyan.withOpacity(0.6),
                  blurRadius: 8,
                ),
              ]
                  : [],
            ),
          ),

          const SizedBox(height: 6),

          // 🔹 Icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? accentCyan.withOpacity(0.15)
                  : Colors.transparent,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected ? accentCyan : Colors.white70,
            ),
          ),

          const SizedBox(height: 4),

          // 🔹 Text
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}