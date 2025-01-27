import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:reserve/CustomsWidgets/homeContainer1.dart';
import 'package:reserve/CustomsWidgets/homeContainer2.dart';
import 'package:reserve/CustomsWidgets/homeNavigationContainer.dart';
import 'package:reserve/views/Food/foodDonationScreen.dart';
import 'package:reserve/views/Food/foodScreenMain.dart';
import 'package:reserve/views/Other%20Item%20Donation/OtherItemDonationMainScreen.dart';
import 'package:reserve/views/Student%20Fee%20views/studentFeeMain.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FDFA),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              HomeScreenContainerName(
                name: 'User',
                image: AssetImage('assets/images/userPf.png'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StudentFeeMain();
                      }));
                    },
                    child: HomeNavigationContainer(
                      name: 'Education',
                      image: AssetImage('assets/images/educationLogo.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FoodScreenMain();
                      }));
                    },
                    child: HomeNavigationContainer(
                      name: 'Food',
                      image: AssetImage('assets/images/foodLogo.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OtherItmeDonationScreenMain();
                      }));
                    },
                    child: HomeNavigationContainer(
                      name: 'Donation',
                      image: AssetImage('assets/images/DonationLogo.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              HomeContainer2(
                text: "Come and Join us",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FoodDonationScreen();
                  }));
                },
                image: AssetImage('assets/images/foodHomeScreen.png'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              HomeContainer2(
                text: "Come and Join us",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StudentFeeMain();
                  }));
                },
                image: AssetImage('assets/images/educationHomeScreen.png'),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: IconThemeData(size: 30.0),
        backgroundColor: const Color.fromARGB(255, 186, 230, 137),
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.dark_mode),
            label: 'Dark Mode',
            onTap: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.logout),
            label: 'Logout',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
