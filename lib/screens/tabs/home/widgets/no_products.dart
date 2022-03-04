import 'package:DaSell/commons.dart';

class NoProducts extends StatelessWidget {
  
  final VoidCallback? onAddTap;

  const NoProducts({Key? key, this.onAddTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          kGap300,
          Text('No hay productos publicados', style: kNoProductsTextStyle),
          kGap20,
          Text('Todavía no se ha publicado un producto.'),
          Text('¡Sé el primero, y sube algo que quieras vender!'),
          kGap30,
          MaterialButton(
            // minWidth: width - 180,
            child: Text('Subir producto', style: kNoProductsWhiteStyle),
            color: Colors.indigo,
            //Redondeamos los bordes del botón
            shape: StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: onAddTap,
          ),
      ],
    ));
  }
}
