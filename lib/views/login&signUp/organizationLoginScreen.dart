import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';
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
                'Login',
                style: TextStyle(fontSize: 30, fontFamily: 'semi-bold'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              MyTextFeild(
                prefixIcon: Icons.email,
                hintText: 'Email',
                obscureText: false,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              MyTextFeild(
                prefixIcon: Icons.email,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'semi-bold',
                      color: Colors.white),
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
                child: Text('Login in as User',
                    style: TextStyle(color: Colors.black, fontSize: 15.sp)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
