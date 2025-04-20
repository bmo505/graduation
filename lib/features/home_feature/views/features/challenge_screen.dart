import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WritingChallengesScreen extends StatelessWidget {
  const WritingChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text(
          'تحديات الكتابة',
          style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF1E6D2),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(
                'تحدي الكتابة رقم ${index + 1}',
                style: GoogleFonts.tajawal(fontSize: 20, color: Colors.brown[800]),
              ),
              subtitle: Text(
                'شارك في هذا التحدي لتطوير مهاراتك...',
                style: GoogleFonts.tajawal(color: Colors.brown[600]),
              ),
            ),
          );
        },
      ),
    );
  }
}
