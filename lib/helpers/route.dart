import 'package:get/get.dart';
import '../view/auth/forgot_password_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/auth/new_password_screen.dart';
import '../view/auth/otp_screen.dart';
import '../view/auth/otp_verify_forgotscreen.dart';
import '../view/auth/sign_up_screen.dart';
import '../view/home/choice_package_screen.dart';
import '../view/bottom_nav/bottom_nav.dart';
import '../view/home/home_screen.dart';
import '../view/home/information_screen.dart';
import '../view/home/date_time_screen.dart';
import '../view/home/notification_screen.dart';
import '../view/home/payment_screen.dart';
import '../view/home/success_screen.dart';
import '../view/home/stripe_payment_screen.dart';
import '../view/myOrder/myOreder_screen.dart';
import '../view/myOrder/order_details_screen.dart';
import '../view/profile/Help_support_screen.dart';
import '../view/profile/change_password_screen.dart';
import '../view/profile/contract_us_screen.dart';
import '../view/profile/edit_profile_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/splash/location_screen.dart';
import '../view/splash/onboarding_screen.dart';
import '../view/splash/splash_screen.dart';




class AppRoutes {

  static const String bottomNavScreen = "/bottom_nav";
  static const String splashScreen = "/splash_screen";
  static const String onboardingScreen = "/onboarding_screen";
  static const String locationScreen = "/location_screen";
  static const String loginScreen = "/login_screen";
  static const String forgotPasswordScreen = "/forgot_password_screen";
  static const String oTPScreen = "/otp_screen";
  static const String otpVerifyForForgotPass = "/otp_verify_forgotscreen";
  static const String newPasswordScreen = "/new_password_screen";
  static const String signUPScreen = "/sign_up_screen";
  static const String homeScreen = "/home_screen";
  static const String myOrderScreen = "/myOreder_screen";
  static const String profileScreen = "/profile_screen";
  static const String choicePackageScreen = "/choice_package_screen";
  static const String informationScreen = "/information_screen";
  static const String dateTimeScreen = "/date_time_screen";
  static const String paymentScreen = "/payment_screen";
  static const String successScreen = "/success_screen";
  static const String stripePaymentScreen = "/stripe_payment_screen";

  static const String editProfileScreen = "/edit_profile_screen";
  static const String helpAndSupportScreen = "/Help_support_screen";
  static const String contractUsScreen = "/contract_us_screen";
  static const String orderDetailsScreen = "/order_details_screen";
  static const String notificationScreen = "/notification_screen";
  static const String changePasswordScreen = "/change_password_screen";

  static List<GetPage> routes = [

    GetPage(name: bottomNavScreen, page: () => BottomNavScreen()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: locationScreen, page: () => LocationScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: oTPScreen, page: () => OTPScreen()),
    GetPage(name: otpVerifyForForgotPass, page: () => OtpVerifyForForgotPass()),
    GetPage(name: newPasswordScreen, page: () => NewPasswordScreen()),
    GetPage(name: signUPScreen, page: () => SignUPScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: myOrderScreen, page: () => MyOrderScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: choicePackageScreen, page: () => ChoicePackageScreen()),
    GetPage(name: informationScreen, page: () => InformationScreen()),
    GetPage(name: dateTimeScreen, page: () => DateTimeScreen()),
    GetPage(name: paymentScreen, page: () => PaymentScreen()),
    GetPage(name: successScreen, page: () => SuccessScreen()),
    GetPage(name: stripePaymentScreen, page: () => StripePaymentScreen()),

    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: helpAndSupportScreen, page: () => HelpAndSupportScreen()),
    GetPage(name: contractUsScreen, page: () => ContractUsScreen()),
    GetPage(name: orderDetailsScreen, page: () => OrderDetailsScreen(orderId: Get.arguments,)),
    GetPage(name: notificationScreen, page: () => NotificationScreen()),
    GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen()),

  ];
}