import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: const Color(0xFF1455AC),
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFF9E9E9E),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1455AC),
    secondary: Color(0xFF004C8E),
    tertiary: Color(0xFFF9D4A8),
    tertiaryContainer: Color(0xFFADC9F3),
    onTertiaryContainer: Color(0xFF33AF74),
    primaryContainer: Color(0xFF9AECC6),
    secondaryContainer: Color(0xFFF2F2F2),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);

// Colors
Color green1 = const Color(0xFF097210);
Color green2 = const Color(0xFF00880F);

Color dark1 = const Color(0xFF1C1C1C);
Color dark2 = const Color(0xFF4A4A4A);
Color dark3 = const Color(0xFF999798);
Color dark4 = const Color(0xFFEDEDED);

Color blue1 = const Color(0xFF1455AC);
Color blue2 = const Color(0xFF00AED5);
Color blue3 = const Color(0xFF38BBDA);

Color red = const Color(0xFFED2739);
Color purple = const Color(0xFF87027B);

// Typography
TextStyle regular12_5 =
    const TextStyle(fontFamily: 'SF-Pro-Display', fontSize: 12.5);
TextStyle regular14 = regular12_5.copyWith(fontSize: 14);
TextStyle regular16 = regular12_5.copyWith(fontSize: 16);

TextStyle semibold12_5 = regular12_5.copyWith(fontWeight: FontWeight.w600);
TextStyle semibold14 = semibold12_5.copyWith(fontSize: 14, letterSpacing: 0.1);

TextStyle bold16 = regular12_5.copyWith(
    fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.1);
TextStyle bold18 = bold16.copyWith(fontSize: 18, letterSpacing: -0.5);
TextStyle bold20 = bold16.copyWith(fontSize: 20, letterSpacing: -0.5);
