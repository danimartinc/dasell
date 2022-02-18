import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void sendMessage( String documentID, String senderID, String receiverID ) async {

    //FocusScope.of(context).unfocus();
    final ts = Timestamp.now();
    TextEditingController messageController = TextEditingController();
    var enteredMessage = '';

    messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc( documentID )
        .collection('messages')
        .add(
          {
            'message': enteredMessage,
            'imageUrl': '',
            'senderId': senderID,
            'receiverId': receiverID,
            'timeStamp': ts,
            'isRead': false,
          }
        );
    
    await FirebaseFirestore.instance
        .collection('chats')
        .doc( documentID )
        .set(
          {
            'docId': documentID,
            'lastMessage': enteredMessage,
            'senderId': senderID,
            'timeStamp': ts,
            'isRead': false,
          },
        );


    /*setState(() {
      enteredMessage = '';
    });*/
  }