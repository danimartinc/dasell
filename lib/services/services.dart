import 'package:DaSell/commons.dart';

import '../provider/push_notification_service.dart';
import 'firebase/firebase_service.dart';

export 'data_service.dart';
export 'firebase/firebase_service.dart';
export 'navigator_service.dart';

GetIt locator = GetIt.instance;

Future<void> initApp() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;
  setupLocator();
  await FirebaseService.get().init();
  await DataService.get().init();
  await PushNotificationService.initializeApp();
}

void setupLocator() {
  locator.registerLazySingleton(() => NavigatorService());
  locator.registerSingleton(DataService());
  locator.registerSingleton(FirebaseService());
}
