import 'package:DaSell/live-map/map_view.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:DaSell/maps/screens/screens.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

//Providers
import 'package:DaSell/provider/ad_provider.dart';

class NewMessage extends StatefulWidget {

  final String documentId;
  final String senderId;
  final String receiverId;
  final AnimationController? animationController;

  //Constructor
  NewMessage({
    required this.documentId,
    required this.senderId,
    required this.receiverId,
    this.animationController
  });
  
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  TextEditingController messageController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  var enteredMessage = '';
  late BuildContext ctx;
  File? _storedImage;
  File? _pickedImage;
  bool isLoading = false;
  var documentId = '';

  bool show = false;
  FocusNode focusNode = FocusNode();



  void _pickImage(BuildContext context, ImageSource src) async {

    final picker = new ImagePicker();

    final XFile? pickedImageFile = await picker.pickImage(
          source: src,
          imageQuality: 100,
          maxWidth:  600,
    );

    if (pickedImageFile == null) {
      return;
    }

    _storedImage = File(pickedImageFile.path);

    //Parte importante
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    _pickedImage = savedImage;

    if (widget.senderId.compareTo(widget.receiverId) > 0) {

      documentId = widget.receiverId + widget.senderId;
    } else {

      documentId = widget.senderId + widget.receiverId;
    }

    await Provider.of<AdProvider>(context, listen: false).uploadImage(
      _pickedImage!,
      documentId,
      widget.senderId,
      widget.receiverId,
    );
  }

  void _sendMessage() async {

    //FocusScope.of(context).unfocus();
    final ts = Timestamp.now();

    messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.documentId)
        .collection('messages')
        .add(
          {
            'message': enteredMessage,
            'imageUrl': '',
            'senderId': widget.senderId,
            'receiverId': widget.receiverId,
            'timeStamp': ts,
            'isRead': false,
          }
        );
    
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.documentId)
        .set(
          {
            'docId': widget.documentId,
            'lastMessage': enteredMessage,
            'senderId': widget.senderId,
            'timeStamp': ts,
            'isRead': false,
          },
        );
  }


  
  @override
  void initState() {

    super.initState();
    
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    ctx = context;
  
    return Container(
      child: WillPopScope(
        child: Stack(
          children: [ 
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                          right: 10,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            //background color of box
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 25.0, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: Offset(
                                -15.0, // Move to right 10  horizontally
                                15.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                focusNode: focusNode,
                                controller: messageController,
                                keyboardType: TextInputType.multiline,
                                textAlignVertical: TextAlignVertical.center,
                                maxLines: 5,
                                minLines: 1,
                                onChanged: (value) {
                                  setState(() {
                                    enteredMessage = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Mensaje',   
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      show
                                        ? Icons.keyboard
                                        : Icons.emoji_emotions_outlined,
                                    ),
                                    onPressed: () {
                                        
                                      if (!show) {
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                      }
                                        
                                      setState(() {
                                        show = !show;
                                      });
          
                                    },
                                  ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.attach_file),
                                  onPressed: () {
                                        
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (builder) =>
                                        bottomSheet()   
                                    );            
                                  },
                                                     
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: enteredMessage.isEmpty
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: enteredMessage.isEmpty ? null : _sendMessage,
                        ),
                      ),
                    ],
                  ), 
                ),
                show ? SizedBox(
                  child: emojiSelect(),
                  height: 250,
                ) : Container(),          
            ],
          ),
          ]
        ), onWillPop: () {

          if (show) {
            
            setState(() {
              show = false;
            });
          } else {
            Navigator.pop(context);
          }
          
          return Future.value(false);
        },
                      
      ),
    );
     
  }

   Widget bottomSheet() {

    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.camera_alt, Colors.pink, 'Cámara', 
                      () {
                        _pickImage(
                          ctx,
                          ImageSource.camera,
                        );
                        Navigator.of(ctx).pop();
                      },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple,'Galería',
                    () {
                      _pickImage(
                        ctx,
                        ImageSource.gallery,
                      );
                      Navigator.of(ctx).pop();
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, 'Ubicación',
                    () {
                      
                      Navigator.of(context).pushReplacementNamed( LoadingScreen.routeName, 
                        arguments: {
                          widget.senderId,
                          widget.receiverId,
                        }
                      );
                      
                      //Navigator.of(context).pushReplacementNamed( LoadingScreen.routeName );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation( IconData icons, Color color, String text, Function function ) {
    
    return InkWell(
      onTap: () => function(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

 Widget emojiSelect() {

    return EmojiPicker(
    config: Config(
      columns: 7,
      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
      verticalSpacing: 0,
      horizontalSpacing: 0,
      initCategory: Category.RECENT,
      bgColor: const Color(0xFFF2F2F2),
      indicatorColor: Colors.blue,
      iconColor: Colors.grey,
      iconColorSelected: Colors.blue,
      progressIndicatorColor: Colors.blue,
      backspaceColor: Colors.blue,
      showRecentsTab: true,
      recentsLimit: 28,
      noRecentsText: 'No Recientes',
      noRecentsStyle: const TextStyle(
        fontSize: 20, color: Colors.black26
      ),
      tabIndicatorAnimDuration: kTabScrollDuration,
      categoryIcons: const CategoryIcons(),
      buttonMode: ButtonMode.MATERIAL
    ),          
    onEmojiSelected: (category, emoji ) {
        
      print(emoji);

      setState(() {
         messageController.text = messageController.text + emoji.emoji;
      });
      }
    );
  }

}