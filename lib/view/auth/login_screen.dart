import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import 'package:laundry/utils/app_contants.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../../utils/token_service.dart';
import '../components/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controller/profile/profile_controller.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool agree = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _loginUser(String email, String password) async {
    final loginApiUrl = "${AppConstants.BASE_URL}/api/auth/login";

    if (!_formKey.currentState!.validate()) return;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    final body = {
      'email': email,
      'password': password,
    };

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse(loginApiUrl),
        headers: { 'Content-Type': 'application/json' },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        Get.snackbar(
          'Success',
          data["message"] ?? "Login successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        /// Save the token
        String accessToken = data['data']['accessToken'];
        await TokenService().saveToken(accessToken);

        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);


        /// Save email/password if user checked "Remember me"
        if (!agree) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove("email");
          await prefs.remove("password");
        }
        
        // Fetch profile after successful login
        try {
          final profileController = Get.find<ProfileController>();
          await profileController.ensureProfileLoaded();
        } catch (e) {
          print('Error fetching profile after login: $e');
        }
        
        Get.offNamed(AppRoutes.bottomNavScreen);

      } else {
        Get.snackbar("Error", data['message'] ?? "Login failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      setState(() { isLoading = false; });
    }
  }


  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null) emailController.text = savedEmail;
    if (savedPassword != null) passController.text = savedPassword;

    setState(() {
      agree = (savedEmail != null && savedPassword != null);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.11),
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F1D1D),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Login to your account",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF595959),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.059),

                    Text(
                      "Enter your E-mail",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF303030),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      textEditingController: emailController,
                      hintText: 'example@gmail.com',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.subHeadingColor,
                      ),
                      fillColor: const Color(0xFFFFFFFF),
                      fieldBorderColor: AppColors.borderColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an email";
                        } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      "Password",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF303030),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      textEditingController: passController,
                      hintText: '**********',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.subHeadingColor,
                      ),
                      isPassword: true,
                      fillColor: const Color(0xFFFFFFFF),
                      fieldBorderColor: AppColors.borderColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => agree = !agree),
                          child: Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.mainAppColor, width: 1.5),
                              borderRadius: BorderRadius.circular(3),
                              color: agree ? AppColors.mainAppColor : Colors.transparent,
                            ),
                            child: agree
                                ? SvgPicture.asset(
                              "assets/icons/checkIcon.svg",
                              height: 14.h,
                              width: 14.w,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Remember me',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF737373),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: (){
                            Get.toNamed(AppRoutes.forgotPasswordScreen);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFF5C5C),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                        _loginUser(
                          emailController.text.trim(),
                          passController.text.trim(),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.mainAppColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            isLoading ? "Loading..." : "Login",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE6E6E6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1.5,
                            color: const Color(0xFFB1B1B1),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            "Or Continue With",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF303030),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1.5,
                            color: const Color(0xFFB1B1B1),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Button
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0B0E12).withOpacity(0.20),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              // TODO: Implement Google sign in
                            },
                            icon: SvgPicture.asset(AppIcons.googleIcon, width: 20, height: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),

                        SizedBox(width: 10.w),

                        // apple Button
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0B0E12).withOpacity(0.20),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              // TODO: Implement Apple sign in
                            },
                            icon: SvgPicture.asset(AppIcons.appleIcon, width: 20, height: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),

                        SizedBox(width: 10.w),

                        // Facebook Button
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0B0E12).withOpacity(0.20),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              // TODO: Implement Facebook sign in
                            },
                            icon: SvgPicture.asset(AppIcons.fbIcon, width: 20, height: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF2B2B2B),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.toNamed(AppRoutes.signUPScreen);
                            },
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2B2B2B),
                              ),
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}