import 'package:multi_image_picker2/multi_image_picker2.dart';


bool isCamera = true;
List<Asset> images = <Asset>[];

Future<void> loadAssets() async {

    List<Asset>? resultList;
    String? error;

    isCamera = false;

    
    setState(() {
      images = <Asset>[];
    });

  
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (resultList == null) return;

    setState(() {
      images = resultList!;
      listt = images;
      if (error == null) _error = 'No se ha detectado el error';
    });
  }