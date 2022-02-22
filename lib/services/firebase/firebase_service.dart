import 'dart:async';

import 'package:DaSell/commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'models/product_vo.dart';
import 'models/user_vo.dart';

class FirebaseService {
  static FirebaseService get() => locator.get();

  late final firestore = FirebaseFirestore.instance;
  late final auth = FirebaseAuth.instance;
  late final fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  bool get hasUser => auth.currentUser != null;

  String get uid => auth.currentUser!.uid;

  Future<void> updateUserToken() async {
    var token = await fcm.getToken();
    firestore.collection('users').doc(uid).update({'token': token});
  }

  Future<void> setUserOnline(bool flag) async {
    if (!hasUser) {
      return;
    }
    await firestore.collection('users').doc(uid).update({
      'status': flag ? "En línea" : "",
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

  StreamSubscription subscribeToChats(
      Function(QuerySnapshot<Map<String, dynamic>> event) onData) {
    final stream = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timeStamp', descending: true)
        .snapshots();
    return stream.listen(onData);
  }
}
