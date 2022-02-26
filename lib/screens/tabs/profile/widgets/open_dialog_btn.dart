import '../../../../commons.dart';

class OpenDialgosButton extends StatelessWidget {

  final VoidCallback onPressed;

  const OpenDialgosButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return ElevatedButton.icon(
      icon: Icon(
        Icons.logout,
      ),
      onPressed: onPressed,
      label: Text('Cerrar sesión'),
    );
  }
}