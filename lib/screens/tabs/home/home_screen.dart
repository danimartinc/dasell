import 'package:DaSell/commons.dart';
import 'package:DaSell/screens/tabs/home/widgets/ad_item_widget.dart';

import 'home_appbar.dart';
import 'home_state.dart';
import 'widgets/no_products.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = './home_screen';

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends HomeScreenState {
  //// new build
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        onFilterTap: onFilterTap,
        onSearchTap: onSearchTap,
        onSortTap: onSortTap,
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: onRefreshPullDown,
        header: WaterDropHeader(),
        child: getContent(),
      ),
    );
  }

  Widget getContent() {
    if (isLoading) {
      return CommonProgress();
    }
    if (currentProducts.isEmpty) {
      return NoProducts(onAddTap: onAddTap);
    }
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: currentProducts.length,
      itemBuilder: (context, i) {
        final vo = currentProducts[i];
        return AdItemWidget(
          data: vo,
          onTap: () => onItemTap(vo),
          onLikeTap: () => onItemLike(vo),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }
}
