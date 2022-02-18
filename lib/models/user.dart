// To parse this JSON data, do
//
//     final userVo = userVoFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userName;
  String? email;
  String? profilePicture;
  String? uid;
  String? status;

  UserModel(
      {this.userName, this.email, this.profilePicture, this.uid, this.status});
}

class UserVo {
  String? token;
  String? name;
  String? uid;
  String? status;
  String? email;
  String? profilePicture;

  String get textName => name ?? '-';

  UserVo({
    this.token,
    this.name,
    this.uid,
    this.status,
    this.email,
    this.profilePicture,
  });

  UserVo.fromDoc(DocumentSnapshot json) {
    token = json['token'];
    name = json['name'];
    uid = json['uid'];
    status = json['status'];
    email = json['email'];
    profilePicture = json['profilePicture'];
  }

  UserVo.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    uid = json['uid'];
    status = json['status'];
    email = json['email'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['status'] = this.status;
    data['email'] = this.email;
    data['profilePicture'] = this.profilePicture;
    return data;
  }

  @override
  String toString() {
    return 'UserVo{token: $token, name: $name, uid: $uid, status: $status, email: $email, profilePicture: $profilePicture}';
  }
}




// const firebaseConfig = {
//   apiKey: "AIzaSyC9oIhVx-R9orUyVXorJSqn_AAfVn0tI9o",
//   authDomain: "shop-chat-88e88.firebaseapp.com",
//   databaseURL: "https://shop-chat-88e88-default-rtdb.europe-west1.firebasedatabase.app",
//   projectId: "shop-chat-88e88",
//   storageBucket: "shop-chat-88e88.appspot.com",
//   messagingSenderId: "40523523478",
//   appId: "1:40523523478:web:d23530025a6de670d969b7",
//   measurementId: "G-H6N165G0VX"
// };

// https://firestore.googleapis.com/v1/projects/shop-chat-88e88/databases/(default)/documents/chats
