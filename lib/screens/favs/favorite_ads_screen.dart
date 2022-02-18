import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:DaSell/screens/bottom_navigation.dart';
import 'package:DaSell/screens/tabs/home/home_screen.dart';

//Widgets
import 'package:DaSell/widgets/home/ad_item.dart';

class FavoriteAdsScreen extends StatefulWidget {

  static const routeName = './favorite_ads_screen';
  
  @override
  _FavoriteAdsScreenState createState() => _FavoriteAdsScreenState();
}

class _FavoriteAdsScreenState extends State<FavoriteAdsScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build( BuildContext context ) {

    //Mediante MediaQuery, obtengo el ancho de pantalla disponible del dispositivo
    final width = MediaQuery.of(context).size.width;
     
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('isFav', isEqualTo: true )
          .snapshots(),
      builder: ( context, snapshot ) {

        if ( snapshot.connectionState == ConnectionState.waiting ) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var documents = snapshot.data!.docs;
        
        if ( documents.length == 0 ) {

          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Text(
                  'No hay productos añadidos como favoritos',
                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18)  
                ),
                SizedBox( height: 20,),
                Text('Productos que te gustan'),
                Text('Para guardar un producto, pulsa el icono de producto favorito'),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon( FontAwesomeIcons.heart ),
                    ],
                  ),
                ),
                SizedBox( height: 30, ),
                MaterialButton(
                  minWidth: width - 180,
                  child: Text('Buscar producto', style: TextStyle( color: Colors.white ) ),
                  color: Colors.indigo,
                  //Redondeamos los bordes del botón
                  shape: StadiumBorder(),
                  elevation: 0,
                  splashColor: Colors.transparent,
                  //Disparamos el método getCoordsStartAndDestination para confirmar el destino
                  onPressed: () => {
                    Navigator.of(context).pushNamed( BottomNavigationScreen.routeName ),
                  }
                ),
              ],
            ),
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
      },
    );
  }
}
