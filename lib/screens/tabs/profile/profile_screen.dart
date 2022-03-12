import 'package:DaSell/screens/favs/my_sell_ads_screen.dart';

import '../../../commons.dart';
import 'profile_state.dart';

//Widgets
import '../../../widgets/profile/image_picker_button.dart';
import '../../../widgets/profile/profile_switches.dart';
import 'widgets/open_dialog_btn.dart';


class ProfileScreen extends StatefulWidget {

  @override
  createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ProfileScreenState {

  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: ( context, snapshot) {

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
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: ImagePickerButton(
                            isLoading: isLoading,
                            ctx: context,
                            pickImage: pickImage,
                            profilePic: snapshot.data!['profilePicture'],
                          )
                        ),
                      ],
                    ),
                  ),
                  kGap15,
                  Text(
                    snapshot.data!['name'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                    ),
                  ),
                  kGap5,
                  Text(
                    snapshot.data!['email'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                  kGap15,
                  ExpansionTile(
                    leading: Icon( FontAwesomeIcons.cog, size: 22,),
                    title: Text(
                      'Configuración',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                    children: [
                      kGap10,
                      ProfileSwitches(),
                      kGap25,
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon( FontAwesomeIcons.handshake, size: 22,),
                    title: Text(
                    'Mis productos',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                    ),
                    ),
                    children: [
                     ListTile(
                       title: Text('Ventas'),
                       onTap: () {
                        
                        Provider.of<TabMenuProvider>(context, listen: false).setIndex(2);
                        Provider.of<MenuProvider>(context, listen: false).setIndex(1);
                       } 
                     ),
                    ],
                  ),
                  kGap15,
                  OpenDialogsButton(onPressed: onSignOutDialogPressed, ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
