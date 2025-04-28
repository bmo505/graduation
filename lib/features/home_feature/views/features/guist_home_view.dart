import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/presentation/register/register.dart';
import 'package:graduation/features/home_feature/views/features/create_store_screen.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

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
              Icon(Icons.explore, color: Colors.amber[200], size: 24),
              const SizedBox(width: 8),
              Text(
                'وُضْعُ الضَّيْفِ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[200],
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  child: Text(
                    'جَرِّبْ رَاوِي كَضَيْفٍ!',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[200],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'اكْتَشِفْ عَالَمَ الْقِصَصِ، لَكِنْ سَجِّلْ لِلْحِفْظِ وَالْمُشَارَكَةِ!',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      fontSize: 16,
                      color: Colors.blueGrey[100],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _buildGuestOption(
                        context,
                        'جَرِّبْ إِنْشَاءَ قِصَّةٍ',
                        Icons.create,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateStoryScreen(isGuest: true),
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                ),
                FadeInUp(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200],
                      foregroundColor: Colors.blueGrey[900],
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'انْضَمَّ الآنَ!',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

  Widget _buildGuestOption(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return ZoomIn(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[800]!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ListTile(
              leading: Icon(icon, color: Colors.amber[200], size: 28),
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.amber[200],
                size: 20,
              ),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}