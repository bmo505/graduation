import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryCommunityScreen extends StatelessWidget {
  const StoryCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text(
          'مجتمع القصص التنافسي',
          style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF1E6D2),
      body: Center(
        child: Text(
          'شارك قصتك في مجتمع الكتابة التنافسي!',
          style: GoogleFonts.tajawal(fontSize: 20, color: Colors.brown[800]),
        ),
      ),
    );
  }
}
