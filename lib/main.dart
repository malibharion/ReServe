import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/Database/connection.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/authProvider.dart';
import 'package:reserve/StateManagment/organzationColor.dart';
import 'package:reserve/views/login&signUp/userLoginScreen.dart';

void main() async {
  await SupabaseConnection.initialize();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ChnageColor()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => DonationProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 870),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        home: UserLoginScreen(),
      ),
    );
  }
}
