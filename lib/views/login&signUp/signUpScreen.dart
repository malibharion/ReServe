import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reserve/CustomsWidgets/textfeild.dart';

import 'package:reserve/Database/authentication.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/views/homeScreen.dart';
import 'package:reserve/views/login&signUp/userLoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _cinicController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF9FDFA),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/reserveLogo.png')),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Sign Up'
                      : 'سائن اپ',
                  style: TextStyle(fontSize: 30, fontFamily: 'semi-bold'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                MyTextFeild(
                  controller: _usernameController,
                  prefixIcon: Icons.person,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'User Name'
                      : 'یوزر نیم',
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                MyTextFeild(
                  controller: _emailController,
                  prefixIcon: Icons.email,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Email'
                      : 'ای میل',
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                MyTextFeild(
                  controller: _mobileNumberController,
                  prefixIcon: Icons.mobile_friendly,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Mobile Number'
                      : 'موبائل نمبر',
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                MyTextFeild(
                  controller: _cinicController,
                  prefixIcon: Icons.perm_identity,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'CNIC'
                      : 'شناختی کارڈ',
                  obscureText: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                MyTextFeild(
                  controller: _passwordController,
                  prefixIcon: Icons.email,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Password'
                      : 'پاس ورڈ',
                  obscureText: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final error = await AuthServices().signup(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      username: _usernameController.text.trim(),
                      mobileNumber: _mobileNumberController.text.trim(),
                      cnic: _cinicController.text.trim(),
                    );

                    if (error != null) {
                      print(error);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error occurred: $error")),
                      );
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'Sign Up'
                        : 'سائن اپ',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'semi-bold',
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5DCE35),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 50)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserLoginScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Already have an account?'
                            : 'کیا آپ کے پاس پہلے سے اکاؤنٹ ہے؟',
                      ),
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Log In'
                            : 'لاگ ان',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
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
