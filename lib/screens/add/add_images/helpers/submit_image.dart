import 'package:flutter/material.dart';



var list = [];
bool isCamera = true;

  void submitImage() {
    
    if ( list.isEmpty ) {
      
      showDialog(
        context: ctx,
        //Instrucción 
        builder: ( ctx ) {
          return AlertDialog(
          title: Text('No hay imágenes añadidas'),
          content: Text('Por favor, añada al menos una imagen'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Aceptar',
                style: TextStyle(
                  color: Theme.of(ctx).primaryColor,
                ),
              ),
            ),
          ],
          );
        }
      );

      return;

    } else if ( isCamera ) {
        Provider.of<AdProvider>(context, listen: false).addImagePaths(pathList);
    } else {
        Provider.of<AdProvider>(context, listen: false).addImageAssets(images);
    }
        Navigator.of(context).pushNamed(PriceAndLocationScreen.routeName);
  }

