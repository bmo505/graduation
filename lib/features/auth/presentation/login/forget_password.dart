import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/presentation/login/login.dart';
import 'package:graduation/features/auth/presentation/login/otp.dart';
import 'dart:ui';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 120;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatTime() {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      // Placeholder for API call
      // await http.post(
      //   Uri.parse('https://api.x.ai/auth/reset-password'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'email': _emailController.text}),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تَمَّ إِرْسَالُ رَابِطِ اسْتِعَادَةِ كَلِمَةِ الْمُرُورِ!',
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

      _startTimer();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerificationCodeScreen()),
      );
    }
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
            'إِسْتِعَادَةُ كَلِمَةِ الْمُرُورِ',
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeInUp(
                        child: Text(
                          'أَدْخِلْ بَرِيدَكَ الإِلِكْتُرُونِيَّ لِإِسْتِعَادَةِ كَلِمَةِ الْمُرُورِ',
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
                          'اسْتَعِدْ حِسَابَكَ لِتَحْفَظَ قِصَصَكَ!',
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'الْبَرِيدُ الإِلِكْتُرُونِيُّ',
                            labelStyle: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.blueGrey[300],
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.amber[200]),
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
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرَّجَاءُ إِدْخَالُ بَرِيدِكَ الإِلِكْتُرُونِيِّ';
                            }
                            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                              return 'الرَّجَاءُ إِدْخَالُ بَرِيدٍ إِلِكْتُرُونِيٍّ صَحِيحٍ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElasticIn(
                        child: ElevatedButton(
                          onPressed: _secondsRemaining == 0 ? _sendResetLink : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[200],
                            foregroundColor: Colors.blueGrey[900],
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _secondsRemaining == 0
                                    ? 'إِرْسَالُ الرَّابِطِ'
                                    : 'إِعَادَةُ الْمُحَاوَلَةِ بَعْدَ ${_formatTime()}',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_secondsRemaining > 0) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.timer, color: Colors.blueGrey[900], size: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'الْعَوْدَةُ لِتَسْجِيلِ الدُّخُولِ',
                            style: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.amber[200],
                              fontSize: 16,
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
      ),
    );
  }
}