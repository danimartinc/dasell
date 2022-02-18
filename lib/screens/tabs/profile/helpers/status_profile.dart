
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final uid = FirebaseAuth.instance.currentUser!.uid;
  

void setStatus( String status ) async{

    await _firestore.collection('users').doc( uid ).update({
      'status': status,
    });
  }

  void signOut() async {

    setStatus("Desconectado");

    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    
  }