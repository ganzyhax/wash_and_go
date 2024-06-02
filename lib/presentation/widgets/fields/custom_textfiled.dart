import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? suffixIcon;
  final bool? isPassword;
  final TextEditingController controller;
  final bool? isNumber;
  final bool? passwordShow;
  final int? maxLength;
  final bool? isEnabled;
  final FocusNode? focusNode;
  final Function()? onTapIcon;
  final String? Function(String?)? validator;
  final Function(String value)? onChanged;
  final Function(PointerDownEvent value)? onTapOutside;
  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.suffixIcon,
      this.passwordShow,
      this.focusNode,
      this.isPassword,
      this.isEnabled = true,
      this.onTapIcon,
      this.onTapOutside,
      this.maxLength,
      this.validator,
      this.isNumber,
      this.onChanged,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // TextField background color
        border: Border.all(color: Colors.grey), // Border color
        borderRadius: BorderRadius.circular(15), // Border radius
      ),
      child: Center(
        child: TextFormField(
            focusNode: (focusNode != null) ? focusNode : null,
            cursorColor: Colors.black,
            enabled: (isEnabled == true) ? true : false,
            // onSubmitted: onSubmit,
            keyboardType:
                (isNumber == null) ? TextInputType.text : TextInputType.number,
            onChanged: onChanged,
            onTapOutside: onTapOutside,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            maxLength: (maxLength == null) ? null : maxLength,
            obscureText: (isPassword == true)
                ? (passwordShow == true)
                    ? true
                    : false
                : false,
            decoration: InputDecoration(
              suffixIcon: (isPassword == true)
                  ? IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        (passwordShow == false)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: onTapIcon,
                    )
                  : null,
              counterText: '',
              hintText: hintText, // Display hint text
              border: InputBorder.none, // Remove underline
              contentPadding: EdgeInsets.only(
                  left: 20,
                  top: (isPassword == true)
                      ? 10
                      : 0), // Adjust padding as needed
              // Icon on the right side
            )),
      ),
    );
  }
}
