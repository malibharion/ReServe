import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reserve/Database/connection.dart';
import 'package:reserve/StateManagment/Donations.dart';
import 'package:reserve/StateManagment/authProvider.dart';
import 'package:reserve/StateManagment/localization.dart';
import 'package:reserve/StateManagment/organzationColor.dart';
import 'package:reserve/StateManagment/studentHelpProvider.dart';
import 'package:reserve/StateManagment/themechnager.dart';
import 'package:reserve/views/login&signUp/userLoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConnection.initialize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ChnageColor()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => DonationProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => StudentHelpProvider()),
      ChangeNotifierProvider(create: (_) => LocalizationProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(360, 870),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        locale: localizationProvider.locale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ur', ''),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: themeProvider.themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: UserLoginScreen(),
      ),
    );
  }
}
