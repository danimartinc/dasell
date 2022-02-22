//Models
import 'package:DaSell/models/user.dart';
import 'package:DaSell/widgets/chat/messages.dart';
//Widgets
import 'package:DaSell/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  final UserVo user;
  static const routeName = './chat_screen';

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserVo get userData => widget.user;

  @override
  Widget build(BuildContext context) {
    // final userData = ModalRoute.of(context)!.settings.arguments as UserModel?;
    //final Map<String, dynamic> userMap;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    print('data is $userData');
    print('name is ${userData.name}');
    print('email is ${userData.email}');
    print('profile is ${userData.profilePicture}');
    print('uid is ${userData.uid}');

    var documentId = '';

    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (userData.uid.compareTo(uid) > 0) {
      documentId = uid + userData.uid;
    } else {
      documentId = (userData.uid + uid);
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/chat_back.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 100,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 24,
                        ),
                        SizedBox(
                          height: 600,
                        ),
                        userData.profilePicture != ''
                            ? CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  userData.profilePicture!,
                                ),
                              )
                            : Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/boy.svg',
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              title: StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(userData.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData.textName,
                              style: TextStyle(
                                fontSize: 18.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data!['status'],
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Messages(
                  documentId: documentId,
                  senderId: uid,
                  receiverId: userData.uid,
                ),
              ),
              NewMessage(
                documentId: documentId,
                senderId: uid,
                receiverId: userData.uid,
                //animationController: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
