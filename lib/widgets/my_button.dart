import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  //لعمل constractor
  //هنضيف required في حالة عدم تمريرهم هيظهر خطاء
  const MyButton(
      {super.key,
      required this.color,
      required this.title,
      required this.onPressed});
  final Color color;
  final String title;
  //تم استبدال
  //final Function onPressed;
  // ب voidcallback اي FUNCTION ليس لها مدخلات'ARGUMENTS'ولاتقوم بتشغيل اي شئ'return'
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        //الخيال
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        //الزر الذي سوف يتم الضغط عليه
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 280,
          height: 42,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
