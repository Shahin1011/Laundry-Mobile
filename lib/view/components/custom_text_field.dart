import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';



class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.textEditingController,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.cursorColor = Colors.black,
    this.inputTextStyle,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.hintText,
    this.hintStyle,
    this.fillColor = AppColors.white,
    this.suffixIcon,
    this.suffixIconColor,
    this.fieldBorderRadius = 12,
    this.fieldBorderColor = Colors.transparent, //const Color(0xffB5D8EE),
    this.isPassword = false,
    this.isPrefixIcon = true,
    this.readOnly = false,
    this.maxLength,
    this.prefixIcon,
    this.onTap,
    this.isDens = false,
  });

  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color cursorColor;
  final TextStyle? inputTextStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? suffixIconColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double fieldBorderRadius;
  final Color fieldBorderColor;
  final bool isPassword;
  final bool isPrefixIcon;
  final bool readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final bool? isDens;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: widget.onFieldSubmitted,
      readOnly: widget.readOnly,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      cursorColor: widget.cursorColor,
      style: widget.inputTextStyle ??
          GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.mainAppColor,
          ),
      onChanged: widget.onChanged,
      obscuringCharacter: ".",
      maxLines: widget.maxLines,
      obscureText: widget.isPassword ? obscureText : false,
      validator: widget.validator,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.borderColor),
          fillColor: widget.fillColor,
          filled: true,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? GestureDetector(
            onTap:toggle,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(

                obscureText
                    ? Icons.visibility_off :
                Icons.visibility,
                color: obscureText ? Color(0xFFB1B1B1)
                    : Color(0xFFB1B1B1),
                size: 20,
              ),

              /*SvgPicture.asset(
                    obscureText ? AppIcons.eyeOff : AppIcons.eye,
                    height: 22,
                    width: 22,
                    color: AppColors.black,
                  ),*/
            ),
          )
              : widget.suffixIcon,
          suffixIconColor: widget.suffixIconColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.fieldBorderRadius),
            borderSide: BorderSide(color: widget.fieldBorderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.fieldBorderRadius),
            borderSide: BorderSide(color: AppColors.mainAppColor, width: 1),

          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.fieldBorderRadius),
            borderSide: BorderSide(color: widget.fieldBorderColor, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5
          )
      ),
    );
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}