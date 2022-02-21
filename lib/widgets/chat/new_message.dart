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

import 'helpers/pick_image.dart';
import 'helpers/send_message.dart';
import 'widgets/emoji_select.dart';

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
  //TextEditingController _controller = TextEditingController();
  var enteredMessage = '';
  bool isLoading = false;
  var documentId = '';

  bool show = false;
  FocusNode focusNode = FocusNode();

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

                                  if (value.isEmpty) {
                                    // Inhabilita
                                    setState(() {
                                      enteredMessage = value;
                                    });
                                  } else {
                                    if (value.isNotEmpty) {
                                      // Habilita
                                      setState(() {
                                        enteredMessage = value;
                                      });
                                    } else {
                                      enteredMessage = value;
                                    }
                                  }

                                  /*setState(() {
                                    enteredMessage = value;
                                  });*/
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
                                      builder: (builder) => Container(),
                                      /// TODO: ROTO
                                      /// BottomSheet()
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
                          onPressed: () { 
                            enteredMessage.isEmpty ? null : sendMessage;

                              setState(() {
                                enteredMessage = '';
                              }); 
                          }
                        ),
                      ),
                    ],
                  ), 
                ),
                show ? SizedBox(
                  child: EmojiSelect(),
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

}