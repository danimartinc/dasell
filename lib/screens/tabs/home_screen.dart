import 'package:DaSell/data/categories.dart';
import 'package:DaSell/widgets/add/story_category_item.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//Widgets
import 'package:DaSell/widgets/home/ad_item.dart';
import 'package:DaSell/widgets/home/filter.dart';

//Screens
import 'package:DaSell/screens/home/search.dart';
import 'add_product_screen.dart';

//Providers
import 'package:DaSell/provider/ad_provider.dart';

//Models
import 'package:DaSell/models/ad_model.dart';
import 'package:DaSell/models/ad_location.dart';





class HomeScreen extends StatefulWidget {

   static const routeName = './home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  var cats = Categories.storedCategories;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<dynamic> documents = [];
  List<AdModel?> prods = [];
  bool isProd = false;
  double? distance;
  RangeValues range = RangeValues(0, 2000);

  Key? key;

  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance!.addObserver( this );
    setStatus("En línea");
  }

  void setStatus( String status ) async{

    await _firestore.collection('users').doc( uid ).update({
      'status': status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    
    if( state == AppLifecycleState.resumed ){
      //Online
      setStatus("En línea");
    }else if( state == AppLifecycleState.inactive ){
      //Offline
      setStatus("");
    }

    super.didChangeAppLifecycleState(state);
  }

  void setFilters( RangeValues rv ) {
    
    print('coming here set filters 2');
    print('start is ${rv.start}');

    setState(() {
      range = rv;
      prods = prods.where(
        (element) {
          print('element price is ${element!.price}');
          print('range start is ${range.start} and ${range.end}');
          return (element.price! >= range.start) && (element.price! <= range.end);
        },
      ).toList();
      isProd = true;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build( BuildContext context ) {

    //Mediante MediaQuery, obtengo el ancho de pantalla disponible del dispositivo
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('DaSell',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Billabong',
          fontSize: 28
        ),
        ),
        actions: [
          IconButton(
            icon: Icon( FontAwesomeIcons.funnelDollar,size: 19, ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Filter(
                      setFilters,
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.sort_outlined,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Ordenar por',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () async {

                        final location = Location();
                        print('coming here 111');
                        final locData = await location.getLocation();

                        print( 'locations is ${locData.latitude},${locData.longitude}');

                        for (int i = 0; i < prods.length; i++) {

                          prods[i]!.fromLoc = Provider.of<AdProvider>(context, listen: false)
                            .getDistanceFromCoordinates2(
                              prods[i]!.location!.latitude!,
                              prods[i]!.location!.longitude!,
                              locData.latitude!,
                              locData.longitude!,
                            );

                          print('distance is ${(prods[i]!.fromLoc)}');

                        }

                        prods.sort((m1, m2) {
                          return m1!.fromLoc!.compareTo( m2!.fromLoc! );
                        });

                        print(
                          prods.map(
                            (e) => print('La distancia final es ${e!.fromLoc}'),
                          ),
                        );

                        setState(() {
                          isProd = true;
                        });
                        
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        'Más cercano',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          isProd = false;
                        });
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        'Más recientes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.search,
              size: 19,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: Search( documents ),
            ),
          )
        ],
      ),
      body: /*Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Row(
                    children:  List.generate(
                      Categories.categories.length,
                      ( index ) {
                        return StoryCategoryItem(index: index, );
                      },
            
                    ),
              
              
      
                  
                  ),
                
                ],
              ),
            ),*/
            SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: () {
              // monitor network fetch
              Future.delayed(Duration(milliseconds: 100));
              // if failed,use refreshFailed()
          
              setState(() {
                FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('createdAt', descending: true)
                      //.where('isSold', isEqualTo: false)
                      .snapshots();
              });

              _refreshController.refreshCompleted();
            },
            header: WaterDropHeader(),
            child: isProd
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: prods.length,
                    itemBuilder: (context, i) {
                      dynamic document = {
                        'id': prods[i]!.id,
                        'title': prods[i]!.title,
                        //'author': prods[i]!.author,
                        'description': prods[i]!.description,
                        'price': prods[i]!.price,
                        'condition': prods[i]!.condition,
                        'images': prods[i]!.images,
                        'createdAt': prods[i]!.createdAt,
                        'categories': prods[i]!.categories,
                        'location': {
                          'latitude': prods[i]!.location!.latitude!,
                          'longitude': prods[i]!.location!.longitude!,
                          'address': prods[i]!.location!.address!,
                        },
                        'isFav': prods[i]!.isFav,
                        'isSold': prods[i]!.isSold,
                        'uid': prods[i]!.userId,
                      };

                      return AdItem(
                        document,
                        document['uid'] == uid,
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
              )
              : StreamBuilder<QuerySnapshot<Map<String?, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('createdAt', descending: true)
                      //.where('isSold', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {

                //Comprobamos que si tenemos información
                if ( snapshot.hasData ) {

                  //Widget con la información
                  final fcm = FirebaseMessaging.instance;

                      fcm.getToken().then((token) => FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .update(
                            {'token': token},
                          ));
                                      
                      documents = snapshot.data!.docs;

                      prods = documents.map<AdModel>( (documents) => AdModel(
                              id: documents['id'].toString(),
                              createdAt: documents['createdAt'],
                              price: documents['price'].toDouble(),
                              title: documents['title'],
                              //author: documents['author'],
                              categories: documents['categories'],
                              description: documents['description'],
                              images: documents['images'],
                              userId: documents['uid'],
                              location: AdLocation(
                                latitude: documents['location']['latitude'],
                                longitude: documents['location']['longitude'],
                                address: documents['location']['address'],
                              ),
                              condition: documents['condition'],
                              isSold: documents['isSold'],
                              isFav: documents['isFav'],
                              fromLoc: 0.0, 
                              fileImages: [], 
                              imageAssets: [],
                            ),
                          )
                          .toList();

                      if (snapshot.data!.docs.length == 0) {

                        return Center(
                          child:
                          Column(
                            children: [
                              SizedBox(
                                height: 300,
                              ),
                              Text(
                                'No hay productos publicados',
                                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18)  ),
                                SizedBox( height: 20,),
                                Text('Todavía no se ha publicado un producto.'),
                                Text('¡Sé el primero, y sube algo que quieras vender!'),
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
                                    //Navigator.of(context).pushNamed( AddProduct.routeName ),
                                    //Navigator.of(context).pushNamed( './add_product_screen' )
                                    Navigator.of(context).pushReplacementNamed( AddProduct.routeName ),
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
                  //CircularProgressIndicator(), permite indicar al usuario que se está cargando infromación 
                  return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
                }
    
                    
              },
              ),
          ),
        //],
        );
     // );

  }
}
