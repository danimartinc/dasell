import 'package:DaSell/commons.dart';

class ActionButtonMoreOptions extends StatelessWidget {

  final VoidCallback? onDelete, onSell;

  const ActionButtonMoreOptions({
    Key? key,
    this.onDelete,
    this.onSell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('Eliminar publicación'),
          value: 'delete',
        ),
        PopupMenuItem(
          child: Text('Marcar artículo como vendido'),
          value: 'sell',
        )
      ],
      onSelected: (value) {
        if (value == 'delete') {
          onDelete?.call();
        } else if (value == 'sell') {
          onSell?.call();
        }
      },
    );
  }
}
