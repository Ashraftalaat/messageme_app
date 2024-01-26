import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//لانضعه تحت كلاس معين حتي يكون متاح للصفحة مش للكلاس
final _firestore = FirebaseFirestore.instance;

//User هنا جاية من الفايربايس
//هتدينا الايميل
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //هذا المتغير لمسح الرسالة عند الضغط علي send لكتابة رسالة جديدة
  final messageTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

//؟ عشان سافتي ويروح الخطاء
//هتدينا الرسالة
  String? messageText;

//لتفعيل الميثود
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

//ميثود مش هتاخد اي مدخل او مخرج لذلك سميت ب void
  void getCurrentUser() {
    //ونظرا لاحتمالية الفشل هنضع try&catch
    try {
      //متغير بيكون التسجيل فيه بيستوي wtv
      final user = _auth.currentUser;
      //يعني لو المتغير لايساوي صفر يعني مستخدم قام بتسجيل الدخول
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //لجلب وعرض الرسايل من الفايرستور
  //عشان فيوتشرهنضيفasync
  // void getMessages() async {
  //get() بترجع البيانات من نوع"Query Snapshot"اي نسخة من البيانات داخل "firestore"
  // final messages = await _firestore.collection('messages').get();
//docs=document in firestore
//for لعرض كل قائمة علي حدة
  //for (var message in messages.docs) {
  //data هنا تبع كل دوكينت هنستديها
  //print(message.data());
  //}
  //}

  //هنستخدم طريقة افضل "streams"
//حتي لو حدث تغيير يظهر مباشرة بشكل فوري ومتزامن من خلال snapshot
  // void messagesStreams() async {
  // await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //   for (var message in snapshot.docs) {
  //    print(message.data());
  //  }
  //  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 106, 27),
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            const SizedBox(
              width: 10,
            ),
            const Text('MessageMe'),
          ],
        ),
        //لاضافة زر الاغلاق
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ],
      ),
      //عشان ابعد اطراف التطبيق عن حواف الموبايل
      body: SafeArea(
          child: Column(
        //بتدفع عمود الرسائل لأعلي
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MessageStreamBuilder(),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.orange,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    //لمسح الرسالة وكتابة اخري عن الضغط علي send
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'write your message here ...',
                        border: InputBorder.none),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //لمسح الرسالة وكتابة اخري عن الضغط علي send
                    messageTextController.clear();
                    _firestore.collection('messages').add({
                      'text': messageText,
                      'sender': signedInUser.email,
                      //لتعطينا التوقيت
                      'time': FieldValue.serverTimestamp(),
                    });
                  },
                  child: const Text(
                    'send',
                    style: TextStyle(
                      color: Color.fromARGB(255, 23, 118, 197),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return //عملنا هذا الكونتينر لدفع حقل الرسائل لاسفل الشاشة
        //Container(),
        //هنستخدم بداله StreamBuilder
        //يعني اني ببني StreamBuilder  وبتستمع QuerySnapshot
        //وبهذه الطريقة ربطنا بين firestore & widget
        StreamBuilder<QuerySnapshot>(
      //stream يعني من فين هتيجي البيانات اللي هتتعرض بداخل
      //snapshots()عشان الريال تايم
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
    
      //snapshot بتختلف عن اللي فوق لانها مش بتيجي من الفايرستور لكن بتيجي من AsyncSnapshot
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];
        //لازم نفحص الاول انه هناك موجود بيانات ام لا
        //!snapshot.hasDataيعني لو مفيهاش بيانات
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        //reversedلظهور اخر رسالة في الاخر
        final messages = snapshot.data!.docs.reversed;
        // استخدمناها لكي نحصل علي عنصر واحد من هذه القائمة
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = signedInUser.email;

          //اذا كان المستخدم اللي عامل تسجيل دخول هو اللي باعت الرسالة
          // if (currentUser == messageSender) {
          //the code of the message from the signed in user
          //}  تم تبديلها ب"if" المختصرة

          //messageWidget  بدون "Sعشان الفرق بينها وبين اللاست اللي فوق"
          //علامة"$" لكي استخدم القيمة اللي بداخلها
          final messageWidget = MessageLine(
            sender: messageSender,
            text: messageText,
            //استخدمنا "if" المختصرة
            isMe: currentUser == messageSender,
          );

          messageWidgets.add(messageWidget);
        }

        //لجعل الشات يملئ المساحة المتوفرة فقط
        return Expanded(
          //لجعل الشاشة سكرول
          child: ListView(
            //لظهور اخر رسالة في الاخر بعداضافتها لل"docs"
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

// لتظبيط الرسالة من خلال StatelessWidget
class MessageLine extends StatelessWidget {
  const MessageLine({super.key, this.sender, this.text, required this.isMe});
//?للsafity
  final String? sender;
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    //لتلوين  وعمل زواية هنستخدمMaterial
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        //عشان ننقلهم يمين
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          ),
          Material(
            //لعمل خيال
            elevation: 5,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            //"if"المختصرة يعني لو كان المتغير "isMe" "true"هنلونه ازرق
            color:
                isMe ? const Color.fromARGB(255, 33, 107, 168) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
