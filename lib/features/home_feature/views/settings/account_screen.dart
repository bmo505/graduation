import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text(
          'حسابي',
          style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1E6D2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://depor.com/resizer/IiXSXqI-lnp_jygMWeflmEuw5xo=/1200x1200/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/YWMMTCHGQJDB7DY33AS4NT6KEY.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    'أحمد محمد',
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ahmed@example.com',
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // خيارات الحساب
            _buildAccountOption(
              context,
              'تغيير كلمة المرور',
              Icons.lock,
                  () {
                // تنفيذ دالة تغيير كلمة المرور
              },
            ),
            _buildAccountOption(
              context,
              'تحديث البيانات الشخصية',
              Icons.edit,
                  () {
                // تنفيذ دالة تحديث البيانات
              },
            ),
          ],
        ),
      ),
    );
  }

  // بناء عنصر قائمة الخيارات
  Widget _buildAccountOption(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown[800], size: 28),
        title: Text(
          title,
          style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.brown[800], size: 20),
        onTap: onTap,
      ),
    );
  }
}
