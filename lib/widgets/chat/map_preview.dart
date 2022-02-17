
import 'package:DaSell/maps/models/route_destination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../maps/blocs/search/search_bloc.dart';
import '../../provider/move_map_provider.dart';


class MapPreview extends StatefulWidget {

  final bool isMe;
  final DateTime time;
  final String documentId;
  final bool fullScreen;
  
  final LatLng? initialLocation;

  MapPreview({
    required this.isMe,
    required this.time,
    required this.documentId,
    this.fullScreen = false,
    this.initialLocation
  });

  @override
  State<StatefulWidget> createState() => _MapPreviewState();

}

class _MapPreviewState extends State<MapPreview> {

  final toast = FToast();

  @override
  void initState() {

    super.initState();
    _requestPermission();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final MoveMap _provider = Provider.of<MoveMap>(context);

    return widget.fullScreen ?
        Scaffold(
          body: StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('location').doc( widget.documentId ).snapshots(),
              builder: ( context, snapshot ){

                if(snapshot.hasData) {
                  print("final map en =${snapshot.data!['latitude']}, ${snapshot.data!['longitude']}");
                  return dataText2(
                      CameraPosition(
                          target: LatLng(snapshot.data!['latitude'],snapshot.data!['longitude']),
                          zoom: 16
                      ),
                      _provider
                  );
                }else {
                  return dataText(CameraPosition(
                      target: LatLng(25.7830661, -100.3131327),//LatLng(40.0,-40.0),
                      zoom: 15
                  ));
                }

              }

          ),
        )
    : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * (2 / 3),
            minWidth: MediaQuery.of(context).size.width * (1 / 4),
            maxHeight: MediaQuery.of(context).size.height * (1 / 4),
          ),
          decoration: widget.isMe
              ? BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.zero,
            ),
            color: Theme.of(context).cardColor,
          )
              : BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
          child: Column(
            crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _firestore.collection('markers').doc( widget.documentId ).snapshots(),
                  builder: ( context, snapshot ) {
                    if(snapshot.hasData) {
                      print("[${snapshot.data!['latStart']},${snapshot.data!['latStart']}] -> [${snapshot.data!['lngEnd']},${snapshot.data!['lngEnd']}]");
                      final searchBloc = BlocProvider.of<SearchBloc>(context);
                      final LatLng start = LatLng(snapshot.data!['latStart'], snapshot.data!['lngStart']);
                      final LatLng end = LatLng(snapshot.data!['latEnd'], snapshot.data!['lngEnd']);
                      //final destination = await searchBloc.getCoorsStartToEnd(start, end);
                      return FutureBuilder<RouteDestination>(
                        future: searchBloc.getCoorsStartToEnd(start, end),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            _provider.destination = snapshot.data;
                            return StreamBuilder<DocumentSnapshot>(
                                stream: _firestore.collection('location').doc(
                                    widget.documentId).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    print("final map en =${snapshot
                                        .data!['latitude']}, ${snapshot
                                        .data!['longitude']}");
                                    return dataText2(
                                        CameraPosition(
                                            target: LatLng(snapshot.data!['latitude'],
                                                snapshot.data!['longitude']),
                                            zoom: 16
                                        ),
                                        _provider
                                    );
                                  } else {
                                    return dataText(CameraPosition(
                                        target: LatLng(25.7830661, -100.3131327),
                                        //LatLng(40.0,-40.0),
                                        zoom: 15
                                    ));
                                  }
                                }

                            );
                          }
                          return Text("Cargando");
                        }
                      );

                    }
                    return dataText(CameraPosition(
                        target: LatLng(25.7830661, -100.3131327),
                        //LatLng(40.0,-40.0),
                        zoom: 15
                    ));
                  }),
              ),
              Container(
                margin: widget.isMe
                    ? EdgeInsets.fromLTRB(0, 0, 5, 5)
                    : EdgeInsets.fromLTRB(5, 0, 0, 5),
                child: Text(
                  DateFormat('HH:mm').format(widget.time),
                  style: TextStyle(
                    color: widget.isMe ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//TODO: Boton cancelar seguimiento

  Widget dataText(CameraPosition position) {

    return Text(
      "esperando",
      textAlign: TextAlign.start,
      style: widget.isMe
          ? Theme.of(context).textTheme.subtitle2!.copyWith(
        fontFamily: 'Poppins',
        fontSize: 14,
      )
      : TextStyle(
        color:
        Theme.of(context).scaffoldBackgroundColor,
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );
  }

  Widget dataText2(CameraPosition position, MoveMap provider ) {

    print("Map con pos=${position.target.latitude}, ${position.target.longitude}");
    provider.moveCamera(position.target);

    return SizedBox(
      height: widget.fullScreen ? double.infinity : MediaQuery.of(context).size.height * (1 / 5),
      child: new GoogleMap(
          initialCameraPosition: position,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: widget.fullScreen ? true : false,
          scrollGesturesEnabled: widget.fullScreen ? true : false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: true,
          polylines: widget.fullScreen ? {provider.drawRoutePolyline()} : const {},
          markers: [
            Marker(
            anchor: const Offset(0.1, 1),
            markerId: const MarkerId('start'),
            position: position.target,
            //icon: startMaker, 
            // infoWindow: InfoWindow(
            //   title: 'Inicio',
            //   snippet: 'Kms: $kms, duration: $tripDuration',
            // )
          )].toSet(),
            onMapCreated: ( controller ) => provider.controller = controller,
            onCameraMove: ( position2 ) => provider.center = position2.target
      
      ),
    
    );

  }

/*
    @override
  void dispose() {
    if (canRemoveData) provider.clearData();
    super.dispose();
  }
*/

    _requestPermission() async {

    var status = await Permission.location.request();
    
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void showBottomToast() => toast.showToast(
    child: buildToast(),
    gravity: ToastGravity.BOTTOM,
  );

  void showTopToast() => toast.showToast(
    child: buildToast(),
    //gravity: ToastGravity.TOP,
    //Custom Position
    positionedToastBuilder: ( context, child ) =>
    Positioned( child: child, top: 150, left: 0,right: 0,)
  );

  void showToast() => Fluttertoast.showToast(
    msg: 'Ubicación compartida',
    fontSize: 18,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );

  void cancelToast() => Fluttertoast.cancel();

  //Custom Toast
  Widget buildToast() => Container(
    padding: EdgeInsets.symmetric( horizontal: 20, vertical: 12 ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon( Icons.check, color: Colors.black87, ),
        SizedBox( width: 12.0, ),
        Text(
          'Ubicación compartida',
          style: TextStyle( color: Colors.black, fontSize: 22 ),
        )
      ],
    ),
  );

  
}
