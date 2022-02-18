import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

//Data
import 'package:DaSell/data/categories.dart';

//Providers
import 'package:DaSell/provider/ad_provider.dart';

//Screens
import 'package:DaSell/screens/add/adding_images_screen.dart';
import 'package:DaSell/screens/add/further_cat.dart';
import 'package:DaSell/screens/tabs/add_product/add_product_screen.dart';

//Widgets
import 'package:DaSell/widgets/bottom_button.dart';

class BookInfoForm extends StatefulWidget {

  @override
  _BookInfoFormState createState() => _BookInfoFormState();
}

class _BookInfoFormState extends State<BookInfoForm> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  
  String title      = '';
  String desc       = '';
  //String author     = '';
  String _prevValue = '';

  Map<String?, String?> sliderValueMap = {
    '0': 'Lo ha dado todo',
    '25': 'En condiciones aceptables',
    '50': 'En buen estado',
    '75': 'Como nuevo',
    '100': 'Nuevo',
  };

  double? sliderValue = 50.0;
  //var textController = TextEditingController();
  var counterText = 0;
  var isLogin = true;
  bool makeShipments = true;

  void trySubmit() {

    final isValidate = _formKey.currentState!.validate();
    
    //to remove soft keyboard after submitting
    FocusScope.of(context).unfocus();
    
    if (isValidate) {

      _formKey.currentState!.save();

      Provider.of<AdProvider>(
        context,
        listen: false,
      ).addTitleAndStuff(
        title,
        desc,
        //author,
        sliderValueMap[ sliderValue!.toInt().toString() ],
        makeShipments
      );

      Navigator.of(context).pushNamed( AddingImagesScreen.routeName );
    }
  }

  Widget counter(
    BuildContext context, {
    int? currentLength,
    int? maxLength,
    required bool isFocused,
  }) {

    return Text(
      '$currentLength / $maxLength',
      style: TextStyle(
        color: Colors.grey,
      ),
      semanticsLabel: 'character count',
    );
  }

  @override
  Widget build(BuildContext context) {
    
    //final index = ModalRoute.of(context)!.settings.arguments as int?;

    final data = ModalRoute.of(context)!.settings.arguments as Map<String?, dynamic>;
    final indexCategory = data["indexCategory"];
    final indexFurther  = data["indexFurther"];
  
    final cats  = Categories.categories[indexCategory!];
    
    return ListView(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Añade información al producto que quieres publicar',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),
                      ),

                    SizedBox( height: 20 ,),
                    TextFormField(
                      key: ValueKey('title'),
                      validator: (value) {
                        if ( value!.length > 8 ) {
                          return null;
                        } else {
                          return 'El título debe contener más de 8 caracteres';
                        }
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      onSaved: (newValue) {
                        title = newValue!;
                      },
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    
                    TextFormField(
                      key: ValueKey('desc'),
                      onChanged: (value) {
                        if (_prevValue.length > value.length) {
                          setState(() {
                            counterText--;
                          });
                        } else {
                          setState(() {
                            counterText++;
                          });
                        }
                        _prevValue = value;
                      },
                      validator: (value) {
                        if (value!.length > 15) {
                          return null;
                        } else {
                          return 'La descripción debe contener al menos 20 caracteres';
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        counterText: '$counterText/600',
                        labelText: 'Descripción',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      onSaved: (newValue) {
                        desc = newValue!;
                      },
                      maxLength: 600,
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);

                           /* Navigator.of(context).pop(
                              AddProduct.routeName
                            );*/

                           /* Navigator.of(context).pushNamed(
                              AddProduct.routeName,
                            );*/
                          },
                          title: Text('Categoría'),
                          subtitle:
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon( cats['icon'] ),
                                  SizedBox( width: 30 ),
                                  Text(
                                    cats['category'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Text( ''),
                            trailing: Icon( Icons.chevron_right_rounded ),
                            // leading: Icon( iconMapping[icon], color: HexColor(color) ),
                        ),

                        ListTile(
                          onTap: () {

                             Navigator.of(context).pop(
                              AddProduct.routeName
                            );

                           /* Navigator.of(context).pushNamed(
                              FurtherCat.routeName,
                            );*/
                          },
                          title: Text('Subcategoría'),
                          subtitle:
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  SizedBox( width: 30 ),
                                  Text(
                                    cats['further'][indexFurther],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Text( ''),
                            trailing: Icon( Icons.chevron_right_rounded ),
                                // leading: Icon( iconMapping[icon], color: HexColor(color) ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Divider(),
                        ),
                      ],
                    ),



                   /* Padding(
                      padding: const EdgeInsets.all(16.0),
                        child: Row(
                              children: [
                                Text( 'Categoría:'),
                                Icon( cats['icon'] ),
                                SizedBox( width: 30 ),
                                Text( cats['category'] ),
                              ],
                        ),
                    ), */


                    Divider(),
                    /*Text( cats['further'][indexFurther] ),
                    Icon( cats['icon'] ),*/

                    SwitchListTile.adaptive(
                      title: Text(
                        'Hago envíos',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      subtitle: Text(
                        'Enviar te permite tener opción a vender más artículos. Dispones de servicio de recogida a domicilio',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      activeColor: Theme.of(context).primaryColor,
                      value: makeShipments,
                      onChanged: ( value ) {
                        setState(() {
                          makeShipments = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Indica el estado del producto',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                    Slider.adaptive(
                      value: sliderValue!,
                      min: 0,
                      max: 100,
                      divisions: 4,
                      label: sliderValueMap[ sliderValue!.toInt().toString() ],
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
       /* BottomButton(
          'Siguiente',
          trySubmit,
          Icons.arrow_forward,
        ),*/

        Padding(
          padding: const EdgeInsets.all(50.0),
          child: ElevatedButton(
               style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
               borderRadius: new BorderRadius.circular(30.0),
               ),),  
            //shape: StadiumBorder(),
            child: Container(
            width: 60,
            height: 55,
            child: Center(
              child: Text('Siguiente',),
             //child: Text( this.text , style: TextStyle( color: Colors.white, fontSize: 17 )),
            ),
            ),
             // Icons.arrow_forward, 
              onPressed: trySubmit,
            ),
        ),
      ],
    );
  }
}
