// ignore_for_file: library_private_types_in_public_api

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../models/seller_products.dart';
import '../utils/color_resources.dart';
import '../utils/constants.dart';
import 'home_dashboard.dart';
import 'product_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Track active index
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: [
          Icon(
            Icons.home,
            size: 30.0,
            color: activeIndex == 0
                ? ColorResources.white
                : const Color(0xFFC8C9CB),
          ),
          Image.asset(
            "assets/images/boxProduct.png",
            color: activeIndex == 1
                ? ColorResources.white
                : const Color(0xFFC8C9CB),
            width: 30,
            height: 30,
          ),
          // Icon(
          //   Icons.pin_drop_rounded,
          //   size: 30.0,
          //   color: activeIndex == 1 ? ColorResources.white : const Color(0xFFC8C9CB),
          // ),
          // Icon(
          //   Icons.add,
          //   size: 30.0,
          //   color: activeIndex == 2 ? ColorResources.white : const Color(0xFFC8C9CB),
          // ),
          // Icon(
          //   Icons.favorite,
          //   size: 30.0,
          //   color: activeIndex == 3 ? ColorResources.white : const Color(0xFFC8C9CB),
          // ),
          // Icon(
          //   Icons.settings,
          //   size: 30.0,
          //   color: activeIndex == 2
          //       ? ColorResources.white
          //       : const Color(0xFFC8C9CB),
          // ),
        ],
        onTap: (index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
      backgroundColor: Constants.primaryColor,
      body: SizedBox(child: onTapBottomNavigation(activeIndex)),
    );
  }

  onTapBottomNavigation(int activeIndex) {
    if (activeIndex != 1) {
      sellerProducts.clear();
    }
    switch (activeIndex) {
      case 0:
        return const HomeDashboard();

      case 1:
        return const ProductView();

      case 2:
        return const HomeDashboard();

      default:
    }
  }
}
