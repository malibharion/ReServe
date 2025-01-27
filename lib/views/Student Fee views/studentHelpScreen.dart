import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';

class StudnetHelpScreen extends StatefulWidget {
  const StudnetHelpScreen({super.key});

  @override
  State<StudnetHelpScreen> createState() => _StudnetHelpScreenState();
}

class _StudnetHelpScreenState extends State<StudnetHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Help', style: TextStyle(fontFamily: 'semi-bold')),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              prefixIcon: Icons.person,
              hintText: 'Name',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              prefixIcon: Icons.person,
              hintText: 'Father Name',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5DCE35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(double.infinity, 50)),
            ),
            Text('Add Fee Slip Photo',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'light')),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5DCE35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(double.infinity, 50)),
            ),
            Text('Add CNIC Photo',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'light')),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Ask For Help',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'semi-bold',
                      color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 2, color: Color(0xFF5DCE35)),
                    backgroundColor: Color(0xFFF9FDFA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(double.infinity, 50)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
