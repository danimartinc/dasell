import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;

void pickImage( BuildContext context, ImageSource src ) async {

  File? _storedImage;
  File? _pickedImage;
  bool isLoading = false;

    final picker = new ImagePicker();
    
    final XFile? pickedImageFile = await picker.pickImage(
        source: src,
        maxWidth: 600, 
        imageQuality: 70
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

    setState(() {
      isLoading = true;
    });

    await Provider.of<AdProvider>( context, listen: false )
        .uploadProfilePicture( _pickedImage! );

    setState(() {
      isLoading = false;
    });
}