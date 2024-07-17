import 'package:app17000ft/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? textController;
  final IconData? prefixIcon;
  final String? hintText;
  final String? labelText;
  final IconButton? suffixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? textInputType;
  final int? maxlines;

  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final FocusNode? focusNode;
  final Function()? onTap;

  const CustomTextFormField({
    super.key,
    this.textController,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.obscureText,
    this.textInputType,
    this.maxlines,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onSaved,
    this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TextFormField(
        
          onTap: onTap ?? () => {},
          controller: textController!,
          obscureText: obscureText ?? false,
          readOnly: readOnly ?? false,
          focusNode: focusNode,
          keyboardType: textInputType,
          maxLines: maxlines ?? 1,
          validator: validator ??

              (value) {
                // Use validator if provided, otherwise provide a basic one
                if (value == null || value.isEmpty) {
                  return 'Field must be filled';
                }

                return null; // Return null if the data is valid
              },
              onSaved: onSaved ?? (value){

              },
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixIcon,
            prefixIconColor: AppColors.outline,
            suffixIconColor: AppColors.outline,
            label: Text(
              labelText!,
              style: AppStyles.captionText(context, AppColors.outline,12),
            ),
            hintText: hintText ?? '',
            floatingLabelStyle: const TextStyle(color: AppColors.primary),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: AppColors.onBackground,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: AppColors.outline),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: AppColors.error),
            ),
          )),
    );
  }
}
