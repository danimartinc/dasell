import '../../commons.dart';

//Widgets
import 'package:DaSell/widgets/home/ad_item.dart';
import 'widgets/widgets.dart';



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

        if ( snapshot.hasData) {
          var documents = snapshot.data!.docs;
        
        if ( documents.length == 0 ) {
          return SearchAdssBtn(); 
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
    );
  }
}
