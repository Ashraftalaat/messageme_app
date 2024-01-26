//عشان نقدر نسجل مستخدم جديد
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
//استيراد بروجريس لاظهار علامة التحميل
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/my_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registrstion_screen';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //final لانه لنيتم تغييره بالمستقبل وبمساعدة"_" هيكون خاص ةهيشتغل في هذه الصفحة فقط
  //وهذه تستخدم لتسجيل مستخدم جديد
  final _auth = FirebaseAuth.instance;

  //وضعنا كلمة late لاننا مش هنديهم قيمةعشان safity
  late String email;
  late String password;
//لعمل متغير التحميل
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 180,
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                //لفتح "keyboard" بها @ لكتابة الايميل
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                //بتحتوي علي القيمة التي سوف يقوم المستخدم بادخالها
                onChanged: (value) {
                  email = value;
                },
                //التي سوف تساعدنا علي تغيير تصميم الحقل"field"
                decoration: const InputDecoration(
                  hintText: 'Enter your Email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //لعمل حواف دائرية
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  //قبل التأشير
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  //بعد التأشير عليها
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                //حتي تكون القيمة مخفية
                obscureText: true,
                textAlign: TextAlign.center,
                //بتحتوي علي القيمة التي سوف يقوم المستخدم بادخالها
                onChanged: (value) {
                  password = value;
                },
                //التي سوف تساعدنا علي تغيير تصميم الحقل"field"
                decoration: const InputDecoration(
                  hintText: 'Enter your Password',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //لعمل حواف دائرية
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  //قبل التأشير
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  //بعد التأشير عليها
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                color: const Color.fromARGB(255, 24, 96, 155),
                title: 'register',
                //async للاحداث غير المتزامنة
                //وبنستخدمها هنا عشان في المستقبل
                //وبنقو للطبيق متكملش عمل او شغل او تحميل بدون الايميل والباص
                //sync للاحداث المتزامنة
                //لما تكون العمليات او الميثود تحدث سوا في وقت واحد
                onPressed: () async {
                  //print(email);
                  //print(password);
                  //بما ان هذا التغيير تفاعلي لازم نضعها داخل set
                  setState(() {
                    //عند الضغط قيمة المتغير هتتغير من falseاليtrueوذلك لاظهار علامة التحميل
                    showSpinner = true;
                  });

                  //لتسجيل مستخدم جديد
                  //createUserWithEmailAndPassword هترجع ليناالايميل والباص في المستقبل وهتاخد وقت كبير ومعني فيوتشر انها ستنتهي في المستقبل
                  //وهنحط القيمة اللي هتيجي منها في متغير وهو newUser
                  //await يعني انتظر تحميل البرنامج حتي تسجيل عضو جديد
                  //وبما انه في احتمالية ان العملية تفشل لاي سبب سواء كان مسجل قبل كدة
                  //او كلمة مرور ضعيفة ولنعرف هذه المشكلة نستخدم try&catch
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.screenRoute);
                    //عشان يتوقف التحميل وميظلش مؤشر التحميل شغال
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
