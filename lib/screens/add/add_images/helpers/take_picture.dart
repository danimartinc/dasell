import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;

bool isCamera = true;
var list = [];
File? _storedImage;
File? _pickedImage;
List<File> pathList = [];

Future<void> takePicture() async {
  /// TODO: ROTO
  // isCamera = true;
  //
  // final picker = new ImagePicker();
  // final XFile? pickedFile = await picker.pickImage(
  //     source: ImageSource.camera, imageQuality: 100, maxWidth: 600);
  //
  // if (pickedFile == null) {
  //   return;
  // }
  //
  // setState(() {
  //   _storedImage = File(pickedFile.path);
  //   pathList.add(_storedImage!);
  //   list = pathList;
  // });
  //
  // //Muy importante
  // final appDir = await pPath.getApplicationDocumentsDirectory();
  // final fileName = path.basename(_storedImage!.path);
  // final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
  // _pickedImage = savedImage;
}
