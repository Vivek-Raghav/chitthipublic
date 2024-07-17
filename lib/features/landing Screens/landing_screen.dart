import 'package:chitthi/colors.dart';
import 'package:chitthi/features/auth/screens/login_screen.dart';
import 'package:chitthi/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 50,
          ),
          // ignore: sized_box_for_whitespace
          Container(
              width: size.width,
              child: const Text(
                "Welcome to Chitthi",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          // ignore: sized_box_for_whitespace
          Container(
            height: size.height * 0.5,
            width: size.width,
            child: Image.asset("assets/email.png"),
          ),
          SizedBox(
            height: size.height / 9,
          ),
          const Text(
            "Read our privacy Policy. Tap \"Agree and Continue\" to accept the terms and services",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: greycolor),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                  text: "Agree and Continue",
                  onpressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  }))
        ],
      )),
    );
  }
}
