import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

//Providers
import 'package:DaSell/provider/ad_provider.dart';
//Widgets
import 'package:DaSell/widgets/bottom_button.dart';
//Screens
import 'package:DaSell/screens/add/price_and_location_screen.dart';

import 'helpers/load_assets.dart';

class AddingImagesScreen extends StatefulWidget {

  static const routeName = './adding_images_screen';

  @override
  _AddingImagesScreenState createState() => _AddingImagesScreenState();
}

class _AddingImagesScreenState extends State<AddingImagesScreen> {

  File? _storedImage;
  File? _pickedImage;
  late BuildContext ctx;
  int current = 0;
  List<File> pathList = [];
  bool isCamera = true;
  List<Asset> images = <Asset>[];
  late String _error;
  var listt = [];


  Future<void> _takePicture() async {

    isCamera = true;

    final picker = new ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
          maxWidth:  600
    );


    //final picker = ImagePicker();

   /* final imageUri = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 70,
    ); */


    if ( pickedFile == null) {
      return;
    }

    setState(() {
      _storedImage = File( pickedFile.path );
      pathList.add( _storedImage! );
      listt = pathList;
    });

    //very important lines!
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    _pickedImage = savedImage;
  }

  void submitImage() {
    
    if (listt.isEmpty) {
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

    } else if (isCamera) {
        Provider.of<AdProvider>(context, listen: false).addImagePaths(pathList);
    } else {
        Provider.of<AdProvider>(context, listen: false).addImageAssets(images);
    }
        Navigator.of(context).pushNamed(PriceAndLocationScreen.routeName);
  }



  @override
  Widget build(BuildContext context) {

    ctx = context;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Añade imágenes del producto'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox( height: 50,),
                Container(
                  width: double.infinity,
                  height: 250,
                  child: listt.isEmpty
                      ? Center(
                          child: Text('No hay imágenes seleccionadas'),
                        )
                      : Stack(
                        children: [
                          CarouselSlider(
                            items: isCamera
                                ? pathList.map((e) {
                                    return Image.file(e);
                                  }).toList()
                                : List.generate(images.length, (index) {
                                    Asset asset = images[index];
                                    return AssetThumb(
                                      asset: asset,
                                      width: 20,
                                      height: 250,
                                    );
                                }
                                ),
                            options: CarouselOptions(
                              height: 400.0,
                              aspectRatio: 16/9,
                              viewportFraction: 0.5,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration( seconds: 15 ),
                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  current = index;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: isCamera
                                  ? pathList.map((url) {
                                      int index = pathList.indexOf(url);
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: current == index
                                              ? Theme.of(context)
                                                  .scaffoldBackgroundColor
                                              : Colors.grey,
                                        ),
                                      );
                                    }).toList()
                                  : images.map((url) {
                                      int index = images.indexOf(url);
                                      return Container(
                                        width: 80.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: current == index
                                              ? Theme.of(context)
                                                  .scaffoldBackgroundColor
                                              : Colors.grey,
                                        ),
                                      );
                                    }).toList(),
                            ),
                          )
                        ]),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox( width: 90, ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: listt.length < 6
                              ? _takePicture
                              : () => showDialog(
                                    context: ctx,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(' Puedes añadir un máximo de seis imágenes'),
                                        actions: [
                                          ElevatedButton(
                                            child: Text('Aceptar'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                          splashColor: Theme.of(context).primaryColor,
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width / 3 - 10,
                            color: Theme.of(context).cardColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _storedImage == null
                                    ? Text(
                                        'Cámara',
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      )
                                    : Text(       
                                        'Añadir otra imagen',
                                         textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: loadAssets,
                            splashColor: Theme.of(context).primaryColor,
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width / 3 - 10,
                              //width: MediaQuery.of(context).size.height / 3 - 10,
                              color: Theme.of(context).cardColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Galería',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Transform.rotate(
                          angle: math.pi / 12,
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber,
                            size: 35,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox( height: 30, ),
                            Text(
                              'Consejo',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Intenta subir más imágenes del producto, para que se pueda comprobar su estado, y tener más posibilidades de vender el artículo',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

         /* return Button(
        elevation: 2,
        highlightElevation: 5,
        color: Colors.blue,
        shape: StadiumBorder(),
        onPressed: this.onPressed,
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text( this.text , style: TextStyle( color: Colors.white, fontSize: 17 )),
          ),
        ),
    );*/
        ElevatedButton(  
          // shape: StadiumBorder(),
          child: Container(
          width: 60,
          height: 55,
          child: Center(
            child: Text('Siguiente',),
           //child: Text( this.text , style: TextStyle( color: Colors.white, fontSize: 17 )),
          ),
          ),
           // Icons.arrow_forward, 
          onPressed: submitImage,
        ),
        ],
      ),
    );
  }
}
