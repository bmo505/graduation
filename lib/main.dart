import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/features/home_feature/views/main_views/main_screen.dart';
import 'package:graduation/features/home_feature/views/main_views/splash_screen.dart';
import 'package:graduation/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(const GraduationProject());
}

class GraduationProject extends StatelessWidget {
  const GraduationProject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown[400],
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 24,
          ),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        scaffoldBackgroundColor: Colors.white54,
      ),
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    title: 'راوي',
    home:  AnimatedSplashScreen(
    splash: const SplashImage(),
    nextScreen: const MainScreen(),
    splashTransition: SplashTransition.fadeTransition,
    duration: 3000,
    backgroundColor: Colors.brown,
    ),);
  }
}
