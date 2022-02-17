import 'package:DaSell/maps/screens/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DaSell/maps/blocs/blocs.dart';
import 'package:DaSell/maps/ui/ui.dart';



class BtnShared extends StatefulWidget {
  
  const BtnShared({Key? key}) : super(key: key);

  @override
  State<BtnShared> createState() => _BtnSharedState();
}
/*
class OrdersBloc {

  Future<List<OrdersModel>> getOrders() async {
    try {
      WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
        url: urlWC,
        consumerKey: consumerKeyWC,
        consumerSecret: consumerSecretWC,
      );

      List<OrdersModel> ordersList = [];
      var listOrders = await wooCommerceAPI.getAsync(statusProcessing);

      for (var item in listOrders) {
        ordersList.add(OrdersModel.fromJson(item));
      }

      return ordersList;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
*/

class _BtnSharedState extends State<BtnShared> {

  LocationBloc? locationBloc;
  MapBloc? mapBloc;

  @override
  void initState() {
    locationBloc = BlocProvider.of<LocationBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   

    

    return Container(
      margin: const EdgeInsets.only( bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: const Icon( Icons.share_location, color: Colors.black ),
          onPressed: () async {

            print("click on btn_shared");
            locationBloc?.startSharing();
            final ts = Timestamp.now();

            String documentId = "";

            if (locationBloc!.sender.compareTo( locationBloc!.receiver ) > 0) {

              documentId = locationBloc!.receiver + locationBloc!.sender;
            } else {

              documentId = locationBloc!.sender + locationBloc!.receiver;
            }

            mapBloc?.state.markers;

            await FirebaseFirestore.instance
                .collection('chats')
                .doc(documentId)
                .collection('messages')
                .add(
                {
                  'message': "Ubicación",
                  'imageUrl': '', 
                  'senderId': locationBloc?.sender,
                  'receiverId': locationBloc?.receiver,
                  'timeStamp': ts,
                }
            );

            await FirebaseFirestore.instance
                .collection('chats')
                .doc(documentId)
                .set(
                  {
                    'docId': documentId,
                    'lastMessage': 'Ubicación',
                    'senderId': locationBloc?.sender,
                    'timeStamp': ts,
                  },
                );

            await FirebaseFirestore.instance
                .collection('markers')
                .doc(documentId)
                .set({
                  "latStart" : mapBloc?.state.markers["start"]?.position.latitude,
                  "lngStart" : mapBloc?.state.markers["start"]?.position.longitude,
                  "latEnd"   : mapBloc?.state.markers["end"]?.position.latitude,
                  "lngEnd"   : mapBloc?.state.markers["end"]?.position.longitude,
                }, SetOptions(merge: true));

          /*StreamBuilder(
           stream: MapBloc().locationBloc,
            builder: ( BuildContext context, AsyncSnapshot snapshot ) {
            
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 10),
                  itemCount: snapshot.data != null ? snapshot.data.length : 0,
                  itemBuilder: ( BuildContext context, int index ) {

                  

                    Navigator.pushNamed( context, MapScreen.routeName, arguments: {
                          'location': widget.initialLocation,
                          'polylines': widget.polylines.values.toSet(), 
                          'markers': mapState.markers.values.toSet(),
                      } 
                      );

      

          }
        ),
      ),*/
        }
    ),
      ),
    );

  }
}