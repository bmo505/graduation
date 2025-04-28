import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/features/auth/presentation/register/register.dart';
import 'package:graduation/features/home_feature/views/features/challenge_screen.dart';
import 'package:graduation/features/home_feature/views/main_views/main_content_screen.dart';
import 'package:graduation/features/home_feature/views/features/create_store_screen.dart';
import 'package:graduation/features/home_feature/views/features/savedstory_screen.dart';
import 'package:graduation/features/home_feature/views/settings/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:animate_do/animate_do.dart';

import '../../../auth/manager/user.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  late List<Widget> _screens;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_outlined, 'title': 'الرَّئِيسِيَّةُ'},
    {'icon': Icons.create, 'title': 'إِنشَاءُ قِصَّةٍ'},
    {'icon': Icons.book, 'title': 'الْقِصَصُ الْمَحْفُوظَةُ'},
    {'icon': Icons.lightbulb, 'title': 'تَحَدِّيَاتُ الْكِتَابَةِ'},
    {'icon': Icons.settings_outlined, 'title': 'الْإِعْدَادَاتُ'},
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      MainContentScreen(),
      const CreateStoryScreen(),
      const SavedStoriesScreen(),
      const WritingChallengesScreen(),
      SettingsScreen(user: widget.user), // استخدام widget.user للوصول للمستخدم
    ];

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blueGrey[900]!,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 65,
          items: _navItems
              .asMap()
              .entries
              .map((entry) => ZoomIn(
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  entry.value['icon'],
                  size: 28,
                  color: _selectedIndex == entry.key
                      ? Colors.amber[200]
                      : Colors.blueGrey[200],
                ),
                if (_selectedIndex == entry.key)
                  ElasticIn(
                    child: Text(
                      entry.value['title'],
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        fontSize: 12,
                        color: Colors.amber[200],
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.enable('ccmp')],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
              ],
            ),
          ))
              .toList(),
          color: Colors.blueGrey[900]!.withOpacity(0.9),
          buttonBackgroundColor: Colors.amber[200]!.withOpacity(0.3),
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: _onItemTapped,
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
