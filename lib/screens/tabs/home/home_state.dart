import 'package:DaSell/commons.dart';
import 'package:DaSell/data/categories.dart';
import 'package:DaSell/provider/ad_provider.dart';
import 'package:DaSell/screens/home/search.dart';
import 'package:DaSell/screens/tabs/home/widgets/sort_dialog.dart';
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
  bool isProd = true;
  double? distance;
  RangeValues range = RangeValues(0, 2000);

  final _firebaseService = FirebaseService.get();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _firebaseService.setUserOnline(true);
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

  void setFilters(RangeValues rv) {
    print('coming here set filters 2');
    print('start is ${rv.start}');
    setState(() {
      range = rv;
      prods = prods.where(
        (element) {
          print('element price is ${element!.price}');
          print('range start is ${range.start} and ${range.end}');
          return (element.price! >= range.start) &&
              (element.price! <= range.end);
        },
      ).toList();
      isProd = true;
    });

    Navigator.of(context).pop();
  }

  void onFilterTap() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Filter(setFilters),
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
      builder: (context) => SortDialog(
        onSelect: onSortSelected,
      ),
    );
  }

  void onSortSelected(int option) {
    if (option == 1) {
      /// cercanos
      sortByClosest();
    } else {
      /// recientes
      setState(() {
        isProd = false;
      });
    }
  }

  void sortByClosest() async {
    final location = Location();
    final locData = await location.getLocation();
    print('locations is ${locData.latitude},${locData.longitude}');
    for (int i = 0; i < prods.length; i++) {
      prods[i]!.fromLoc = Provider.of<AdProvider>(context, listen: false)
          .getDistanceFromCoordinates2(
        prods[i]!.location!.latitude!,
        prods[i]!.location!.longitude!,
        locData.latitude!,
        locData.longitude!,
      );
      print('distance is ${(prods[i]!.fromLoc)}');
    }

    prods.sort((m1, m2) => m1!.fromLoc!.compareTo(m2!.fromLoc!));

    print(
      prods.map(
        (e) => print('La distancia final es ${e!.fromLoc}'),
      ),
    );
    setState(() {
      isProd = true;
    });
  }
}
