import 'package:flutter/material.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
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
              // Header with Image
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
                  'Empower a Future with Education',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'semi-bold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Description Title
              const Text(
                'Why We Do This?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'semi-bold',
                ),
              ),
              const SizedBox(height: 10),

              // Description
              const Text(
                'Education is a basic right, yet many students struggle due to financial limitations. '
                'We’re committed to bridging this gap by offering support to those in need. '
                'Be a hero in someone’s life today — your help can change their tomorrow.',
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
                label: const Text(
                  'Donate Now',
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
                label: const Text(
                  'Request Help',
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
