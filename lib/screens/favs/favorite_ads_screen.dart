import 'package:DaSell/screens/favs/my_ads_state.dart';

import '../../commons.dart';

//Widgets
import 'package:DaSell/widgets/home/ad_item.dart';
import '../tabs/home/widgets/ad_item_widget.dart';
import 'widgets/widgets.dart';



class FavoriteAdsScreen extends StatefulWidget {

  static const routeName = './favorite_ads_screen';
  
  @override
  _FavoriteAdsScreenState createState() => _FavoriteAdsScreenState();
}

class _FavoriteAdsScreenState extends MyAdsScreenState {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;

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

        if (isLoading) {
          return CommonProgress();
        }
        
        if (currentProducts.isEmpty) {
          return SearchAdsBtn(); 
        }

       /* if ( snapshot.hasData) {
          var documents = snapshot.data!.docs;
        
        if ( documents.length == 0 ) {
          return SearchAdsBtn(); 
        }*/

        return Padding(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: currentProducts.length,
            itemBuilder: (context, i) {

              final vo = currentProducts[i];
              return AdItemWidget(
                data: vo,
                onTap: () => onItemTap(vo),
                onLikeTap: () => onItemLike(vo),
              );

              //TODO: Widget anterior
              /*return AdItem(
                documents[i],
                documents[i]['uid'] == uid,
                uid,
              );*/
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
