import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

//Models
import 'package:DaSell/models/ad_location.dart';

class GoogleMapScreen extends StatefulWidget {
  
  final AdLocation? placeLocation;
  final bool isEditable;

  GoogleMapScreen({
    this.placeLocation,
    required this.isEditable,
  });

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  LatLng? pickedLocation;

  void _selectLocation( LatLng position ) {
    setState(() {
      //print("actualizando ubicacion");
      pickedLocation = position;
    });
  }

  Set<Marker> get getMarker {
    
    if ( pickedLocation == null) {
          return {
            Marker(
              markerId: MarkerId('id'),
              position: LatLng(
                widget.placeLocation!.latitude!,
                widget.placeLocation!.longitude!,
              ),
            )
          };
    } else {
      return {
        Marker(
          markerId: MarkerId('id'),
          position: pickedLocation!,
        )
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: widget.isEditable ? Text('Elegir localización') : Text('Ubicación actual'),
        actions: widget.isEditable && pickedLocation != null
            ? [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => Navigator.of(context).pop(pickedLocation),
                ),
              ]
            : [],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.placeLocation!.latitude!,
            widget.placeLocation!.longitude!,
          ),
          zoom: 16,
        ),
         //Tipo de mapa
        mapType: MapType.normal,
        //Punto que indica la posición actual del usuario
        myLocationEnabled: true,
        buildingsEnabled: true,
        indoorViewEnabled: true,
        onTap: widget.isEditable ? _selectLocation : null,
        markers: getMarker,
      ),
    );
  }
}

