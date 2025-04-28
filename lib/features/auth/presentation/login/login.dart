import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/presentation/login/forget_password.dart';
import 'package:graduation/features/auth/presentation/register/register.dart';
import 'package:graduation/features/home_feature/views/main_views/home_view.dart';
import 'dart:ui';

import '../../manager/user.dart';

// Simulated User model (same as in RegisterScreen)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      // Simulate fetching user data after login
      final user = User(
        name: 'اسم المستخدم', // Replace with actual data from backend
        email: _emailController.text,
        birthDate: '01/01/2000', // Replace with actual data
        userType: 'قَارِئٌ', id: '', // Replace with actual data
      );

      // Placeholder for API call
      // final response = await http.post(
      //   Uri.parse('https://api.x.ai/auth/login'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'email': _emailController.text,
      //     'password': _passwordController.text,
      //   }),
      // );
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   user = User(
      //     name: data['name'],
      //     email: data['email'],
      //     birthDate: data['birthDate'],
      //     userType: data['userType'],
      //   );
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تَمَّ تَسْجِيلُ الدُّخُولِ بِنَجَاحٍ!',
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
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            'تَسْجِيلُ دُخُولٍ إِلَى حِكَايَاتُ رَاوٍ',
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
                          'مَرْحَبًا بِكَ مِنْ جَدِيدٍ!',
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.amber[200],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          'سَجِّلْ الدُّخُولَ لِتَسْتَمْتِعَ بِقِصَصِكَ!',
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
                            prefixIcon: Icon(Icons.alternate_email_sharp, color: Colors.amber[200]),
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
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'كَلِمَةُ الْمُرُورِ',
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
                              return 'الرَّجَاءُ إِدْخَالُ كَلِمَةِ الْمُرُورِ';
                            }
                            if (value.length < 8) {
                              return 'كَلِمَةُ الْمُرُورِ يَجِبُ أَنْ تَحْتَوِي عَلَى 8 أَحْرُفٍ عَلَى الْأَقَلِّ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElasticIn(
                        child: ElevatedButton(
                          onPressed: _loginUser,
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
                            'تَسْجِيلُ الدُّخُولِ',
                            style: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 800),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                            );
                          },
                          child: Text(
                            'نَسِيتَ كَلِمَةَ الْمُرُورِ؟',
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
                      FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لَيْسَ لَدَيْكَ حِسَابٌ؟',
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: Colors.blueGrey[100],
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                );
                              },
                              child: Text(
                                'إِنْشَاءُ حِسَابٍ',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                                  color: Colors.amber[200],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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