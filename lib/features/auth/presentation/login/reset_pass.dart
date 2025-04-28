import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/presentation/login/login.dart';
import 'dart:ui';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Placeholder for API call
      // await http.post(
      //   Uri.parse('https://api.x.ai/auth/reset-password/confirm'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'password': _passwordController.text,
      //   }),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تَمَّ تَغْيِيرُ كَلِمَةِ الْمُرُورِ بِنَجَاحٍ!',
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          child: Text(
            'تَغْيِيرُ كَلِمَةِ الْمُرُورِ',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.amber[200],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInUp(
                      child: Text(
                        'أَدْخِلْ كَلِمَةَ مُرُورٍ جَدِيدَةً',
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          color: Colors.amber[200],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'قُمْ بِتَعْيِينِ كَلِمَةِ مُرُورٍ قَوِيَّةٍ!',
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          color: Colors.blueGrey[100],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'كَلِمَةُ الْمُرُورِ الْجَدِيدَةِ',
                          labelStyle: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.blueGrey[300],
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.amber[200]),
                          filled: true,
                          fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.amber[200]!),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.amber[200],
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرَّجَاءُ إِدْخَالُ كَلِمَةِ الْمُرُورِ الْجَدِيدَةِ';
                          }
                          if (value.length < 8) {
                            return 'كَلِمَةُ الْمُرُورِ يَجِبُ أَنْ تَحْتَوِي عَلَى 8 أَحْرُفٍ عَلَى الْأَقَلِّ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'تَأْكِيدُ كَلِمَةِ الْمُرُورِ الْجَدِيدَةِ',
                          labelStyle: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.blueGrey[300],
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.amber[200]),
                          filled: true,
                          fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.amber[200]!),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرَّجَاءُ إِدْخَالُ تَأْكِيدِ كَلِمَةِ الْمُرُورِ';
                          }
                          if (value != _passwordController.text) {
                            return 'كَلِمَةُ الْمُرُورِ غَيْرُ مُتَطَابِقَةٍ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElasticIn(
                      child: ElevatedButton(
                        onPressed: _resetPassword,
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
                          'تَأْكِيدُ التَّغْيِيرِ',
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
        ),
      ),
    );
  }
}