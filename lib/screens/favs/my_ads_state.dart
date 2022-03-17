import '../../commons.dart';
import '../../services/firebase/models/product_vo.dart';
import '../product_details/product_details.dart';
import 'favorite_ads_screen.dart';

abstract class MyAdsScreenState extends State<FavoriteAdsScreen> {

   List<ResponseProductVo> currentProducts = [];

    void onItemTap(ResponseProductVo vo) {
    context.push(ProductDetails(
      data: vo,
    ));
    // Navigator.of(context).pushNamed(
    //   ProductDetailScreen.routeName,
    //   arguments: {
    //     'docs': vo,
    //     'isMe': vo.isMe,
    //   },
    // );
  }

   void onItemLike(ResponseProductVo vo) {
    vo.toggleLike();
  }

 }