import 'package:flutter/material.dart';
import 'package:reserve/CustomsWidgets/studentFeeContainer.dart';
import 'package:reserve/views/Student%20Fee%20views/studentFeeDonationScreen.dart';
import 'package:reserve/views/Student%20Fee%20views/studentHelpScreen.dart';

class StudentFeeMain extends StatefulWidget {
  const StudentFeeMain({
    super.key,
  });

  @override
  State<StudentFeeMain> createState() => _StudentFeeMainState();
}

class _StudentFeeMainState extends State<StudentFeeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description',
                  style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
                ),
              ),
              Text(
                'We help students to reach their goals by helping them finanacially and provide financial aids.Come and join us in our cause and help us toward a better society.Your liltle help can save someone future.',
                style: TextStyle(fontFamily: 'regular', fontSize: 15),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StudnetFeeDonationScreen();
                  }));
                },
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StudnetHelpScreen();
                  }));
                },
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
            ],
          ),
        ),
      ),
    );
  }
}
