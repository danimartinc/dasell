import 'package:DaSell/commons.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static FirebaseService get() => locator.get();

  late final firestore = FirebaseFirestore.instance;
  late final auth = FirebaseAuth.instance;

  Future<void> init() async {
    await Firebase.initializeApp();
    // final uid = .currentUser!.uid;
  }

  bool get hasUser => auth.currentUser!=null;
  String get uid => auth.currentUser!.uid;
  Future<void> setUserOnline(bool flag) async {
    if(!hasUser){
      return ;
    }
    await firestore.collection('users').doc(uid).update({
      'status': flag ? "En línea" : "",
    });
  }

}
