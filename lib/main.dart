import 'package:DaSell/live-map/map_view.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:DaSell/widgets/loading/data_backup_initial_page.dart';
import 'package:DaSell/maps/screens/loading_screen.dart';
import 'package:DaSell/screens/tabs/add_product/add_product_screen.dart';
import 'package:DaSell/screens/tabs/home/home_screen.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';

//Screens
import 'widgets/loading/data_backup_home.dart';
import 'maps/blocs/blocs.dart';
import 'maps/services/traffic_service.dart';
import 'models/notification_model.dart';
import 'provider/move_map_provider.dart';
import 'screens/tabs/chat/users_chat_screen.dart';
import 'screens/auth/auth_screen.dart';
import './screens/bottom_navigation.dart';
import 'screens/add/further_cat.dart';
import 'screens/add/product_info_one.dart';
// import 'screens/add/adding_images_screen.dart';
import 'screens/add/price_and_location_screen.dart';
import 'screens/home/product_detail_screen.dart';
import 'screens/chats/chat_screen.dart';

//Models
import 'package:DaSell/models/navigator_service.dart';
import 'models/navigator_service.dart';

//Providers
import 'package:DaSell/provider/push_notification_service.dart';
import 'provider/ad_provider.dart';
import 'widgets/home/pallete.dart';




  void main() async {

      /// assign Locale for timeago when using intl:
      // timeago.setLocaleMessages('en', timeago.EnShortMessages());
      // timeago.setLocaleMessages('en_short', timeago.EnMessages())

      //Método que permite asegurar que cuando se ejecute, se dispone de un context
      //WidgetsFlutterBinding.ensureInitialized();

      final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
      binding.renderView.automaticSystemUiAdjustment = false;

      //Implementamos el método que inicializa la app
      setupLocator();
      await PushNotificationService.initializeApp();

      runApp(MyApp());

    }


    class MyApp extends StatelessWidget {

      @override
      Widget build(BuildContext context) {


        return FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {

              //Comprobamos si tenemos información
               if ( snapshot.hasData ) {

                  //Widget con la información
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => GpsBloc() ),
                      BlocProvider(create: (context) => LocationBloc() ),
                      BlocProvider(create: (context) => MapBloc( locationBloc: BlocProvider.of<LocationBloc>(context) ) ),
                      BlocProvider(create: (context) => SearchBloc( trafficService: TrafficService() ))
                    ],
                    child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => AdProvider(),
                      ),
                      ChangeNotifierProvider(
                        create: ( _ ) => new NotificationModel(),
                      ),
                      ChangeNotifierProvider(
                        create: ( _ ) => new MoveMap(),
                      )
                    ],
                    child: ThemeProvider(
                      saveThemesOnChange: true,
                      themes: [
                        AppTheme(
                          id: 'light_theme', // Id(or name) of the theme(Has to be unique)
                          description: 'ThemeLight',
                          data: ThemeData(
                            fontFamily: 'Roboto',
                            primarySwatch: Palette.kToDark,
                            /*colorScheme: ColorScheme.fromSwatch().copyWith(
                              secondary: Colors.indigo, // Your accent color
                            ),*/
                            accentColor: Colors.indigo.shade800,
                            cardColor: Colors.grey[200],
                            backgroundColor: Colors.indigo,
                            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                              backgroundColor: Colors.white,
                              selectedItemColor: Colors.indigo,
                              unselectedItemColor: Colors.indigo,
                            ),
                            scaffoldBackgroundColor: Colors.white,
                            accentColorBrightness: Brightness.dark,
                            buttonTheme: ButtonTheme.of(context).copyWith(
                              buttonColor: Colors.indigo,
                              textTheme: ButtonTextTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        AppTheme.dark(
                          id: 'dark_theme',
                        ).copyWith(
                          id: 'dark_theme',
                          data: ThemeData.dark().copyWith(
                            appBarTheme: AppBarTheme(
                              color: Color(0xff2a2a2a),
                            ),
                            primaryColor: Color(0xff03dac6),
                            //accentColor: Color(0xff03dac6),
                           colorScheme: ColorScheme.fromSwatch().copyWith(
                              secondary: Color(0xff03dac6), // Your accent color
                            ),
                            cardColor: Color(0xff2a2a2a),
                            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                              backgroundColor: Color(0xff2a2a2a),
                              selectedItemColor: Color(0xff03dac6),
                              unselectedItemColor: Color(0xff03dac7),
                            ),
                            buttonTheme: ButtonTheme.of(context).copyWith(
                              buttonColor: Color(0xff03dac6),
                              textTheme: ButtonTextTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      ],
                      child: ThemeConsumer(
                        child: Builder(
                          builder: (themeContext) => MaterialApp(
                            navigatorKey: locator<NavigatorService>().navigatorKey,
                            onGenerateRoute: (routeSettings) {
                              switch (routeSettings.name) {
                                case 'chat':
                                  return MaterialPageRoute(builder: (context) => UsersChatScreen());
                                //case "product":
                                  //return MaterialPageRoute(builder: (context) => AddProduct() );
                                default:
                                  return MaterialPageRoute(builder: (context) => MyApp());
                              }
                            },
                            title: 'DaSell',
                            theme: ThemeProvider.themeOf(themeContext).data,
                            debugShowCheckedModeBanner: false,
                            //typical android way
                            // home: FirebaseAuth.instance.currentUser() == null
                            //     ? AuthScreen()
                            //     : ChatScreen(),

                            //alternatinve way, here the screen will get changed as soon as
                            //the authstate changes
                            //you don't need to call navigator.of.pushnamed in auth screen as
                            //this method will get called as soon as the authstate changes
                            home: StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {

                                SystemChrome.setSystemUIOverlayStyle(
                                  SystemUiOverlayStyle().copyWith(
                                    statusBarBrightness: Brightness.light,
                                    statusBarColor: ThemeProvider.themeOf(context).id == 'light_theme' 
                                        ? Colors.indigo.shade800
                                        : Color(0xff2a2a2a),                     
                                    statusBarIconBrightness: Brightness.light,
                                    systemNavigationBarColor: ThemeProvider.themeOf(context).id == 'light_theme' 
                                        ?Colors.black54
                                        :Color(0xff2a2a2a),
                                    systemNavigationBarDividerColor: Colors.indigo.shade100,
                                    systemNavigationBarIconBrightness: Brightness.dark,
                                  ),
                                );

                                return snapshot.hasData
                                    ? BottomNavigationScreen()
                                    : AuthScreen();
                              },
                            ),
                            routes: {
                              UsersChatScreen.routeName: (context) => UsersChatScreen(),
                              FurtherCat.routeName: (context) => FurtherCat(),
                              ProductInfoOne.routeName: (context) => ProductInfoOne(),
                              /// TODO: ROTO
                              /// AddingImagesScreen.routeName: (context) => AddingImagesScreen(),
                              PriceAndLocationScreen.routeName: (context) => PriceAndLocationScreen(),
                              BottomNavigationScreen.routeName: (context) => BottomNavigationScreen(),
                              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
                              ChatScreen.routeName: ( context ) => ChatScreen(),
                              AddProduct.routeName: ( context ) => AddProduct(),
                              HomeScreen.routeName: ( context ) => HomeScreen(),
                              DataBackupHome.routeName: ( context ) => DataBackupHome(),
                              LoadingScreen.routeName: ( context ) => LoadingScreen(),
                              //MyMap.routeName: ( context ) => MyMap(),
                            },
                          ),
                        ),
                      ),
                    ),
                ),
                  );
                } else {
                  //CircularProgressIndicator(), permite indicar al usuario que se está cargando infromación
                  return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
                }

            }
        );
      }
    }