import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../maps/helpers/widgets_to_marker.dart';
import '../maps/models/route_destination.dart';

class MoveMap extends ChangeNotifier {

  GoogleMapController? _mapController;
  LatLng? mapCenter;
  RouteDestination? destination;

  set controller( GoogleMapController c ) => _mapController = c;
  set center( LatLng c ) => mapCenter = c;

  Future<void> moveCamera( LatLng newLocation )  async {
    final cameraUpdate = await CameraUpdate.newLatLng( newLocation );
  }

  Polyline drawRoutePolyline() {
    
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.black,
      width: 5,
      points: destination!.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    print( 'TRAZA DESTINATION: ${ destination }');

    return myRoute;

    // double kms = destination.distance / 1000;
    // kms = (kms * 100).floorToDouble();
    // kms /= 100;
    //
    // int tripDuration = (destination.duration / 60).floorToDouble().toInt();
    //
    // // Custom Markers
    // // final startMaker = await getAssetImageMarker();
    // // final endMaker = await getNetworkImageMarker();
    //
    // final startMaker = await getStartCustomMarker( tripDuration, 'Su ubicación' );
    // final endMaker = await getEndCustomMarker( kms.toInt(), destination.endPlace.text );
    //
    // final startMarker = Marker(
    //   anchor: const Offset(0.1, 1),
    //   markerId: const MarkerId('start'),
    //   position: destination.points.first,
    //   icon: startMaker,
    //   // infoWindow: InfoWindow(
    //   //   title: 'Inicio',
    //   //   snippet: 'Kms: $kms, duration: $tripDuration',
    //   // )
    // );
    //
    // final endMarker = Marker(
    //   markerId: const MarkerId('end'),
    //   position: destination.points.last,
    //   icon: endMaker,
    //   // anchor: const Offset(0,0),
    //   // infoWindow: InfoWindow(
    //   //   title: destination.endPlace.text,
    //   //   snippet: destination.endPlace.placeName,
    //   // )
    // );
    //
    //
    //
    // final curretPolylines = Map<String, Polyline>.from( state.polylines );
    // curretPolylines['route'] = myRoute;
    //
    //
    // final currentMarkers = Map<String, Marker>.from( state.markers );
    // currentMarkers['start'] = startMarker;
    // currentMarkers['end'] = endMarker;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
  
}