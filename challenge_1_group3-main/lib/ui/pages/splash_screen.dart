import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/pages/dashboard/home_page.dart';
import 'package:challenge1_group3/ui/pages/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      UserProvider provider = Provider.of<UserProvider>(context, listen: false);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  provider.isLogin ? HomePage() : LoginScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Trello Like App",
              style: CustomTextStyle.title16SemiBold,
            ),
            Text("Developed by Group 3"),
            Text("Lakehead University"),
          ],
        ),
      ),
    );
  }
}
