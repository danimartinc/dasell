import '../../../../commons.dart';

class DeleteUserBtn extends StatelessWidget {

  final VoidCallback onPressed;


  const DeleteUserBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    //Mediante MediaQuery, obtengo el ancho de pantalla disponible del dispositivo
    final width = MediaQuery.of(context).size.width;


    return MaterialButton(
      minWidth: width - 180,
      child: Text('Eliminar usuario', style: TextStyle( color: Colors.white ) ),
      color: Colors.indigo,
      //Redondeamos los bordes del botón
      shape: StadiumBorder(),
      elevation: 0,
      splashColor: Colors.transparent,
      onPressed: onPressed
    );
  }
}