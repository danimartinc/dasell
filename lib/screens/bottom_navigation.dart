import 'package:DaSell/models/notification_model.dart';
import 'package:DaSell/widgets/splashscreen/animation_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

//Screens
import 'package:DaSell/screens/home/search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/menu_provider.dart';
import 'tabs/home/home_screen.dart';
import 'tabs/chat/users_chat_screen.dart';
import 'tabs/profile/profile_screen.dart';
import 'tabs/ads/ads_tab_screen.dart';
import 'tabs/add_product/add_product_screen.dart';


class BottomNavigationScreen extends StatefulWidget {

  static const routeName = './bottom_navigation';

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  
  int selectedPageIndex = 0;
  late List<Map<String, Object>> _pages;

  @override
  void initState() {
  
    //Obtenemos la instancia de FirebaseMessaging
    //static FirebaseMessaging messaging = FirebaseMessaging.instance;
  
    // final fcm = FirebaseMessaging.instance;
    //
    // FirebaseMessaging.onMessage.listen(( RemoteMessage message ) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification!.android;
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen(( RemoteMessage message ) {
    //   print('A new onMessageOpenedApp event was published!');
    //   // Navigator.pushNamed(context, '/message',
    //   // //MesageArguments,
    //   //     arguments: MessageArguments( message, true));
    // });



//await Firebase.initializeApp();

    // fcm.configure(
    //
    //   onMessage: (msg) {
    //     print('onMessage');
    //     print( msg );
    //     return;
    //   },
    //
    //   onLaunch: (msg) {
    //     print('onLaunch');
    //     print(msg);
    //     return Navigator.of(context).pushNamed(
    //       UsersChatScreen.routeName,
    //     );
    //   },
    //
    //   onResume: (msg) {
    //     print('onResume');
    //     print(msg);
    //     return Navigator.of(context).pushNamed(
    //       UsersChatScreen.routeName,
    //     );
    //   },
    // );

    //fcm.subscribeToTopic('chats');

    _pages = [
      {
        'pages': HomeScreen(),
        'title': 'Inicio',
      },
      {
        'pages': AdsTabScreen(),
        'title': 'Mis Productos',
      },
      {
        'pages': AddProduct(),
        'title': 'Selecciona una categoría',
      },
      {
        'pages': UsersChatScreen(),
        'title': 'Chats',
      },
      {
        'pages': ProfileScreen(),
        'title': 'Perfil',
      }
    ];
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final int number = Provider.of<NotificationModel>(context).number;
    final menuProviderIndex = Provider.of<MenuProvider>(context).index;

   return Material(
       
        child: Stack(
          children: <Widget>[ 
            Scaffold(
              appBar: menuProviderIndex == 0 ||
                      menuProviderIndex == 1 ||
                      menuProviderIndex == 3
                  ? null
                  : AppBar(
                      title: Text( 
                        _pages[menuProviderIndex]['title'] as String,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
              floatingActionButton: FloatButton(),
              body: _pages[menuProviderIndex]['pages'] as Widget,
              bottomNavigationBar: BottomNavigationBar(
                elevation: 10,
                iconSize: 28,
                currentIndex: menuProviderIndex,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    label: 'Inicio',
                    //backgroundColor: Theme.of(context).primaryColor,
                    icon: menuProviderIndex == 0
                        ? Icon(
                            Icons.home_rounded,
                        )
                        : Icon(
                          Icons.home_outlined,
                        ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Mis productos',
                    icon: menuProviderIndex == 1
                      ? Icon(
                          Icons.receipt,
                      )
                      : Icon(
                          Icons.receipt_outlined,
                      ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Añadir',
                    icon: menuProviderIndex == 2
                      ? Icon(
                          Icons.add_circle,
                      )
                      : Icon(
                          Icons.add_circle_outline,
                      ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Chats',
                    icon: menuProviderIndex == 3
                      ? Stack(
                        children: [
                          Icon( Icons.chat_bubble ),
      
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            // child: Icon( Icons.brightness_1, size: 8, color: Colors.redAccent, )
                            child: BounceInDown(
                              from: 10,
                              animate: ( number > 0) ? true : false,
                              child: Bounce(
                                from: 10,
                                controller: (controller)=> Provider.of<NotificationModel>(context).bounceController = controller,
      
                                child: Container(
                                  child: Text( '$number', style: TextStyle(color: Colors.white, fontSize: 7 ), ),
                                  alignment: Alignment.center,
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                      : Icon(
                          Icons.chat_bubble_outline,
                      ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Perfil',
                    icon: menuProviderIndex == 4 
                      ? Icon(
                        Icons.person,
                      )
                      : Icon(
                          Icons.person_outline,
                      ),
                  ),
                ],
                onTap: (index) =>  Provider.of<MenuProvider>(context, listen: false ).setIndex(index)
                //selectedPageIndex = index;
              ),
            ),
            IgnorePointer(
              child: AnimationScreen(
                color: Theme.of(context).accentColor
              ),
            ),
          ],
        ),
      );
  }
}

class FloatButton extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      child: FaIcon( FontAwesomeIcons.play ),
      backgroundColor: Colors.pink,
      onPressed: (){

        final notiModel = Provider.of<NotificationModel>(context, listen: false);

        int number = notiModel.number;
        number++;

        notiModel.number = number;

        if ( number >= 2 ) {
          final controller = notiModel.bounceController;
          controller.forward( from: 0.0 );
        }

      }
    );
  }

}