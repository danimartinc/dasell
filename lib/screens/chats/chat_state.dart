import 'dart:async';

import 'package:DaSell/commons.dart';

import 'chat_screen.dart';

abstract class ChatScreenState extends State<ChatScreen> {
  late UserVo otherUser = widget.user;

  late final _service = FirebaseService.get();
  late StreamSubscription userSubscription;

  UserVo get myUser => _service.myUserVo!;

  String docId = '';

  String get uid => _service.uid;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    userSubscription.cancel();
    super.dispose();
  }

  void onBackTap() {
    context.pop();
  }

  void _loadData() {
    userSubscription = _service.subscribeToUser(otherUser.uid, onUserDataChange);
    docId = _service.getChatDocId(otherUser);
  }

  void onUserDataChange(DocumentSnapshot<Map<String, dynamic>> event) {
    otherUser = UserVo.fromJson(event);
    update();
  }
}
