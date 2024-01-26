import 'package:flutter/material.dart';
import 'package:messageme_app/screens/registration_screen.dart';
import '../screens/signin_screen.dart';

import '../widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
//وذلك لما استدعي هذا المتغير او البروبرتي "لما بيكون داخل الكلاس"
//وبالتالي لا يتم انشاء كامل الصفحة لما نستدعيه و هيبطئ التطبيق
//وبمساعدة static هنستدعي البروبرتي دون ان نحمل الكلاس كامل
  static const String screenRoute = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Image.asset('images/logo.png'),
                ),
                const Text(
                  'MessageMe',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 22, 45, 114)),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              title: 'Sign In',
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.screenRoute);
              },
            ),
            MyButton(
              color: const Color.fromARGB(255, 43, 110, 161),
              title: 'register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
