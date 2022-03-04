import '../../../commons.dart';
import 'maps_state.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';



class ProductGoogleMapScreen extends StatefulWidget {
  
  final AdLocation? placeLocation;
  final bool isEditable;

  ProductGoogleMapScreen({
    this.placeLocation,
    required this.isEditable,
  });

  @override
  createState() => _ProductGoogleMapScreenState();
}

class _ProductGoogleMapScreenState extends ProductGoogleMapState {

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
        onTap: widget.isEditable ? selectLocation : null,
        markers: getMarker,
      ),
    );
  }
}

