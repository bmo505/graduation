import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/features/auth/presentation/register/register.dart';
import 'package:graduation/features/home_feature/views/features/chat_view.dart';
import 'package:animate_do/animate_do.dart';

class CreateStoryScreen extends StatefulWidget {
  final bool isGuest;
  const CreateStoryScreen({super.key, this.isGuest = false});

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  String selectedWritingStyle = '';
  final TextEditingController _promptController = TextEditingController();

  final List<Map<String, dynamic>> writingStyles = [
    {'name': 'الدِّرَامَا', 'icon': Icons.theater_comedy, 'description': 'قِصَصٌ مُؤْثِّرَةٌ تَغُوصُ فِي أَعْمَاقِ الْمَشَاعِرِ.'},
    {'name': 'الرُّومَانْسِيَّةُ', 'icon': Icons.favorite, 'description': 'حِكَايَاتُ الْحُبِّ الْمُثِيرَةِ لِلْعَوَاطِفِ.'},
    {'name': 'الْفَانْتَازْيَا', 'icon': Icons.auto_awesome, 'description': 'عَوَالِمُ سِحْرِيَّةٌ مَعَ مَخْلُوقَاتٍ أُسْطُورِيَّةٍ.'},
    {'name': 'الْخَيَالُ الْعِلْمِيُّ', 'icon': Icons.rocket_launch, 'description': 'مُغَامَرَاتٌ فِي الْمُسْتَقْبَلِ وَالْفَضَاءِ.'},
    {'name': 'الْمُغَامَرَاتُ', 'icon': Icons.explore, 'description': 'رِحْلَاتٌ مُثِيرَةٌ مَلِيئَةٌ بِالتَّحَدِّيَاتِ.'},
    {'name': 'الْكُومِيدْيَا', 'icon': Icons.emoji_emotions, 'description': 'قِصَصٌ خَفِيفَةٌ تُثِيرُ الضَّحِكَ.'},
    {'name': 'التَّارِيخِيَّةُ', 'icon': Icons.history, 'description': 'حِكَايَاتٌ مِنْ عُصُورٍ مَاضِيَةٍ.'},
    {'name': 'الرُّعْبُ', 'icon': Icons.nights_stay, 'description': 'قِصَصٌ مُرْعِبَةٌ تَجْمَعُ الْجُرْأَةَ.'},
    {'name': 'الْحَرَكَةُ', 'icon': Icons.directions_run, 'description': 'مَشَاهِدُ مُثِيرَةٌ مَعَ إِثَارَةٍ دَائِمَةٍ.'},
    {'name': 'الدِّرَامَا الْإِجْتِمَاعِيَّةُ', 'icon': Icons.group, 'description': 'قِصَصٌ تَتَنَاوَلُ قَضَايَا الْمُجْتَمَعِ.'},
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _startStoryCreation() {
    if (widget.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'سَجِّلْ لِحِفْظِ قِصَّتِكَ وَمُشَارَكَتِهَا!',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'انْضَمَّ الآنَ',
            textColor: Colors.amber[200],
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
          ),
        ),
      );
      return;
    }
    if (selectedWritingStyle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'اخْتَرْ نَمَطَ الْكِتَابَةِ أَوَّلًا!',
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
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
          initialMessage: 'أَنشِئْ قِصَّةً بِأُسْلُوبِ $selectedWritingStyle: ${_promptController.text.isNotEmpty ? _promptController.text : 'ابدأ قصة جديدة'}',
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
  }

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
        title: ZoomIn(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.create, color: Colors.amber[200], size: 24),
              const SizedBox(width: 8),
              Text(
                'إِنْشَاءُ قِصَّةٍ جَدِيدَةٍ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[200],
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
              ),
            ],
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ZoomIn(
                  child: Text(
                    'أَشْعِلْ خَيَالَكَ مَعَ قِصَّةٍ جَدِيدَةٍ',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[200],
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  child: Text(
                    'اخْتَرْ نَمَطَ الْكِتَابَةِ وَأَضِفْ فِكْرَتَكَ لِنَبْدَأَ!',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 16,
                      color: Colors.blueGrey[100],
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _promptController,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.white,
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                  decoration: InputDecoration(
                    hintText: 'أَدْخِلْ فِكْرَةَ الْقِصَّةِ أَوْ اترُكْهَا لِرَاوٍ...',
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
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  child: Text(
                    'اخْتَرْ نَمَطَ الْكِتَابَةِ:',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[200],
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: writingStyles.length,
                  itemBuilder: (context, index) {
                    final style = writingStyles[index];
                    return ZoomIn(
                      delay: Duration(milliseconds: 100 * index),
                      child: _buildWritingStyleCard(style['name'], style['icon'], style['description']),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElasticIn(
                    child: ElevatedButton(
                      onPressed: _startStoryCreation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[200],
                        foregroundColor: Colors.blueGrey[900],
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'ابْدَأْ الْقِصَّةَ',
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.enable('ccmp')],
                        ),
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

  Widget _buildWritingStyleCard(String name, IconData icon, String description) {
    bool isSelected = selectedWritingStyle == name;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          selectedWritingStyle = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey[700]!.withOpacity(0.8) : Colors.blueGrey[800]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber[200]!.withOpacity(0.7) : Colors.blueGrey[200]!.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.amber[200] : Colors.blueGrey[200],
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.amber[200] : Colors.white,
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 12,
                      color: Colors.blueGrey[100],
                      fontFeatures: const [FontFeature.enable('ccmp')],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}