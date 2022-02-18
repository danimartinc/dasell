
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomVo {
  bool? isRead;
  String? lastMessage;
  String? senderId;
  String? timeStamp;
  String? docId;

  /// no se si es válido
  DateTime? get dateTimeStamp {
    if(timeStamp==null){
      return null;
    }
    return DateTime.tryParse(timeStamp!);
  }

  ChatRoomVo(
      {this.isRead,
        this.lastMessage,
        this.senderId,
        this.timeStamp,
        this.docId});


  ChatRoomVo.fromDoc(DocumentSnapshot json) {
    isRead = json['isRead'];
    lastMessage = json['lastMessage'];
    senderId = json['senderId'];
    timeStamp = json['timeStamp'];
    docId = json['docId'];
  }

  ChatRoomVo.fromJson(Map<String, dynamic> json) {
    isRead = json['isRead'];
    lastMessage = json['lastMessage'];
    senderId = json['senderId'];
    timeStamp = json['timeStamp'];
    docId = json['docId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRead'] = this.isRead;
    data['lastMessage'] = this.lastMessage;
    data['senderId'] = this.senderId;
    data['timeStamp'] = this.timeStamp;
    data['docId'] = this.docId;
    return data;
  }

  String getOtherUserId(String idToRemove) {
    return docId!.replaceFirst(idToRemove, '').trim();
  }
}