// screens/student_fee_donation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
import 'package:reserve/StateManagment/localization.dart';

class StudentFeeDonationScreen extends StatefulWidget {
  const StudentFeeDonationScreen({super.key});

  @override
  State<StudentFeeDonationScreen> createState() =>
      _StudentFeeDonationScreenState();
}

class _StudentFeeDonationScreenState extends State<StudentFeeDonationScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitDonation() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        throw Exception('Please enter a valid amount');
      }

      // Here you would typically:
      // 1. Process payment (using a payment gateway)
      // 2. Record the donation in your database
      // 3. Show success message

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation submitted successfully!')),
      );

      // Clear form
      _nameController.clear();
      _amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting donation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ScreenTopContainer(
                  onTap: () => Navigator.pop(context),
                  image: const AssetImage('assets/images/kidEducation.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Help Students to get better education'
                      : 'طالب علموں کو بہتر تعلیم حاصل کرنے میں مدد کریں',
                  style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
                ),
                const SizedBox(height: 20),
                MyTextFeild(
                  controller: _nameController,
                  prefixIcon: Icons.person,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Enter Your Name'
                      : 'اپنا نام درج کریں',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextFeild(
                  controller: _amountController,
                  prefixIcon: Icons.money,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Enter amount'
                      : 'رقم درج کریں',
                  obscureText: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: ElevatedButton(
                    onPressed: _submitDonation,
                    child: Text(
                      localizationProvider.locale.languageCode == 'en'
                          ? 'Donate'
                          : 'عطیہ کریں',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'semi-bold',
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5DCE35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
