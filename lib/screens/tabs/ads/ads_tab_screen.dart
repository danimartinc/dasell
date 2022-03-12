import '../../../commons.dart';

//Screens
import '../../favs/my_ads_screen.dart';
import '../../favs/favorite_ads_screen.dart';
import '../../favs/my_sell_ads_screen.dart';

class AdsTabScreen extends StatefulWidget {

  @override
  _AdsTabScreenState createState() => _AdsTabScreenState();
}

class _AdsTabScreenState extends State<AdsTabScreen> {
  
  @override
  Widget build(BuildContext context) {

    final menuTabProviderIndex = Provider.of<TabMenuProvider>(context).index;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new AppBar(
          elevation: 5,
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                physics: BouncingScrollPhysics(),
                labelStyle: TextStyle(
                  fontSize: 17,
                ),
                tabs: [
                  //if( menuTabProviderIndex == 1 )           
                 Tab(
                    text: '   Publicados   ',
                  ),
                  //if( menuTabProviderIndex == 2 )       
                  Tab(
                    text: '  Favoritos  ',
                  ),
                  //if( menuTabProviderIndex == 3 )       
                  Tab(
                    text: '  Vendidos  ',
                  ),
                ],
                onTap: (index) =>
                    Provider.of<TabMenuProvider>(context, listen: false)
                        .setIndex(index)
                //selectedPageIndex = index;
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyAds(),
            FavoriteAdsScreen(),
            MySellAds()
          ],
        ),
      ),
    );
  }
}
