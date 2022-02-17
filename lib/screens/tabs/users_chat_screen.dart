//Models
import 'package:DaSell/models/user.dart';
//Screens
import 'package:DaSell/screens/chats/chat_screen.dart';
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
                                  trailing: /*Padding(

                            padding: const EdgeInsets.fromLTRB(0, 8, 4, 4),
                            child: (snapshot.hasData && snapshot.data!.docs.length > 0)
                            ? Container(
                              width: 60,
                              height: 50,
                              child: Column(
                                children: <Widget>[
                                  Text((snapshot.hasData && snapshot.data!.docs.length >0)
                                    ? readTimestamp(snapshot.data!.docs[0]['timestamp'])
                                    : '',style: TextStyle(fontSize: size.width * 0.03),
                                  ),
                                  Padding(
                                      padding:const EdgeInsets.fromLTRB( 0, 5, 0, 0),
                                      child: CircleAvatar(
                                        radius: 9,
                                        child: Text(snapshot.data!.docs[0]['badgeCount'] == null ? '' : ((snapshot.data!.docs[0]['badgeCount'] != 0
                                          ? '${snapshot.data!.docs[0]['badgeCount']}'
                                          : '')),
                                        style: TextStyle(fontSize: 10),),
                                        backgroundColor: snapshot.data!.docs[0]['badgeCount'] == null ? Colors.transparent : (snapshot.data!.docs[0]['badgeCount'] != 0
                                          ? Colors.red[400]
                                          : Colors.transparent),
                                        foregroundColor:Colors.white,
                                      ),
                                  ),
                                ],
                              ),
                            ) : Text('')),*/

                                      Column(
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
                                        profilePicture: receiverData
                                            .data!['profilePicture'],
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

  String getTimeAgoText(DateTime date) {
    // return '3 minutes ago';
    return timeago.format(date, locale: 'es');
  }
}

class BadgeRequester extends StatefulWidget {

  final String docId, uid, recieverId;

  const BadgeRequester({
    Key? key,
    required this.recieverId,
    required this.docId,
    required this.uid,
  }) : super(key: key);

  @override
  _BadgeRequesterState createState() => _BadgeRequesterState();
}

class _BadgeRequesterState extends State<BadgeRequester> {

  int count = 0;
  //int totalCount = 0;

  @override
  void initState() {
    requestData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BadgeCount(count: count );
  }

  Future<void> requestData() async {

    final doc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.uid + widget.recieverId)
        .get();
        
    final messagesResults = await (doc.reference
            .collection('messages')
            .where('receiverId', isEqualTo: widget.uid)
            .where('isRead', isEqualTo: false))
        .get();
    
    /*final totalMessagesResults = await (doc.reference
            .collection('messages')
            .where('receiverId', isEqualTo: widget.uid)
            .where('isRead', isEqualTo: false))
        .get();*/

    if( this.mounted ) {

          setState(() {
            count = messagesResults.size;
            //totalCount = totalMessagesResults.size;
          });
    }


    }

}

/// Custom UI para mostrar la cantidad de mensajes no leidos
class BadgeCount extends StatelessWidget {

  final int count;
 // final int totalCount;

  const BadgeCount({
    Key? key,
    required this.count,
   //required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox();
    final label = count <= 99 ? '$count' : '99+';
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(24),
      ),
      constraints: BoxConstraints(minWidth: 20, maxHeight: 20),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            shadows: const [
              Shadow(
                color: Colors.black12,
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ]),
      ),
    );
  }
}
