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

class ChatRoomScreen extends StatefulWidget {
  final UserVo user;
  static const routeName = '/chat_screen';

  const ChatRoomScreen({Key? key, required this.user}) : super(key: key);

  @override
  createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ChatRoomScreenState {
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

}
