import 'package:DaSell/commons.dart';
import 'package:DaSell/widgets/profile/profile_switches.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late BuildContext ctx;
  bool isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonProgress();
        }

        return Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: snapshot.data!['profilePicture'] == ''
                              //name: doc.data()['name'] ?? ''
                              ? SvgPicture.asset(
                                  'assets/images/boy.svg',
                                )
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!['profilePicture'],
                                  ),
                                ),
                        ),

                        /// TODO: ROTO
                        ///Positioned(
                        ///    right: 0,
                        ///    bottom: 0,
                        ///    child: ImagePickerButton(
                        ///      isLoading: isLoading,
                        ///      ctx: ctx,
                        ///     pickImage: _pickImage,
                        ///      profilePic: snapshot.data!['profilePicture'],
                        ///    )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    snapshot.data!['name'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    snapshot.data!['email'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProfileSwitches(),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.logout,
                    ),
                    onPressed: () => showDialog(
                        context: ctx,
                        builder: (context) => AlertDialog(
                              title: Text('Cerrar sesión'),
                              content:
                                  Text('¿Está seguro de querer cerrar sesión?'),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Cerrar',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                ElevatedButton(
                                  child: Text('Confirmar'),
                                  onPressed: () {
                                    /// TODO: ROTO
                                    /// _signOut();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )),
                    label: Text('Cerrar sesión'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
