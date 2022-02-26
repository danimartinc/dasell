import 'dart:async';

import 'package:DaSell/commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'models/product_vo.dart';

class FirebaseService {
  static FirebaseService get() => locator.get();

  late final firestore = FirebaseFirestore.instance;
  late final auth = FirebaseAuth.instance;
  late final fcm = FirebaseMessaging.instance;

  // subscribe my firebase auth user.
  StreamSubscription? _firebaseUserSubscription;

  // subscribe to users doc.
  StreamSubscription? _myUserSubscription;

  Future<void> init() async {
    await Firebase.initializeApp();
    _firebaseUserSubscription =
        auth.authStateChanges().listen(_onFirebaseUserChange);
  }

  void _onFirebaseUserChange(User? event) {
    _myUserSubscription?.cancel();
    if (event != null) {
      if (hasUser) {
        _myUserSubscription = subscribeToUser(uid, _onMyUserDataChange);
      }
    }
  }

  void _onMyUserDataChange(DocumentSnapshot<Map<String, dynamic>> event) {
    myUserVo = UserVo.fromJson(event);
  }

  bool get hasUser => auth.currentUser != null;
  bool get hasUserVo => myUserVo != null;

  String get uid => auth.currentUser!.uid;

  // assign this when u login....
  UserVo? myUserVo;

  Future<void> updateUserToken() async {
    var token = await fcm.getToken();
    firestore.collection('users').doc(uid).update({'token': token});
  }

  Future<void> setUserOnline(bool flag) async {
    if (!hasUser) {
      return;
    }
    await firestore.collection('users').doc(uid).update({
      'status': flag ? 'En línea' : "",
    });
  }

  //// get products.
  Future<List<ResponseProductVo>?> getProducts({bool descending = true}) async {
    final res = await firestore
        .collection('products')
        .orderBy('createdAt', descending: descending)
        .get();
    final list = res.docs.toList();
    return list.map((e) => ResponseProductVo.fromJson(e.data())).toList();
  }

  void setLikeProduct(int productId, bool fav) {
    firestore.collection('products').doc('$productId').update({'isFav': fav});
  }

  Future<void> deleteAd(int docId) async {
    await firestore.collection('products').doc('$docId').delete();
  }

  Future<void> markAsSold(int docId) async {
    await firestore
        .collection('products')
        .doc('$docId')
        .update({'isSold': true});
  }

  Future<UserVo> getUser(String userId) async {
    final userData = await firestore.collection('users').doc(userId).get();
    return UserVo.fromJson(userData.data());
  }

  StreamSubscription subscribeToChats(QueryStreamDataCallback onData) {
    final stream = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timeStamp', descending: true)
        .snapshots();
    return stream.listen(onData);
  }

  StreamSubscription subscribeToUser(
    String userId,
    DocStreamDataCallback onData,
  ) {
    final stream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return stream.listen(onData);
  }

  String getChatDocId(UserVo otherUser) {
    if (otherUser.uid.compareTo(uid) > 0) {
      return uid + otherUser.uid;
    } else {
      return otherUser.uid + uid;
    }
  }

  Future<void> sendMessage(
    String message, {
    required String docId,
    required String senderId,
    required String receiverId,
  }) async {
    final ts = Timestamp.now();

    final messageData = {
      'message': message,
      'imageUrl': '',
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamp': ts,
      'isRead': false,
    };
    await firestore
        .collection('chats')
        .doc(docId)
        .collection('messages')
        .add(messageData);

    final chatData = {
      'docId': docId,
      'lastMessage': message,
      'senderId': senderId,
      'timeStamp': ts,
      'isRead': false,
    };
    await firestore.collection('chats').doc(docId).set(chatData);
  }
}

///Shortcurts
typedef DocStreamDataCallback = void Function(
    DocumentSnapshot<Map<String, dynamic>> event);
typedef QueryStreamDataCallback = void Function(
    QuerySnapshot<Map<String, dynamic>> event);
