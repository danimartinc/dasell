import 'package:DaSell/commons.dart';

import 'dart:async';

import '../../chats/chat_screen.dart';
import 'models.dart';

abstract class UsersChatController extends State<UsersChatScreen> {
  User? get myUser => FirebaseAuth.instance.currentUser!;
  late StreamSubscription chatStreamSub;
  List<ChatViewItemVo> dataItems = [];

  final _service = FirebaseService.get();

  @override
  void initState() {
    chatStreamSub = _service.subscribeToMyChats(onChatDataChange);
    // chatStreamSub = _service.subscribeToChats(onChatDataChange);
    super.initState();
  }

  testMyId() {
    trace('calling testMyId');
    _service.testMyId();
  }

  @override
  void dispose() {
    chatStreamSub.cancel();
    super.dispose();
  }

  /// Esto debe ir en un provider/helper/service o algo asi.
  Future<UserVo?> getUserInfo(String userId) async {
    final result =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!result.exists) {
      print("User $userId doesnt exists");
      return null;
    }
    return UserVo.fromJson(result.data()!);
  }

  Future<void> onChatDataChange(
    QuerySnapshot<Map<String, dynamic>> event,
  ) async {
    trace('data changed!');
    // final chatRooms = event.docs.map((e) => ChatRoomVo.fromDoc(e)).toList();
    final chatRooms =
        event.docs.map((e) => ChatRoomVo.fromJson(e.data())).toList();
    final myId = myUser!.uid;
    // dataItems.clear();
    dataItems = await _service.getUserChats(chatRooms);
    update();
    // dataItems.add(data);
    // trace("List len:", dataItems.length);
    return ;

    // final messagesResults = await (
    //     doc.reference
    //         .collection('messages')
    //         .where('receiverId', isEqualTo: widget.uid)
    //         .where('isRead', isEqualTo: false))
    //     .get();

    chatRooms.forEach((e) async {
      /// si nuestro user es parte del id.
      if (e.docId.contains(myId)) {
        // conseguimos el id del otro user
        final recieverId = e.getOtherUserId(myId);
        final reciever = await getUserInfo(recieverId);
        if (reciever == null) {
          print("gran problema... el otro usuario no puede no existir");
          return;
        }
        String subtitle = e.lastMessage ?? '';
        if (myId == e.senderId) {
          subtitle = 'Tu: $subtitle';
        }
        final data = ChatViewItemVo(
          receiver: reciever,
          title: reciever.textName,
          subtitle: subtitle,
          time: e.dateTimeStamp,
          imageUrl: reciever.profilePicture,
        );
        dataItems.add(data);

        /// refrescamos cada vez q conseguimos el user info.
        update();
      }
    });
  }

  /// Item on tap.
  void onItemTap(UserVo userModel) {
    trace("PUSH CHAT SCREEN 1");
    context.push(ChatScreen(user: userModel));
    // Navigator.of(context).pushNamed(
    //   ChatScreen.routeName,
    //   arguments: userModel,
    // );
  }
}
