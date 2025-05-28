import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';

import 'package:reserve/Database/authentication.dart';
import 'package:reserve/StateManagment/authProvider.dart';
import 'package:reserve/StateManagment/localization.dart';

import 'package:reserve/views/homeScreen.dart';
import 'package:reserve/views/login&signUp/organizationLoginScreen.dart';
import 'package:reserve/views/login&signUp/signUpScreen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _authServices = AuthServices();
  Future<void> _loginUser(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.isLoading = true;

    final error = await _authServices.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    authProvider.isLoading = false;

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An Error")),
      );
    }
  }

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
                      ? 'Login'
                      : 'لاگ ان',
                  style: TextStyle(fontSize: 30, fontFamily: 'semi-bold'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                MyTextFeild(
                  controller: _emailController,
                  prefixIcon: Icons.person,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Email'
                      : 'ای میل',
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
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () => _loginUser(context),
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              localizationProvider.locale.languageCode == 'en'
                                  ? 'Login'
                                  : 'لاگ ان',
                              style: const TextStyle(
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
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    localizationProvider.toggleLanguage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DCE35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.language, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Change Language'
                            : 'زبان تبدیل کریں',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'semi-bold',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? "Don't have an account?"
                            : 'اکاؤنٹ نہیں ہے؟',
                      ),
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Sign Up'
                            : 'سائن اپ',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrganizationLoginScreen()));
                  },
                  child: Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'Login in as organization'
                        : 'ادارہ کے طور پر لاگ ان کریں',
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
