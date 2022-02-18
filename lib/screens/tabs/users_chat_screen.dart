//Models
import 'package:DaSell/models/user.dart';
//Screens
import 'package:DaSell/screens/chats/chat_screen.dart';
import 'package:DaSell/screens/tabs/utils/badge_requester.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class UsersChatScreen extends StatefulWidget {

  static const routeName = '/chatScreen';

  @override
  _UsersChatScreenState createState() => _UsersChatScreenState();
}

class _UsersChatScreenState extends State<UsersChatScreen> {

  var docId;
  var receiverId;
  var receiverName;
  var receiverProfile;
  var receiverEmail;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    String getTimeAgoText(DateTime date) {
      // return '3 minutes ago';
      return timeago.format(date, locale: 'es');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // if ( snapshot.connectionState == ConnectionState.waiting ) {
          //
          // }

          if (snapshot.hasData) {

            var documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                print('${index + 1} times it comes here');

                docId = documents[index]['docId'].toString();

                if (docId.contains(uid)) {
                  receiverId = docId.replaceFirst(uid, '').trim();
                  print("RID = $receiverId");
                  print("UID= $uid");
                  // hI6kO25DBwagNFfByqgOBkr7dME3k95q7onJ6RgnkjwYyMRLBT7PN4Q2
                  // hI6kO25DBwagNFfByqgOBkr7dME3
                  return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(receiverId)
                          .get(),
                      builder: (context, receiverData) {
                        if (receiverData.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        // snapshot.data?.docs[index].data()['title'],
                        // print("pero: ${receiverData.data?.data()}");
                        receiverEmail = receiverData.data!['email'];
                        receiverName = receiverData.data!['name'];
                        receiverId = receiverData.data!['uid'];
                        receiverProfile = receiverData.data!['profilePicture'];

                        //Comprobamos si tenemos información
                        if (snapshot.hasData) {
                          //Widget con la información
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  key: ValueKey(receiverId),
                                  leading: receiverProfile == ''
                                      ? Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: SvgPicture.asset(
                                              'assets/images/boy.svg'),
                                        )
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              NetworkImage(receiverProfile),
                                        ),
                                  title: Text(
                                    receiverName,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    documents[index]['senderId'] == receiverId
                                        ? documents[index]['lastMessage']
                                        : 'Tú: ${documents[index]['lastMessage']}',
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTimeAgoText(
                                          (documents[index]['timeStamp']
                                                  as Timestamp)
                                              .toDate(),
                                        ),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                      const SizedBox(height: 6),
                                      // request temporal para conseguir el
                                      // badge count del query.
                                      BadgeRequester(
                                        recieverId: receiverId,
                                        docId: docId,
                                        uid: uid,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print('receiverName is $receiverName');
                                    Navigator.of(context).pushNamed(
                                      ChatScreen.routeName,
                                      arguments: UserModel(
                                        userName: receiverData.data!['name'],
                                        email: receiverData.data!['email'],
                                        profilePicture: receiverData.data!['profilePicture'],
                                        uid: receiverData.data!['uid'],
                                        status: receiverData.data!['status'],
                                      ),
                                    );
                                  },
                                ),
                                Divider(
                                  height: 5,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                              ],
                            ),
                          );
                        } else {
                          //CircularProgressIndicator(), permite indicar al usuario que se está cargando infromación
                          return Center(
                              child: CircularProgressIndicator(strokeWidth: 2));
                        }
                      });
                } else
                  return Container();
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
