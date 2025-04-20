import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedStoriesScreen extends StatelessWidget {
  const SavedStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text(
          'القصص المحفوظة',
          style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF1E6D2),
      body: Center(
        child: Text(
          'يمكنك هنا الاطلاع على القصص التي قمت بحفظها.',
          style: GoogleFonts.tajawal(fontSize: 20, color: Colors.brown[800]),
        ),
      ),
    );
  }
}
