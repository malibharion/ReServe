import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
import 'package:reserve/views/Organization/mainScreen.dart';
import 'package:reserve/views/Organization/organizationMainScreen.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/views/login&signUp/userLoginScreen.dart';

class OrganizationLoginScreen extends StatefulWidget {
  const OrganizationLoginScreen({super.key});

  @override
  State<OrganizationLoginScreen> createState() =>
      _OrganizationLoginScreenState();
}

class _OrganizationLoginScreenState extends State<OrganizationLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF9FDFA),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainRequestsScreen()));
                },
                child: Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Login'
                      : 'لاگ ان',
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserLoginScreen()));
                },
                child: Text(
                  localizationProvider.locale.languageCode == 'en'
                      ? 'Login in as User'
                      : 'صارف کے طور پر لاگ ان کریں',
                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
