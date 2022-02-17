import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DaSell/screens/bottom_navigation.dart';
import 'package:DaSell/screens/tabs/add_product_screen.dart';

//Widgets
import 'package:DaSell/widgets/home/ad_item.dart';

class MyAds extends StatefulWidget {
  
  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    //Mediante MediaQuery, obtengo el ancho de pantalla disponible del dispositivo
    final width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: ( context, snapshot ) {

       /* if ( snapshot.hasData ) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }*/

        //Comprobamos que si tenemos información
        if ( snapshot.hasData ) {
        
          //Widget con la información  
          var documents = snapshot.data!.docs;

            if( snapshot.data!.docs.length == 0 ) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                    ),
                    Text(
                      'No tienes publicado ningún producto',
                      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18)  ),
                      SizedBox( height: 20,),
                      Text('Créenos, es muuucho mejor cuando vendes cosas.'),
                      Text('¡Sube algo que quieras vender!'),
                      SizedBox( height: 30, ),
                      MaterialButton(
                        minWidth: width - 180,
                        child: Text('Subir producto', style: TextStyle( color: Colors.white ) ),
                        color: Colors.indigo,
                        //Redondeamos los bordes del botón
                        shape: StadiumBorder(),
                        elevation: 0,
                        splashColor: Colors.transparent,
                        //Disparamos el método getCoordsStartAndDestination para confirmar el destino
                        onPressed: () => {
                          Navigator.of(context).pushNamed( AddProduct.routeName ),
                          //Navigator.of(context).pushNamed( BottomNavigationScreen.routeName ),
                        }
                      ),

                  ],

                ) 
              );
            }

            return Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: documents.length,
                itemBuilder: (context, i) {
                  return AdItem(
                    documents[i],
                    documents[i]['uid'] == uid,
                    uid,
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
            );
        } else {
           //CircularProgressIndicator(), permite indicar al usuario que se está cargando información 
          return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
        }

       
      },
    );
  }
}
