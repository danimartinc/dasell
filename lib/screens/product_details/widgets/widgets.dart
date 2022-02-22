import 'package:DaSell/commons.dart';
import 'package:DaSell/screens/add/maps_screen.dart';

/// SEPARA DE ACA LAS CLASSES SI QUERES Y FIJATE COMO LAS REUSAS.
/// sino deja todo junto.
///
class DialogMapScreen extends StatelessWidget {
  final double lat, lon;

  const DialogMapScreen({
    Key? key,
    this.lat = 0.0,
    this.lon = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMapScreen(
      placeLocation: AdLocation(
        latitude: lat,
        longitude: lon,
        address: '',
      ),
      isEditable: false,
    );
  }
}

class ProductCategoryButtons extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String>? onCategoryTap;

  const ProductCategoryButtons(
      {Key? key, required this.categories, this.onCategoryTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = categories.map((e) {
      return MaterialButton(
          child: Text(e, style: TextStyle(color: Colors.white)),
          color: Colors.indigo,
          shape: StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: () {
            onCategoryTap?.call(e);
          });
    }).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: child,
      ),
    );
  }
}

class ProductUserAvatar extends StatelessWidget {
  final String? imageUrl;

  const ProductUserAvatar({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl?.isNotEmpty == true) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: SvgPicture.asset('assets/images/boy.svg'),
      );
    }
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(imageUrl!),
    );
  }
}
