import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class WritingChallengesScreen extends StatefulWidget {
  const WritingChallengesScreen({super.key});

  @override
  State<WritingChallengesScreen> createState() => _WritingChallengesScreenState();
}

class _WritingChallengesScreenState extends State<WritingChallengesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> challenges = [
    {
      'title': 'قِصَّةٌ فِي عَالَمٍ سِحْرِيٍّ',
      'description': 'اكْتُبْ قِصَّةً تَدُورُ فِي عَالَمٍ خَيَالِيٍّ مَليءٍ بِالسِّحْرِ وَالْمَخْلُوقَاتِ الْأُسْطُورِيَّةِ.',
      'icon': Icons.star,
      'tooltip': 'أَبْدِعْ فِي عَالَمٍ مِنَ الْخَيَالِ الْمَحْضِ',
      'progress': 0.4,
    },
    {
      'title': 'حِكَايَةُ بَطَلٍ خَيَالِيٍّ',
      'description': 'أَبْدِعْ حِكَايَةً عَنْ بَطَلٍ يُوَاجِهُ تَحَدِّيَاتٍ فَوْقَ الْعَادَةِ فِي رِحْلَةٍ مُثِيرَةٍ.',
      'icon': Icons.create,
      'tooltip': 'اسْرُدْ مَغَامَرَةً لِبَطَلٍ لَا يُنْسَى',
      'progress': 0.7,
    },
    {
      'title': 'لُغْزٌ فِي مَكْتَبَةٍ قَدِيمَةٍ',
      'description': 'اسْرُدْ قِصَّةً تَدُورُ حَوْلَ لُغْزٍ مَخْفِيٍّ فِي مَكْتَبَةٍ تَعُجُّ بِالْكُتُبِ السِّحْرِيَّةِ.',
      'icon': Icons.book,
      'tooltip': 'اكْتَشِفْ أَسْرَارَ الْكُتُبِ الْقَدِيمَةِ',
      'progress': 0.2,
    },
    {
      'title': 'رِحْلَةٌ عَبْرَ الزَّمَانِ',
      'description': 'اكْتُبْ قِصَّةً عَنْ شَخْصِيَّةٍ تَسَافِرُ عَبْرَ الزَّمَانِ لِكَشْفِ سِرٍّ قَدِيمٍ.',
      'icon': Icons.hourglass_empty,
      'tooltip': 'انْطَلِقْ فِي مَغَامَرَةٍ عَبْرَ الْعُصُورِ',
      'progress': 0.0,
    },
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
                'تَحَدِّيَاتُ الْكِتَابَةِ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
                semanticsLabel: 'تَحَدِّيَاتُ الْكِتَابَةِ',
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.amber[200]),
            onPressed: () {
              HapticFeedback.selectionClick();
              showSearch(
                context: context,
                delegate: ChallengeSearchDelegate(challenges),
              );
            },
            tooltip: 'بَحْثٌ عَنْ تَحَدِّيَاتٍ',
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
            AnimatedPositioned(
              duration: const Duration(seconds: 6),
              top: 150,
              right: 30,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber[200]!.withOpacity(0.3),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ZoomIn(
                      child: Text(
                        'أَشْعِلْ خَيَالَكَ مَعَ تَحَدِّيَاتِ رَاوٍ',
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          fontSize: 18,
                          color: Colors.amber[200],
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.enable('ccmp')],
                        ),
                        textDirection: TextDirection.rtl,
                        semanticsLabel: 'أَشْعِلْ خَيَالَكَ مَعَ تَحَدِّيَاتِ رَاوٍ',
                      ),
                    ),
                  ),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: challenges.length,
                        itemBuilder: (context, index) {
                          final challenge = challenges[index];
                          final iconData = challenge['icon'] as IconData?;
                          return ZoomIn(
                            delay: Duration(milliseconds: 100 * index),
                            child: _buildChallengeCard(
                              context,
                              challenge['title']!,
                              challenge['description']!,
                              challenge['tooltip']!,
                              iconData ?? Icons.book,
                              challenge['progress']!,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(
      BuildContext context,
      String title,
      String description,
      String tooltip,
      IconData icon,
      double progress,
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
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => ChallengeDetailScreen(
                    title: title,
                    description: description,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..scale(_isTapped ? 0.95 : 1.0),
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
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
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blueGrey[800]!, Colors.amber[100]!.withOpacity(0.2)],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()..scale(_isTapped ? 1.1 : 1.0),
                                  padding: const EdgeInsets.all(12),
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
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.tajawal().fontFamily,
                                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontFeatures: const [FontFeature.enable('ccmp')],
                                    ),
                                    semanticsLabel: title,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                fontSize: 14,
                                color: Colors.blueGrey[100],
                                height: 1.5,
                                fontFeatures: const [FontFeature.enable('ccmp')],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.blueGrey[700],
                              color: Colors.amber[200],
                              minHeight: 4,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Pulse(
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.amber[200]!.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.amber[200]!.withOpacity(0.3),
                          highlightColor: Colors.amber[200]!.withOpacity(0.1),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ChallengeDetailScreen(
                                  title: title,
                                  description: description,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
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

class ChallengeDetailScreen extends StatelessWidget {
  final String title;
  final String description;

  const ChallengeDetailScreen({super.key, required this.title, required this.description});

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
        title: Text(
          title,
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFeatures: const [FontFeature.enable('ccmp')],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[900]!, Colors.blue[200]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZoomIn(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    fontSize: 16,
                    color: Colors.blueGrey[100],
                    height: 1.5,
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'اكْتُبْ قِصَّتَكَ هُنَا...',
                    hintStyle: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      color: Colors.blueGrey[300],
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey[800]!.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.white,
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تَمَّ حِفْظُ قِصَّتِكَ!',
                            style: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.white,
                              fontFeatures: const [FontFeature.enable('ccmp')],
                            ),
                          ),
                          backgroundColor: Colors.blueGrey[900],
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200],
                      foregroundColor: Colors.blueGrey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'حِفْظُ الْقِصَّةِ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.enable('ccmp')],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChallengeSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> challenges;

  ChallengeSearchDelegate(this.challenges);

  @override
  String get searchFieldLabel => 'ابْحَثْ عَنْ تَحَدٍّ...';

  @override
  TextStyle get searchFieldStyle => TextStyle(
    fontFamily: GoogleFonts.tajawal().fontFamily,
    fontFamilyFallback: const ['Noto Naskh Arabic'],
    color: Colors.blueGrey[100],
    fontFeatures: const [FontFeature.enable('ccmp')],
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = challenges
        .where((challenge) => challenge['title'].toString().contains(query) || challenge['description'].toString().contains(query))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[900]!, Colors.blue[200]!],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final challenge = results[index];
          return ZoomIn(
            child: ListTile(
              title: Text(
                challenge['title'],
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 18,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
              ),
              subtitle: Text(
                challenge['description'],
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 14,
                  color: Colors.blueGrey[100],
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Icon(challenge['icon'], color: Colors.amber[200]),
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => ChallengeDetailScreen(
                      title: challenge['title'],
                      description: challenge['description'],
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = challenges
        .where((challenge) => challenge['title'].toString().contains(query) || challenge['description'].toString().contains(query))
        .toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[900]!, Colors.blue[200]!],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final challenge = suggestions[index];
          return ZoomIn(
            child: ListTile(
              title: Text(
                challenge['title'],
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 18,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
              ),
              subtitle: Text(
                challenge['description'],
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 14,
                  color: Colors.blueGrey[100],
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Icon(challenge['icon'], color: Colors.amber[200]),
              onTap: () {
                query = challenge['title'];
                showResults(context);
              },
            ),
          );
        },
      ),
    );
  }
}