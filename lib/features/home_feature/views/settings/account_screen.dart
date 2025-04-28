import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../auth/manager/user.dart';

// Simulated User model (same as in RegisterScreen)


class MyAccountScreen extends StatefulWidget {
  final User user; // Pass user data from RegisterScreen or HomeScreen
  const MyAccountScreen({super.key, required this.user});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // Placeholder for uploading image to server
      // await http.post(
      //   Uri.parse('https://api.x.ai/user/profile/image'),
      //   body: {'image': _profileImage},
      // );
    }
  }

  void _showUpdateProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'تَحْدِيثُ الْبَيَانَاتِ الشَّخْصِيَّةِ',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.amber[200],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'الإِسْمُ',
                  hintStyle: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.blueGrey[300],
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'الْبَرِيدُ الإِلِكْتُرُونِيُّ',
                  hintStyle: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.blueGrey[300],
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
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
          TextButton(
            onPressed: () {
              // Placeholder for updating profile API call
              // await http.post(
              //   Uri.parse('https://api.x.ai/user/profile'),
              //   headers: {'Content-Type': 'application/json'},
              //   body: jsonEncode({
              //     'name': _nameController.text,
              //     'email': _emailController.text,
              //   }),
              // );
              setState(() {
                widget.user.name = _nameController.text;
                widget.user.email = _emailController.text;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تَمَّ تَحْدِيثُ الْبَيَانَاتِ بِنَجَاحٍ',
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
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'تَغْيِيرُ كَلِمَةِ الْمُرُورِ',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.amber[200],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'كَلِمَةُ الْمُرُورِ الْجَدِيدَةِ',
                  hintStyle: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.blueGrey[300],
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'تَأْكِيدُ كَلِمَةِ الْمُرُورِ',
                  hintStyle: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.blueGrey[300],
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
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
          TextButton(
            onPressed: () {
              if (_passwordController.text != _confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'كَلِمَةُ الْمُرُورِ غَيْرُ مُتَطَابِقَةٍ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red[800],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              // Placeholder for password change API call
              // await http.post(
              //   Uri.parse('https://api.x.ai/user/password'),
              //   headers: {'Content-Type': 'application/json'},
              //   body: jsonEncode({
              //     'password': _passwordController.text,
              //   }),
              // );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تَمَّ تَغْيِيرُ كَلِمَةِ الْمُرُورِ بِنَجَاحٍ',
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
              _passwordController.clear();
              _confirmPasswordController.clear();
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
        ],
      ),
    );
  }

  void _showUpdateUserTypeDialog() {
    String? selectedUserType = widget.user.userType;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'تَغْيِيرُ نَوْعِ الْمُسْتَخْدِمِ',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.amber[200],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: DropdownButtonFormField<String>(
          value: selectedUserType,
          decoration: InputDecoration(
            labelText: 'نَوْعُ الْمُسْتَخْدِمِ',
            labelStyle: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.blueGrey[300],
            ),
            filled: true,
            fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
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
            selectedUserType = value;
          },
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
          TextButton(
            onPressed: () {
              if (selectedUserType != null) {
                setState(() {
                  widget.user.userType = selectedUserType!;
                });
                // Placeholder for updating user type API call
                // await http.post(
                //   Uri.parse('https://api.x.ai/user/type'),
                //   headers: {'Content-Type': 'application/json'},
                //   body: jsonEncode({'userType': selectedUserType}),
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تَمَّ تَحْدِيثُ نَوْعِ الْمُسْتَخْدِمِ بِنَجَاحٍ',
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
              }
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
        ],
      ),
    );
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, color: Colors.amber[200], size: 24),
              const SizedBox(width: 8),
              Text(
                'حِسَابِي',
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
                Center(
                  child: Stack(
                    children: [
                      ZoomIn(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blueGrey[700],
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const NetworkImage('https://depor.com/resizer/IiXSXqI-lnp_jygMWeflmEuw5xo=/1200x1200/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/YWMMTCHGQJDB7DY33AS4NT6KEY.jpg') as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ElasticIn(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber[200],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blueGrey[900],
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      FadeInUp(
                        child: Text(
                          _nameController.text,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[200],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          _emailController.text,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[100],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          'نَوْعُ الْمُسْتَخْدِمِ: ${widget.user.userType}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[100],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildAccountOption(
                  context,
                  'تَغْيِيرُ كَلِمَةِ الْمُرُورِ',
                  Icons.lock,
                  _showChangePasswordDialog,
                ),
                _buildAccountOption(
                  context,
                  'تَحْدِيثُ الْبَيَانَاتِ الشَّخْصِيَّةِ',
                  Icons.edit,
                  _showUpdateProfileDialog,
                ),
                _buildAccountOption(
                  context,
                  'تَغْيِيرُ نَوْعِ الْمُسْتَخْدِمِ',
                  Icons.person_pin,
                  _showUpdateUserTypeDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption(
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