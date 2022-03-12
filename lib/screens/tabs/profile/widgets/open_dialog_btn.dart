import '../../../../commons.dart';

class OpenDialogsButton extends StatelessWidget {

  final VoidCallback onPressed;

  const OpenDialogsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Mediante MediaQuery, obtengo el ancho de pantalla disponible del dispositivo
    final width = MediaQuery.of(context).size.width;


    return MaterialButton(
            minWidth: width - 180,
            child: Text('Cerrar sesión', style: TextStyle( color: Colors.white ) ),
            color: Colors.indigo,
            //Redondeamos los bordes del botón
            shape: StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: onPressed
          );
    
    /*return ElevatedButton.icon(
      icon: Icon(
        Icons.logout,
      ),
      onPressed: onPressed,
      label: Text('Cerrar sesión'),
    );*/
  }
}