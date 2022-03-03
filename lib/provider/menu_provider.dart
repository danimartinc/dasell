

import 'package:DaSell/commons.dart';

class MenuProvider extends ChangeNotifier{

  int index = 0;

  void setIndex ( int index ){
    index = index;
    notifyListeners();
  }
}