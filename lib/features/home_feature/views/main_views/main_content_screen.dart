import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/home_feature/views/features/challenge_screen.dart';
import 'package:graduation/features/home_feature/views/features/community_screen.dart';
import 'package:graduation/features/home_feature/views/features/continue_story_screen.dart';
import 'package:graduation/features/home_feature/views/features/create_store_screen.dart';
import 'package:graduation/features/home_feature/views/features/savedstory_screen.dart';
import 'package:graduation/features/home_feature/views/features/suggested_stories.dart';

class MainContentScreen extends StatefulWidget {
  MainContentScreen({super.key});

  @override
  _MainContentScreenState createState() => _MainContentScreenState();
}

class _MainContentScreenState extends State<MainContentScreen> {
  final List<IconData> icons = [
    Icons.create,
    Icons.play_circle,
    Icons.book,
    Icons.star,
    Icons.lightbulb,
    Icons.group,
  ];

  final List<String> titles = [
    'إِنشَاءُ قِصَّةٍ جَدِيدَةٍ',
    'اسْتِكْمَالُ قِصَّةٍ',
    'الْقِصَصُ الْمَحْفُوظَةُ',
    'الْقِصَصُ الْمُقْتَرَحَةُ',
    'تَحَدِّيَاتُ الْكِتَابَةِ',
    'مُجْتَمَعُ الْقِصَصِ التَّنَافُسِيِّ',
  ];

  final List<String> tooltips = [
    'اكْتُبْ قِصَّةً جَدِيدَةً بِإِلْهَامِ الذَّكَاءِ الاصْطِنَاعِيِّ',
    'أَكْمِلْ قِصَصَكَ بِأَفْكَارٍ مُبْتَكَرَةٍ',
    'حَافِظْ عَلَى قِصَصِكَ فِي مَكَانٍ آمِنٍ',
    'اسْتَكْشِفْ قِصَصًا مُقْتَرَحَةً لِلْإِلْهَامِ',
    'تَحَدَّ خَيَالَكَ بِتَحَدِّيَاتٍ كِتَابِيَّةٍ',
    'تَعَاوَنْ مَعَ مُجْتَمَعِ الْقُصَّاصِينَ',
  ];

  final List<Function(BuildContext)> onTapActions = [
        (BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CreateStoryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
        (BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ContinueStoryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
        (BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SavedStoriesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
        (BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SuggestedStoriesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
        (BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const WritingChallengesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
        (BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const StoryCommunityScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900]!.withOpacity(0.5),
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blueGrey[200]!.withOpacity(0.3), width: 1),
                ),
              ),
            ),
          ),
        ),
        title: FadeIn(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.book, color: Colors.amber[200], size: 28),
              const SizedBox(width: 8),
              Text(
                'رَاوٍ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
                textDirection: TextDirection.rtl,
                semanticsLabel: 'رَاوٍ',
              ),
            ],
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.amber[200]),
            onPressed: () {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'الإِشْعَارَاتُ قَادِمَةٌ قَرِيبًا!',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      color: Colors.white,
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: Colors.blueGrey[900],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'إِشْعَارَاتٌ',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[900]!, Colors.blue[200]!],
          ),
        ),
        child: Stack(
          children: [
            // Sparkle Effect
            AnimatedPositioned(
              duration: const Duration(seconds: 5),
              top: 50,
              left: 50,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber[200]!.withOpacity(0.5),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 7),
              bottom: 100,
              right: 80,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber[200]!.withOpacity(0.4),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ZoomIn(
                        child: Text(
                          'أَطْلِقْ خَيَالَكَ مَعَ رَاوٍ',
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            fontSize: 18,
                            color: Colors.amber[200],
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [FontFeature.enable('ccmp')],
                          ),
                          textDirection: TextDirection.rtl,
                          semanticsLabel: 'أَطْلِقْ خَيَالَكَ مَعَ رَاوٍ',
                        ),
                      ),
                    ),

                    Expanded(
                      child: GridView.builder(
                        itemCount: titles.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          return ZoomIn(
                            delay: Duration(milliseconds: 100 * index),
                            child: _buildCategoryCard(
                              context,
                              icons[index],
                              titles[index],
                              tooltips[index],
                              onTapActions[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context,
      IconData icon,
      String title,
      String tooltip,
      Function(BuildContext) onTap,
      ) {
    bool _isTapped = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Tooltip(
          message: tooltip,
          textStyle: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.white,
            fontFeatures: const [FontFeature.enable('ccmp')],
          ),
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isTapped = true),
            onTapUp: (_) => setState(() => _isTapped = false),
            onTapCancel: () => setState(() => _isTapped = false),
            onTap: () {
              HapticFeedback.lightImpact();
              onTap(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..scale(_isTapped ? 0.95 : 1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[800]!.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                  BoxShadow(
                    color: Colors.blueGrey[900]!.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(-5, -5),
                  ),
                ],
                border: Border.all(
                  color: Colors.blueGrey[200]!.withOpacity(_isTapped ? 0.7 : 0.3),
                  width: _isTapped ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Stack(
                    children: [
                      // Book Page Background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blueGrey[800]!, Colors.amber[100]!.withOpacity(0.2)],
                          ),
                        ),
                      ),
                      // Icon
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.identity()..scale(_isTapped ? 1.1 : 1.0),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.amber[200]!, Colors.white],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber[200]!.withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: Colors.blueGrey[900],
                            size: 60,
                            semanticLabel: title,
                          ),
                        ),
                      ),
                      // AI Indicator
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.amber[200]!.withOpacity(0.7),
                          size: 20,
                        ),
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      // Title
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [FontFeature.enable('ccmp')],
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            semanticsLabel: title,
                          ),
                        ),
                      ),
                      // Hover Effect
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onTap(context);
                          },
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.amber[200]!.withOpacity(0.3),
                          highlightColor: Colors.amber[200]!.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}