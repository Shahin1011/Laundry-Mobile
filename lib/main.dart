import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:laundry/firebase_options.dart';
import 'package:laundry/services/firebase_messaging_service.dart';
import 'package:laundry/services/local_notifications_service.dart';
import 'package:laundry/services/stripe_service.dart';
import 'package:laundry/utils/token_service.dart';
import 'controller/home/booking_controller.dart';
import 'controller/home/choice_package_controller.dart';
import 'controller/profile/profile_controller.dart';
import 'helpers/route.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService =  LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService =  FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);


  await TokenService().init();

  // Initialize Stripe (handle errors gracefully)
  try {
    await StripeService.initialize();
  } catch (e) {
    // Log error but don't crash the app
    debugPrint('Stripe initialization error: $e');
    // App can still function without Stripe if needed
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  Get.put(BookingController());
  Get.put(ChoicePackageController());
  Get.put(ProfileController());

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(393, 852),
      child: GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            toolbarHeight: 65,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        debugShowCheckedModeBanner: false,
        transitionDuration: const Duration(milliseconds: 200),
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: Get.key,
        getPages: AppRoutes.routes,
      ),
    );
  }
}

