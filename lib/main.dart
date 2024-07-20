import 'package:flutter/material.dart';
import 'package:job_portal/mys.dart';
import 'package:job_portal/screens/admin_screens/admin.dart';
import 'package:job_portal/screens/user_screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/intro_screens/on_boarding_screen.dart';
import "firebase_options.dart";
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  final String? role = prefs.getString('role'); // Fetch user role
  final String? id = prefs.getString('userID'); // Fetch user role

  runApp(MyApp(isFirstTime: isFirstTime, role: role, userId: id));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final String? role;
  final String? userId;

  const MyApp(
      {Key? key,
      required this.isFirstTime,
      required this.role,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget homeScreen;

    if (isFirstTime || role == null) {
      // Show onboarding screen if it's the first time or if user role is not defined
      homeScreen = const OnBoardingScreen();
    } else if (role == 'admin') {
      // Show admin screen if user role is admin
      homeScreen = AdminMainScreen(adminId: userId);
    } else {
      // Show home screen for regular users
      homeScreen = UserMainScreen(userId: userId);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: My(),
      ),
    );
  }
}
