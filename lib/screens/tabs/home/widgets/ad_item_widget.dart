import 'package:DaSell/commons.dart';
import 'package:DaSell/services/firebase/models/product_vo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdItemWidget extends StatelessWidget {
  final ResponseProductVo data;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;

  const AdItemWidget({
    Key? key,
    required this.data,
    this.onTap,
    this.onLikeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? headerButton;
    if (!data.isMe) {
      headerButton = LikeButton(
        onTap: onLikeTap,
        liked: data.getFav(),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: GridTile(
          child: Hero(
            tag: data.textId,
            child: CachedNetworkImage(
              imageUrl: data.itemImageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          header: headerButton,
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.54),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.textTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                if (data.getIsSold())
                  Text(
                    'Vendido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (!data.getIsSold())
                  Text(
                    data.textPrice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          data.getHasPrice() ? Colors.pink[200] : Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool liked;

  const LikeButton({Key? key, this.liked = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.fromLTRB(0, 6, 2, 0),
      alignment: Alignment.centerRight,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade900,
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 2.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 10  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ],
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: Colors.red[700],
          ),
        ),
      ),
    );
    // return IconButton(
    //   onPressed: onTap,
    //   icon: Icon(
    //     liked ? Icons.favorite : Icons.favorite_border,
    //     color: Colors.red[700],
    //   ),
    // );
  }
}
