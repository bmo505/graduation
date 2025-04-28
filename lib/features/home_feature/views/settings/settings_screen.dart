import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/home_feature/views/main_views/main_screen.dart';
import 'package:graduation/features/home_feature/views/settings/account_screen.dart';

import '../../../auth/manager/user.dart';

class SettingsScreen extends StatelessWidget {
  final User user;

  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
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
                Icon(Icons.settings, color: Colors.amber[200], size: 24),
                const SizedBox(width: 8),
                Text(
                  'الإِعْدَادَاتُ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[200],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSettingsOption(
                          context,
                          'اللُّغَةُ',
                          Icons.language,
                              () => _showLanguageDialog(context),
                        ),
                        _buildSettingsOption(
                          context,
                          'الإِشْعَارَاتُ',
                          Icons.notifications,
                              () => _showNotificationsDialog(context),
                        ),
                        _buildSettingsOption(
                          context,
                          'تَعْدِيلُ الْمَعْلُومَاتِ الشَّخْصِيَّةِ',
                          Icons.account_circle,
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAccountScreen(user: user),
                              ),
                            );
                          },
                        ),
                        _buildSettingsOption(
                          context,
                          'حَوْلَ التَّطْبِيقِ',
                          Icons.info,
                              () => _showAboutDialog(context),
                        ),
                      ],
                    ),
                  ),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
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

  Widget _buildLogoutButton(BuildContext context) {
    return FadeInUp(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ElevatedButton(
          onPressed: () {
            // Placeholder for logout API call
            // await http.post(
            //   Uri.parse('https://api.x.ai/auth/logout'),
            //   headers: {'Content-Type': 'application/json'},
            // );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تَمَّ تَسْجِيلُ الْخُرُوجِ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.white,
                  ),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red[800],
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            shadowColor: Colors.redAccent.withOpacity(0.4),
          ),
          child: Text(
            'تَسْجِيلُ الْخُرُوجِ',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'اخْتَرْ اللُّغَةَ',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.amber[200],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'العربية',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Placeholder for language change logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تَمَّ تَغْيِيرُ اللُّغَةِ إِلَى الْعَرَبِيَّةِ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blueGrey[900],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'English',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Placeholder for language change logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Language changed to English',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blueGrey[900],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إِلْغَاءٌ',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.red[300],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    bool pushNotifications = true;
    bool emailNotifications = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'إِعْدَادَاتُ الإِشْعَارَاتِ',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.amber[200],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  'إِشْعَارَاتُ التَّطْبِيقِ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.white,
                  ),
                ),
                value: pushNotifications,
                activeColor: Colors.amber[200],
                onChanged: (value) {
                  setState(() {
                    pushNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(
                  'إِشْعَارَاتُ الْبَرِيدِ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.white,
                  ),
                ),
                value: emailNotifications,
                activeColor: Colors.amber[200],
                onChanged: (value) {
                  setState(() {
                    emailNotifications = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Placeholder for saving notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تَمَّ حِفْظُ إِعْدَادَاتِ الإِشْعَارَاتِ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blueGrey[900],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text(
                'حِفْظٌ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.amber[200],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إِلْغَاءٌ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.red[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'حَوْلَ التَّطْبِيقِ',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.amber[200],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'تَطْبِيقُ حِكَايَاتُ رَاوٍ هُوَ مَنَصَّةٌ لِخَلْقِ الْقِصَصِ وَمُشَارَكَتِهَا، مَعَ مُسَاعِدٍ ذَكِيٍّ يُسَاعِدُكَ عَلَى تَطْوِيرِ أَفْكَارِكَ. الإصْدَارُ: 1.0.0',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'مُوَافِقٌ',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.amber[200],
              ),
            ),
          ),
        ],
      ),
    );
  }
}