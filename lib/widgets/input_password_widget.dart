import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class InputPasswordWidget extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? nextNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final IconData? prefixIcon;
  final double height;
  final String topLabel;

  const InputPasswordWidget({
    super.key,
    this.controller,
    this.nextNode,
    this.textInputType,
    this.textInputAction,
    required this.hintText,
    this.prefixIcon,
    this.height = 48.0,
    this.topLabel = "",
  });

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidget();
}

class _InputPasswordWidget extends State<InputPasswordWidget> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.topLabel),
        const SizedBox(height: 5.0),
        Container(
          height: ScreenUtil().setHeight(widget.height),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: widget.controller,
            textInputAction: widget.textInputAction,
            validator: (value) {
              return null;
            },
            onFieldSubmitted: (v) {
              setState(() {
                widget.textInputAction == TextInputAction.done
                    ? FocusScope.of(context).consumeKeyboardToken()
                    : FocusScope.of(context).requestFocus(widget.nextNode);
              });
            },
            obscureText: _obscureText,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: _toggle),
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
              hintText: widget.hintText,
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
