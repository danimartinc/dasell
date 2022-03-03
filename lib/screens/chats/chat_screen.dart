//Models
import 'package:DaSell/commons.dart';
import 'package:DaSell/maps/screens/screens.dart';
import 'package:DaSell/provider/ad_provider.dart';
import 'package:DaSell/utils/native_utils.dart';
import 'package:DaSell/widgets/chat/messages.dart';
import 'package:DaSell/widgets/chat/new_message.dart';
import 'package:DaSell/widgets/chat/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'chat_state.dart';
import 'widgets/chat_appbar_title.dart';
import 'widgets/chat_back_button.dart';

class ChatScreen extends StatefulWidget {
  final UserVo user;
  static const routeName = './chat_screen';

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  createState() => _ChatScreenState();
}

class _ChatScreenState extends ChatScreenState {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/chat_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 100,
              titleSpacing: 0,
              leading: ChatBackButton(
                onTap: onBackTap,
                imageUrl: otherUser.profilePicture,
              ),
              title: ChatAppBarTitle(
                name: otherUser.textName,
                status: otherUser.textStatus,
              ),
            ),
          ),
          body: getContent(),
        ),
      ],
    );
  }

  Widget getContent() {
    return Column(
      children: [
        Expanded(
          child: Messages(
            documentId: docId,
            senderId: uid,
            receiverId: otherUser.uid,
          ),
        ),
        NewMessage(
          documentId: docId,
          senderId: uid,
          receiverId: otherUser.uid,
          onAttachTap: onAttachTap,
        ),
      ],
    );
  }

  Future<void> onAttachTap() async {
    final result = await showModalBottomSheet<ChatAttachment>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) => ChatBottomSheetModal(),
    );
    if (result == ChatAttachment.camera) {
      uploadImage(ImageSource.camera);
    } else if (result == ChatAttachment.gallery) {
      uploadImage(ImageSource.gallery);
    } else if (result == ChatAttachment.location) {
      /// open map ?
      context.push(MapLoadingScreen(
        receiverId: otherUser.uid,
      ));
    }
    // ChatAttachment.camera
    //
    // pickImage(
    //   context,
    //   ImageSource.gallery,
    // );
    // Navigator.of(context).pop();
    //
    // context.push(MapLoadingScreen());
    // Navigator.of(context).pushReplacementNamed(
    //     MapLoadingScreen.routeName,
    //     arguments: {
    //       ChatRoomVo()
    //       //senderID,
    //       //receiverID
    //     }
    // );

    //Navigator.of(context).pushReplacementNamed( LoadingScreen.routeName );
  }

  Future<void> uploadImage(ImageSource source) async {
    final image = await NativeUtils.pickImage(source);
    // trace(myUser);
    // trace(otherUser);
    // docId
    // if ( senderID!.compareTo(receiverID!) > 0 ) {
    //   documentID = receiverID + senderID;
    // } else {
    //   documentID = senderID + receiverID;
    // }
    //
    await Provider.of<AdProvider>(context, listen: false).uploadImage(
      image,
      docId,
      myUser.uid,
      otherUser.uid,
    );
  }
}
