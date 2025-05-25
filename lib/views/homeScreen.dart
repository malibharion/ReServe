import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/homeContainer1.dart';
import 'package:reserve/CustomsWidgets/homeContainer2.dart';
import 'package:reserve/CustomsWidgets/homeNavigationContainer.dart';
import 'package:reserve/StateManagment/themechnager.dart';
import 'package:reserve/views/Food/foodDonationScreen.dart';
import 'package:reserve/views/Food/foodScreenMain.dart';
import 'package:reserve/views/Other%20Item%20Donation/OtherItemDonationMainScreen.dart';
import 'package:reserve/views/Student%20Fee%20views/studentFeeMain.dart';
import 'package:reserve/views/login&signUp/userLoginScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              HomeScreenContainerName(
                name: 'User',
                image: const AssetImage('assets/images/userPf.png'),
              ),
              SizedBox(height: 35.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      image:
                          const AssetImage('assets/images/educationLogo.png'),
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
                      image: const AssetImage('assets/images/foodLogo.png'),
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
                      image: const AssetImage('assets/images/DonationLogo.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              HomeContainer2(
                text: "Come and Join us",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FoodDonationScreen();
                  }));
                },
                image: const AssetImage('assets/images/foodHomeScreen.png'),
              ),
              SizedBox(height: 20.h),
              HomeContainer2(
                text: "Come and Join us",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StudentFeeMain();
                  }));
                },
                image:
                    const AssetImage('assets/images/educationHomeScreen.png'),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: const IconThemeData(size: 30.0),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.dark_mode),
            label: 'Dark Mode',
            onTap: () {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.logout),
            label: 'Logout',
            onTap: () async {
              final supabase = Supabase.instance.client;

              try {
                await supabase.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserLoginScreen()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
