import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class InputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String hintText;
  final IconData? prefixIcon;
  final double height;
  final String topLabel;
  final bool obscureText;
  final TextCapitalization capitalization;
  final bool isEnable;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;

  const InputWidget({
    super.key,
    this.controller,
    this.focusNode,
    this.maxLine,
    this.nextNode,
    this.textInputAction,
    this.isPhoneNumber = false,
    this.isValidator = false,
    this.validatorMessage,
    this.textInputType,
    required this.hintText,
    this.prefixIcon,
    this.height = 48.0,
    this.topLabel = "",
    this.obscureText = false,
    this.capitalization = TextCapitalization.none,
    this.isEnable = true,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(topLabel),
        const SizedBox(height: 5.0),
        Container(
          height: ScreenUtil().setHeight(height),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            keyboardType: textInputType ?? TextInputType.text,
            enabled: isEnable,
            controller: controller,
            textCapitalization: capitalization,
            obscureText: obscureText,
            maxLines: maxLine ?? 1,
            maxLength: isPhoneNumber ? 15 : null,
            initialValue: null,
            textInputAction: textInputAction ?? TextInputAction.next,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(nextNode);
            },
            inputFormatters: [
              isPhoneNumber
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.singleLineFormatter
            ],
            validator: (input) {
              if (input!.isEmpty) {
                if (isValidator) {
                  return validatorMessage ?? "";
                }
              }
              return null;
            },
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.primaryColor,
                ),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
            ),
          ),
        )
      ],
    );
  }
}
