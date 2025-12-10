import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/home/booking_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';



class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {

  final ProfileController c = Get.find<ProfileController>();
  final BookingController bookingController = Get.find<BookingController>();


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  
  String selectedState = 'Alabama';

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Wait for profile to load, then prefill controllers
    _loadProfileData();
  }

  void _loadProfileData() {
    // If profile is already loaded, use it
    if (c.profile.value != null) {
      _prefillControllers();
    } else {
      // Listen for profile changes and prefill when it loads
      ever(c.profile, (profile) {
        if (profile != null && mounted) {
          _prefillControllers();
        }
      });
      
      // Also try to prefill after a short delay in case profile loads quickly
      Future.delayed(const Duration(milliseconds: 500), () {
        if (c.profile.value != null && mounted) {
          _prefillControllers();
        }
      });
    }
  }

  void _prefillControllers() {
    final profile = c.profile.value;
    if (profile != null) {
      // Prefill controllers only if they're empty (don't overwrite user input)
      if (fullNameController.text.isEmpty && profile.fullname.isNotEmpty) {
        fullNameController.text = profile.fullname;
      }
      if (emailController.text.isEmpty && profile.email.isNotEmpty) {
        emailController.text = profile.email;
      }

      // Save to booking controller
      if (profile.fullname.isNotEmpty) {
        bookingController.fullName.value = profile.fullname;
      }
      if (profile.email.isNotEmpty) {
        bookingController.email.value = profile.email;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
          children: [
            // Header
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              color: AppColors.mainAppColor,
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/backIcon.svg",
                      width: 24.w,
                      height: 24.h,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Information',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            
            // Progress Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              color: Colors.white,
              child: Row(
                children: [
                  _buildProgressStep('Information', 1, isActive: true, isCompleted: true),
                  _buildProgressLine(isActive: true),
                  _buildProgressStep('date & time', 2, isActive: false),
                  _buildProgressLine(isActive: false),
                  _buildProgressStep('Payment', 3, isActive: false),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Full Name
                    _buildTextField(
                      label: 'Full Name',
                      controller: fullNameController,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Email
                    _buildTextField(
                      label: 'Email',
                      controller: emailController,
                      hintText: 'example@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Phone
                    IntlPhoneField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color:  Color(0xFFE5E5E5), width: 1)
                        ),
                        focusedBorder: OutlineInputBorder( // Active border
                          borderSide: BorderSide(color: AppColors.mainAppColor, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),

                      ),
                      initialCountryCode: 'US',
                      validator: (value) {
                        if (value == null) {
                          return "Please enter your Phone Number";
                        }
                        return null;
                      },
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Address
                    _buildTextField(
                      label: 'Address',
                      controller: addressController,
                      isAddress: false,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // City
                    _buildTextField(
                      label: 'City',
                      controller: cityController,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // State Dropdown
                    _buildStateDropdown(),
                    
                    SizedBox(height: 16.h),
                    
                    // Zip Code
                    _buildTextField(
                      label: 'Zip Code',
                      controller: zipCodeController,
                      keyboardType: TextInputType.number,
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Continue Button
                    GestureDetector(
                      onTap: () {
                        // Validate all fields
                        if (fullNameController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter full name');
                          return;
                        }
                        if (emailController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter email');
                          return;
                        }
                        if (phoneController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter phone number');
                          return;
                        }
                        if (addressController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter address');
                          return;
                        }
                        if (cityController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter city');
                          return;
                        }
                        if (zipCodeController.text.isEmpty) {
                          Get.snackbar('Error', 'Please enter zip code');
                          return;
                        }

                        // Save to booking controller
                        bookingController.fullName.value = fullNameController.text;
                        bookingController.email.value = emailController.text;
                        bookingController.phone.value = phoneController.text;
                        bookingController.address.value = addressController.text;
                        bookingController.city.value = cityController.text;
                        bookingController.state.value = selectedState;
                        bookingController.zipCode.value = zipCodeController.text;

                        // Navigate to date time screen
                        Navigator.of(context).pushNamed('/date_time_screen');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.mainAppColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildProgressStep(String label, int step, {required bool isActive, bool isCompleted = false}) {
    Color circleColor = isActive ? AppColors.mainAppColor : (isCompleted ? Color(0xFFE5E5E5) : Color(0xFFE5E5E5));
    Color textColor = isActive ? AppColors.mainAppColor : Color(0xFF757575);
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Color(0xFF757575),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        color: isActive ? AppColors.mainAppColor : Color(0xFFE5E5E5),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    bool isAddress = false,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F1D1D),
          ),
        ),
        SizedBox(height: 8.h),
        isAddress
            ? GestureDetector(
                onTap: () {
                  // Handle address tap to open location picker
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Color(0xFFE5E5E5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20.sp,
                        color: Color(0xFF1F1D1D),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          controller.text.isEmpty ? (hintText ?? '') : controller.text,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: controller.text.isEmpty ? Color(0xFF757575) : Color(0xFF1F1D1D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : TextField(
                controller: controller,
                keyboardType: keyboardType,
                readOnly: readOnly,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF757575),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.mainAppColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1F1D1D),
                ),
              ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F1D1D),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            _showStatePicker();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedState,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: selectedState == 'Select' ? Color(0xFF757575) : Color(0xFF1F1D1D),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 24.sp,
                  color: Color(0xFF1F1D1D),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showStatePicker() {
    final List<String> states = [
      'Select',
      'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 
      'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 
      'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 
      'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 
      'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 
      'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 
      'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: states.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      states[index],
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1F1D1D),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedState = states[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    final Color color = isActive ? AppColors.mainAppColor : Color(0xFF757575);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
