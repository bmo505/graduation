import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/presentation/login/login.dart';
import 'package:graduation/features/home_feature/views/main_views/home_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../manager/user.dart';

// Simulated User model

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _userType;
  bool _passwordVisible = false;

  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.blueGrey[900],
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.amber[200],
              primary: Colors.blueGrey[900],
            ),
            dialogBackgroundColor: Colors.blueGrey[800],
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      // Simulate saving user data
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        birthDate: _birthDateController.text,
        userType: _userType!, id: '',
      );

      // Placeholder for API call
      // await http.post(
      //   Uri.parse('https://api.x.ai/auth/register'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'name': user.name,
      //     'email': user.email,
      //     'birthDate': user.birthDate,
      //     'userType': user.userType,
      //     'password': _passwordController.text,
      //   }),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تَمَّ إِنْشَاءُ الْحِسَابِ بِنَجَاحٍ!',
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
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user), // Pass user to HomeScreen
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
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
            'أَهْلًا بِكَ فِي حِكَايَاتُ رَاوٍ',
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
                          'إِنْشَاءُ حِسَابٍ جَدِيدٍ',
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
                          'انْضَمَّ لِتَحْفَظَ قِصَصَكَ وَتُشَارِكَهَا!',
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'الإِسْمُ',
                            labelStyle: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.blueGrey[300],
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.amber[200]),
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
                              return 'الرَّجَاءُ إِدْخَالُ اسْمِكَ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
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
                        delay: const Duration(milliseconds: 800),
                        child: TextFormField(
                          controller: _birthDateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                            _BirthDateFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'تَارِيخُ الْمِيلَادِ',
                            labelStyle: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.blueGrey[300],
                            ),
                            prefixIcon: Icon(Icons.calendar_today, color: Colors.amber[200]),
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
                            hintText: '01/01/2000',
                            hintStyle: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.blueGrey[300],
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today, color: Colors.amber[200]),
                              onPressed: () => _selectBirthDate(context),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرَّجَاءُ إِدْخَالُ تَارِيخِ مِيلَادِكَ';
                            }
                            if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                              return 'يَجِبُ أَنْ يَكُونَ التَّارِيخُ بِصِيغَةِ dd/MM/yyyy';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        child: DropdownButtonFormField<String>(
                          value: _userType,
                          decoration: InputDecoration(
                            labelText: 'نَوْعُ الْمُسْتَخْدِمِ',
                            labelStyle: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.blueGrey[300],
                            ),
                            prefixIcon: Icon(Icons.person_pin, color: Colors.amber[200]),
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
                          dropdownColor: Colors.blueGrey[800],
                          items: ['قَارِئٌ', 'كَاتِبٌ'].map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _userType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرَّجَاءُ اخْتِيَارُ نَوْعِ الْمُسْتَخْدِمِ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 1200),
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
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 1400),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'تَأْكِيدُ كَلِمَةِ الْمُرُورِ',
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
                              return 'الرَّجَاءُ تَأْكِيدُ كَلِمَةِ الْمُرُورِ';
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
                          onPressed: _registerUser,
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
                            'إِنْشَاءُ حِسَابٍ',
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
                        delay: const Duration(milliseconds: 1600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'إِذَا كَانَ لَدَيْكَ حِسَابٌ بِالْفِعْلِ؟',
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
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              },
                              child: Text(
                                'قُمْ بِتَسْجِيلِ الدُّخُولِ',
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

class _BirthDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newText.length > 2 && newText.length <= 4) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    } else if (newText.length > 4) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2, 4)}/${newText.substring(4)}';
    }
    return newText.length <= 10
        ? TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    )
        : oldValue;
  }
}