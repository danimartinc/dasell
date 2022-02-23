import 'dart:async';

import 'package:DaSell/commons.dart';

import 'chat_screen.dart';

abstract class ChatScreenState extends State<ChatScreen> {
  late UserVo userData = widget.user;

  late final _service = FirebaseService.get();
  late StreamSubscription userSubscription;

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
    userSubscription = _service.subscribeToUser(userData.uid, onUserDataChange);
    docId = _service.getChatDocId(userData);
  }

  void onUserDataChange(DocumentSnapshot<Map<String, dynamic>> event) {
    userData = UserVo.fromJson(event);
    update();
  }
}
