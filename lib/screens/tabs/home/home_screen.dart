import 'package:DaSell/commons.dart';
//Widgets
import 'package:DaSell/widgets/home/ad_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home_appbar.dart';
import 'home_state.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = './home_screen';

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends HomeScreenState {
  @override
  Widget build(BuildContext context) {
    //Mediante MediaQuery, obtengo el ancho de pantalla disponible del dispositivo
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: HomeAppBar(
        onFilterTap: onFilterTap,
        onSearchTap: onSearchTap,
        onSortTap: onSortTap,
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: () {
          Future.delayed(Duration(milliseconds: 100));
          setState(() {
            FirebaseFirestore.instance
                .collection('products')
                .orderBy('createdAt', descending: true)
                //.where('isSold', isEqualTo: false)
                .snapshots();
          });
          refreshController.refreshCompleted();
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
                  if (snapshot.hasData) {
                    //Widget con la información
                    final fcm = FirebaseMessaging.instance;

                    fcm.getToken().then((token) => FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update(
                          {'token': token},
                        ));

                    documents = snapshot.data!.docs;

                    prods = documents
                        .map<AdModel>(
                          (documents) => AdModel(
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
                          child: Column(
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Text('No hay productos publicados',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Todavía no se ha publicado un producto.'),
                          Text(
                              '¡Sé el primero, y sube algo que quieras vender!'),
                          SizedBox(
                            height: 30,
                          ),
                          MaterialButton(
                              minWidth: width - 180,
                              child: Text('Subir producto',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.indigo,
                              //Redondeamos los bordes del botón
                              shape: StadiumBorder(),
                              elevation: 0,
                              splashColor: Colors.transparent,
                              //Disparamos el método getCoordsStartAndDestination para confirmar el destino
                              onPressed: () => {
                                    //Navigator.of(context).pushNamed( AddProduct.routeName ),
                                    //Navigator.of(context).pushNamed( './add_product_screen' )
                                    Navigator.of(context).pushReplacementNamed(
                                        AddProduct.routeName),
                                  }),
                        ],
                      ));
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
                    return CommonProgress();
                  }
                },
              ),
      ),
    );
  }
}
