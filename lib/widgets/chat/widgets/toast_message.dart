import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage extends StatefulWidget {

  ToastMessage({Key? key}) : super(key: key);

  @override
  State<ToastMessage> createState() => _ToastMessageState();
}

class _ToastMessageState extends State<ToastMessage> {

  final toast = FToast();

  @override
  void initState() {
    toast.init(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

  //Custom Toast
  return Container(
    padding: EdgeInsets.symmetric( horizontal: 20, vertical: 12 ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon( Icons.check, color: Colors.black87, ),
        SizedBox( width: 12.0, ),
        Text(
          'Ubicación compartida',
          style: TextStyle( color: Colors.black, fontSize: 22 ),
        )
      ],
    ),
  );
  }

  void showBottomToast() => toast.showToast(
    child: ToastMessage(),
    gravity: ToastGravity.BOTTOM,
  );

  void showTopToast() => toast.showToast(
    child: ToastMessage(),
    //gravity: ToastGravity.TOP,
    //Custom Position
    positionedToastBuilder: ( context, child ) =>
    Positioned( child: child, top: 150, left: 0,right: 0,)
  );

  void showToast() => Fluttertoast.showToast(
    msg: 'Ubicación compartida',
    fontSize: 18,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );

  void cancelToast() => Fluttertoast.cancel();
}


 