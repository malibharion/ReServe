import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      print("Image picked: ${picked.path}");
    } else {
      print("No image selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FDFA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage('assets/images/reserveLogo.png')),
                const SizedBox(height: 10),
                Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Sign Up'
                      : 'سائن اپ',
                  style: const TextStyle(fontSize: 30, fontFamily: 'semi-bold'),
                ),
                const SizedBox(height: 20),

                // Profile Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey[700])
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                MyTextFeild(
                  controller: _usernameController,
                  prefixIcon: Icons.person,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'User Name'
                      : 'یوزر نیم',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextFeild(
                  controller: _emailController,
                  prefixIcon: Icons.email,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Email'
                      : 'ای میل',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextFeild(
                  controller: _mobileNumberController,
                  prefixIcon: Icons.mobile_friendly,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Mobile Number'
                      : 'موبائل نمبر',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextFeild(
                  controller: _cinicController,
                  prefixIcon: Icons.perm_identity,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'CNIC'
                      : 'شناختی کارڈ',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextFeild(
                  controller: _passwordController,
                  prefixIcon: Icons.lock,
                  hintText: localizationProvider.locale.languageCode == 'en'
                      ? 'Password'
                      : 'پاس ورڈ',
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    print("Sign up button clicked.");
                    final error = await AuthServices().signup(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      username: _usernameController.text.trim(),
                      mobileNumber: _mobileNumberController.text.trim(),
                      cnic: _cinicController.text.trim(),
                      profileImage: _selectedImage,
                    );

                    if (error != null) {
                      print("Signup failed: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $error")),
                      );
                      return;
                    }

                    print("Signup success!");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DCE35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    localizationProvider.locale.languageCode == 'en'
                        ? 'Sign Up'
                        : 'سائن اپ',
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'semi-bold',
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserLoginScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Already have an account? '
                            : 'کیا آپ کے پاس پہلے سے اکاؤنٹ ہے؟ ',
                      ),
                      Text(
                        localizationProvider.locale.languageCode == 'en'
                            ? 'Log In'
                            : 'لاگ ان',
                        style: const TextStyle(color: Colors.blue),
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
