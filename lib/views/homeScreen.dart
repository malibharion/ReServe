import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:reserve/CustomsWidgets/homeContainer1.dart';
import 'package:reserve/CustomsWidgets/homeContainer2.dart';
import 'package:reserve/CustomsWidgets/homeNavigationContainer.dart';
import 'package:reserve/Functions/userId.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/StateManagment/themechnager.dart';
import 'package:reserve/views/Food/foodDonationScreen.dart';
import 'package:reserve/views/Food/foodScreenMain.dart';
import 'package:reserve/views/Other%20Item%20Donation/OtherItemDonationMainScreen.dart';
import 'package:reserve/views/Student%20Fee%20views/studentFeeMain.dart';
import 'package:reserve/views/login&signUp/userLoginScreen.dart';
import 'package:reserve/views/notifactionscreen.dart';
import 'package:reserve/views/reportScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "User";
  ImageProvider? profileImage;
  int? currentUserId;

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final data = await Supabase.instance.client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        username = data['username'] ?? "User";

        final picUrl = data['user_profile_pic'] as String?;
        if (picUrl != null && picUrl.isNotEmpty) {
          profileImage = NetworkImage(picUrl);
        } else {
          profileImage = AssetImage('assets/images/userPf.png');
        }
      });
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    final localizationProvider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DonationStatusScreen(
                      userId: currentUserId.toString(),
                    );
                  }));
                },
                child: Icon(Icons.notifications)),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                HomeScreenContainerName(
                  name: localizationProvider.locale.languageCode == 'en'
                      ? 'User'
                      : 'صارف',
                  image: profileImage,
                ),
                SizedBox(height: 35.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                          name: localizationProvider.locale.languageCode == 'en'
                              ? 'Education'
                              : 'تعلیم',
                          image: const AssetImage(
                              'assets/images/educationLogo.png'),
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
                          name: localizationProvider.locale.languageCode == 'en'
                              ? 'Food'
                              : 'خوراک',
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
                          name: localizationProvider.locale.languageCode == 'en'
                              ? 'Donation'
                              : 'عطیہ',
                          image: const AssetImage(
                              'assets/images/DonationLogo.png'),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return YourDonationsScreen();
                          }));
                        },
                        child: HomeNavigationContainer(
                          name: localizationProvider.locale.languageCode == 'en'
                              ? 'Your Donation'
                              : 'عطیہ',
                          image: const AssetImage(
                              'assets/images/icons8-report-30.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                HomeContainer2(
                  text: localizationProvider.locale.languageCode == 'en'
                      ? "Come and Join us"
                      : "آئیں اور ہمارا حصہ بنیں",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FoodDonationScreen();
                    }));
                  },
                  image: const AssetImage('assets/images/foodHomeScreen.png'),
                ),
                SizedBox(height: 20.h),
                HomeContainer2(
                  text: localizationProvider.locale.languageCode == 'en'
                      ? "Come and Join us"
                      : "آئیں اور ہمارا حصہ بنیں",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: false);
            final localization =
                Provider.of<LocalizationProvider>(context, listen: false);

            setState(() => _currentIndex = index);
            switch (index) {
              case 0:
                localization.toggleLanguage();
                break;
              case 1:
                themeProvider.toggleTheme(!themeProvider.isDarkMode);
                break;
              case 2:
                // Handle logout here
                break;
            }
          },
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: 'Language',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dark_mode),
              label: 'Theme',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        ));
  }
}
