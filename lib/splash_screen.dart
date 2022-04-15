import 'package:diet_planner/home_screen.dart';
import 'package:diet_planner/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isNew = true;

  navigate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isNew = preferences.getBool("isNew") ?? true;
    await Future.delayed(const Duration(seconds: 1));
    isNew
        ? Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UserDetailsScreen()))
        : Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeNavigationScreen()));
  }

  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/icon.png",
              width: 200,
              height: 200,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "Made With ❤ By Vinay",
                  style: GoogleFonts.lato(),
                ),
              ))
        ],
      ),
    );
  }
}
