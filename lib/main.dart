import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/signin_screen.dart';
import 'screens/welcome_screen.dart';

//عشان  نستخدم خدمات الفايربيس
//async تم اضافتها لانها عبارة عن فيوتشر
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //عشان نعمل تهيئة للفايربايس و التطبيق
  //await هي الكلمة المفتاحية
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MessageMe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const WelcomeScreen(),
      //نستخدمها بدل home
      //لفتح الصفحة الرئيسيةبس لازم نكملroutes
      //يعني لو قيمة المستخدم الحالي لاتساوي صفر افتح الشات سكرين ولوصفر لاتفتحها
      initialRoute: _auth.currentUser != null
          ? ChatScreen.screenRoute
          : WelcomeScreen.screenRoute,
      routes: {
        //map<'keys'string,'value'widgets function> mapName'routes'{بداخلها الصفحات}
        //  وبفضل هذا المتغير او البروبرتر استدعينا اسم الصفحة فقط من خلال static
        //دون تحميل الصفحة كلها حتي لايصبح حمل علي التطبيق
        WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
        SignInScreen.screenRoute: (context) => const SignInScreen(),
        RegistrationScreen.screenRoute: (context) => const RegistrationScreen(),
        ChatScreen.screenRoute: (context) => const ChatScreen(),
      },
    );
  }
}
