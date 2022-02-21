import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:provider/provider.dart';

import '../../../provider/ad_provider.dart';

void pickImage(BuildContext context, ImageSource src, String? documentID,
    String? senderID, String? receiverID) async {
  File? _storedImage;
  File? _pickedImage;

  final picker = new ImagePicker();

  final XFile? pickedImageFile = await picker.pickImage(
    source: src,
    imageQuality: 100,
    maxWidth: 600,
  );

  if (pickedImageFile == null) {
    return;
  }

  _storedImage = File(pickedImageFile.path);

  //Parte importante
  final appDir = await pPath.getApplicationDocumentsDirectory();
  final fileName = path.basename(_storedImage.path);
  final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
  _pickedImage = savedImage;

  if (senderID!.compareTo(receiverID!) > 0) {
    documentID = receiverID + senderID;
  } else {
    documentID = senderID + receiverID;
  }

  await Provider.of<AdProvider>(context, listen: false).uploadImage(
    _pickedImage,
    documentID,
    senderID,
    receiverID,
  );
}
