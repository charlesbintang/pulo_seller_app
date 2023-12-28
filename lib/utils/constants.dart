import 'package:flutter/material.dart';

List<Widget> allProduct = [];

class Constants {
  static const Color primaryColor = Colors.blue;
  static const Color scaffoldBackgroundColor = Color.fromRGBO(245, 247, 249, 1);
}

void nextScreen(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}
