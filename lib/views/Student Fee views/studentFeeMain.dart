import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/views/Student%20Fee%20views/studentFeeDonationScreen.dart';
import 'package:reserve/views/Student%20Fee%20views/studentHelpScreen.dart';

class StudentFeeMain extends StatefulWidget {
  const StudentFeeMain({super.key});

  @override
  State<StudentFeeMain> createState() => _StudentFeeMainState();
}

class _StudentFeeMainState extends State<StudentFeeMain> {
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ScreenTopContainer(
                  image: const AssetImage('assets/images/kidEducation.png'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Center(
                child: Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Empower a Future with Education'
                      : 'تعلیم کے ذریعے مستقبل کو بااختیار بنائیں',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'semi-bold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                localizationProvider.locale.languageCode == 'en'
                    ? 'Why We Do This?'
                    : 'ہم یہ کیوں کرتے ہیں؟',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'semi-bold',
                ),
              ),
              const SizedBox(height: 10),

              Text(
                localizationProvider.locale.languageCode == 'en'
                    ? 'Education is a basic right, yet many students struggle due to financial limitations. '
                        'We are committed to bridging this gap by offering support to those in need. '
                        'Be a hero in someone life today — your help can change their tomorrow.'
                    : 'تعلیم ایک بنیادی حق ہے، لیکن مالی مشکلات کی وجہ سے بہت سے طلباء کو جدوجہد کرنی پڑتی ہے۔ '
                        'ہم اس خلا کو پُر کرنے کے لیے پرعزم ہیں اور ضرورت مندوں کی مدد کرتے ہیں۔ '
                        'آج کسی کی زندگی کے ہیرو بنیں — آپ کی مدد ان کا کل بدل سکتی ہے۔',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'regular',
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),

              // Donate Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StudentFeeDonationScreen()),
                  );
                },
                icon: const Icon(Icons.volunteer_activism, color: Colors.white),
                label: Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Donate Now'
                      : 'ابھی عطیہ کریں',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'semi-bold',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5DCE35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(screenWidth, 55),
                  elevation: 3,
                ),
              ),
              const SizedBox(height: 20),

              // Ask for Help Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StudentHelpScreen()),
                  );
                },
                icon: const Icon(Icons.help_outline, color: Color(0xFF5DCE35)),
                label: Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Request Help'
                      : 'مدد کی درخواست کریں',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'semi-bold',
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5DCE35), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(screenWidth, 55),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
