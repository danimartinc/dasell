import '../../../commons.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../provider/ad_provider.dart';
import 'widgets/signout_dialog.dart';


abstract class ProfileScreenState extends State<ProfileScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void pickImage( BuildContext context, ImageSource src ) async {
    
    File? storedImage;
    File? pickedImage;
    bool isLoading = false;

    final picker = new ImagePicker();

    final XFile? pickedImageFile =
        await picker.pickImage(source: src, maxWidth: 600, imageQuality: 70);

    if (pickedImageFile == null) {
      return;
    }

    storedImage = File(pickedImageFile.path);

    //Parte importante
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename( storedImage.path);
    final savedImage = await storedImage.copy('${appDir.path}/$fileName');
    pickedImage = savedImage;


    setState(() {
      isLoading = true;
    });

    await Provider.of<AdProvider>(context, listen: false)
        .uploadProfilePicture( pickedImage );

    setState(() {
      isLoading = false;
    });
  
  }


  void setStatus( String status ) async{

      await _firestore.collection('users').doc( uid ).update({
        'status': status,
      });
  }

  void onSignOutDialogPressed() {
    showDialog(
      context: context,
      builder: (context) => SignOutDialog(
        onSelect: signOut,
      ),
    );
  }

  void signOut( int option ) async {
      
      if( option == 1 ) {

        setStatus('Desconectado');

        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();

      }
      
    }


 }