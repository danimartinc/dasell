import 'package:DaSell/commons.dart';
import 'package:DaSell/data/categories.dart';
import 'package:DaSell/provider/ad_provider.dart';
import 'package:DaSell/screens/home/product_detail_screen.dart';
import 'package:DaSell/screens/home/search.dart';
import 'package:DaSell/screens/product_details/product_details.dart';
import 'package:DaSell/screens/tabs/home/widgets/sort_dialog.dart';
import 'package:DaSell/services/firebase/models/product_vo.dart';
import 'package:DaSell/widgets/home/filter.dart';
import 'package:location/location.dart';

abstract class HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver {
  final refreshController = RefreshController(initialRefresh: false);
  var cats = Categories.storedCategories;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;

  List<dynamic> documents = [];
  List<AdModel?> prods = [];
  var priceRange = RangeValues(0, 2000);
  final _firebaseService = FirebaseService.get();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _firebaseService.updateUserToken();
    _firebaseService.setUserOnline(true);
    _loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //Online
      _firebaseService.setUserOnline(true);
    } else if (state == AppLifecycleState.inactive) {
      //Offline
      _firebaseService.setUserOnline(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  void onPriceRangeChanged(RangeValues rv) {
    priceRange = rv;
    currentProducts = _allProducts.where(
      (product) {
        var price = product.price ?? 0;
        return (price >= priceRange.start) && (price <= priceRange.end);
      },
    ).toList();
    update();
  }

  void onFilterTap() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FilterPriceDialog(
            onRangeSelected: onPriceRangeChanged,
            initialValue: priceRange,
          ),
        );
      },
    );
  }

  void onSearchTap() {
    showSearch(
      context: context,
      delegate: Search(documents),
    );
  }

  void onSortTap() {
    showDialog(
      context: context,
      builder: (context) => SortDialog(onSelect: onSortSelected),
    );
  }

  void onSortSelected(int option) {
    if (option == 1) {
      /// cercanos
      sortByClosest();
    } else {
      /// recientes
      sortByNewest();
    }
  }

  void sortByNewest() {
    currentProducts.sort((a, b) {
      return a.createdAt!.compareTo(b.createdAt!);
    });
    update();
  }

  void sortByClosest() async {
    final location = Location();
    final locData = await location.getLocation();
    print('locations is ${locData.latitude},${locData.longitude}');
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    for (int i = 0; i < currentProducts.length; i++) {
      final vo = currentProducts[i];
      vo.fromLoc = adProvider.getDistanceFromCoordinates2(
        vo.location!.latitude!,
        vo.location!.longitude!,
        locData.latitude!,
        locData.longitude!,
      );
    }
    currentProducts.sort((m1, m2) => m1.fromLoc.compareTo(m2.fromLoc));
    update();
  }

  List<ResponseProductVo> _allProducts = [];
  List<ResponseProductVo> currentProducts = [];
  bool isLoading = false;

  Future<void> _loadData() async {
    currentProducts.clear();
    _allProducts.clear();
    isLoading = true;
    update();
    final products = await _firebaseService.getProducts();
    if (products == null) {
      trace('Error cargando productos.');
    } else {
      _allProducts.addAll(products);
    }
    currentProducts = List.from(_allProducts);
    isLoading = false;
    update();
  }

  Future<void> onRefreshPullDown() async {
    await Future.delayed(Duration(milliseconds: 100));
    await _loadData();
    refreshController.refreshCompleted();
  }

  void onItemTap(ResponseProductVo vo) {
    context.push(ProductDetails(data: vo,));
    // Navigator.of(context).pushNamed(
    //   ProductDetailScreen.routeName,
    //   arguments: {
    //     'docs': vo,
    //     'isMe': vo.isMe,
    //   },
    // );
  }

  void onItemLike(ResponseProductVo vo) {
    FirebaseService.get().setLikeProduct(vo.id!, !vo.getFav());
  }

  void onAddTap() {
    context.pushReplacementNamed(AddProduct.routeName);
    // () => {
// //Navigator.of(context).pushNamed( AddProduct.routeName ),
// //Navigator.of(context).pushNamed( './add_product_screen' )
// Navigator.of(context)
//     .pushReplacementNamed(AddProduct.routeName),
// }
  }
}
