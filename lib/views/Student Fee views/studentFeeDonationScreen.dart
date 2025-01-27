import 'package:flutter/material.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/CustomsWidgets/textfeild.dart';

class StudnetFeeDonationScreen extends StatefulWidget {
  const StudnetFeeDonationScreen({super.key});

  @override
  State<StudnetFeeDonationScreen> createState() =>
      _StudnetFeeDonationScreenState();
}

class _StudnetFeeDonationScreenState extends State<StudnetFeeDonationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            ScreenTopContainer(
              onTap: () {
                print('On tap was fired');
                Navigator.pop(context);
              },
              image: AssetImage('assets/images/kidEducation.png'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              'Help Students to get better education',
              style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              prefixIcon: Icons.person,
              hintText: 'Enter Your Name',
              obscureText: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            MyTextFeild(
              prefixIcon: Icons.money,
              hintText: 'Enter amount',
              obscureText: false,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Donate',
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
            ),
          ],
        ),
      )),
    );
  }
}
