import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/features/home_feature/views/main_views/main_content_screen.dart';
import 'package:graduation/features/home_feature/views/settings/settings_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    MainContentScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index)
      return; // Avoid unnecessary animation if tapping the same item
    setState(() {
      _selectedIndex = index;
    });

    // Directly change the page without delay
    _pageController.jumpToPage(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.brown[800]!,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent swipe gesture
          children: _screens,
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            SalomonBottomBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 0 ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: const Icon(Icons.home_outlined),
              ),
              title: AnimatedOpacity(
                opacity: _selectedIndex == 0 ? 1.0 : 0.7,
                duration: const Duration(milliseconds: 200),
                child:  Text("الرئيسية",style: GoogleFonts.tajawal(),),
              ),
              selectedColor: Colors.brown[4],
              unselectedColor: Colors.white,
            ),
            SalomonBottomBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 1 ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: const Icon(Icons.settings_outlined),
              ),
              title: AnimatedOpacity(
                opacity: _selectedIndex == 1 ? 1.0 : 0.7,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  "الإعدادات",
                  style: GoogleFonts.tajawal(),
                ),
              ),
              selectedColor: Colors.brown[4],
              unselectedColor: Colors.white,
            ),
          ],
          itemShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          unselectedItemColor: Colors.white70,
          selectedItemColor: Colors.yellow[100],
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          backgroundColor: Colors.brown[800],
        ),
      ),
    );
  }
}
