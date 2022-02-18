import 'package:DaSell/maps/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/pick_image.dart';

class BottomSheet extends StatefulWidget {

  final String? senderID;
  final String? receiverID;

  //Cosntructor
  BottomSheet({
    Key? key,
    this.senderID,
    this.receiverID,
  }) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {

  @override
  Widget build(BuildContext context) {

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
                        pickImage(
                          context,
                          ImageSource.camera,
                        );

                        Navigator.of(context).pop();
                      },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple,'Galería',
                    () {
                      pickImage(
                        context,
                        ImageSource.gallery,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, 'Ubicación',
                    () {
                      
                      Navigator.of(context).pushReplacementNamed( 
                        LoadingScreen.routeName, 
                        arguments: {
                          widget.senderID,
                          widget.receiverID,
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
