import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask/mask/mask.dart';
import 'package:mask/models/hashtag_is.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final bool isActive;
  final bool isPhoneInput;
  final bool isUsernameInput;
  final String hintText;
  final String labelText;
  final TextInputType textInputType;
  final bool autoFocus;
  final Function(String)? onChanged;
  final int? maxLines;
  final TextAlign? align;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      this.isPhoneInput = false,
      this.isUsernameInput = false,
      required this.hintText,
      this.labelText = '',
      required this.textInputType,
      this.isActive = true,
      this.autoFocus = false,
      this.onChanged,
      this.maxLines = 1,
      this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      enabled: isActive,
      autofocus: autoFocus,
      onChanged: (value) => onChanged?.call(value),
      textAlign: align ?? TextAlign.start,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        labelText: labelText.isNotEmpty ? labelText : null,
        contentPadding: const EdgeInsets.all(8),
      ),
      maxLines: maxLines,
      inputFormatters: [
        if (isUsernameInput)
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        if (isPhoneInput)
          Mask.generic(
            masks: ['(###)-###-##-##'],
            hashtag: Hashtag.numbers, // optional field
          ),
      ],
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
