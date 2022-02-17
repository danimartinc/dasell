import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DaSell/maps/blocs/blocs.dart';


class BtnCancelMonitoring extends StatelessWidget {

  const BtnCancelMonitoring({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MaterialButton(
        minWidth: size.width -120,
        child: const Text('Dejar de compartir', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w300 )),
        color: Colors.red,
        elevation: 0,
        height: 50,
        shape: const StadiumBorder(),
        onPressed: () async {
                
                  // TODO: Disparar dispose, cancelar seguimiento

             
                  
        },
      ),
    );
  }
}
