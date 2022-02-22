import 'package:DaSell/commons.dart';

class NoProducts extends StatelessWidget {
  final VoidCallback? onAddTap;

  const NoProducts({Key? key, this.onAddTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Gap(300),
        Text('No hay productos publicados', style: kNoProductsTextStyle),
        const Gap(20),
        Text('Todavía no se ha publicado un producto.'),
        Text('¡Sé el primero, y sube algo que quieras vender!'),
        const Gap(30),
        MaterialButton(
          // minWidth: width - 180,
          child: Text('Subir producto', style: kNoProductsWhiteStyle),
          color: Colors.indigo,
          //Redondeamos los bordes del botón
          shape: StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          //Disparamos el método getCoordsStartAndDestination para confirmar el destino
          onPressed: onAddTap,
        ),
      ],
    ));
  }
}
