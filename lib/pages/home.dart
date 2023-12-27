import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';
import '../widgets/app_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  // top: sc.height * 0.15,
                  top: ScreenUtil().setHeight(100),
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          opacity: 0.5,
                          fit: BoxFit.fill,
                          image:
                              AssetImage("assets/images/cart_arrow_down.png")),
                    ),
                  ),
                ),
                Positioned(
                  top: ScreenUtil().setHeight(100),
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                      scale: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              decoration: const BoxDecoration(
                color: Constants.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Welcome to PULO Seller!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(19, 22, 33, 1),
                        ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // const Text(
                  //   "This is the first version of our laundry app. Please sign in or create an account below.",
                  //   style: TextStyle(
                  //     color: Color.fromRGBO(74, 77, 84, 1),
                  //     fontSize: 14.0,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  // Let's create a generic button widget
                  AppButton(
                    text: "Log In",
                    type: ButtonType.PLAIN,
                    onPressed: () {
                      nextScreen(context, "/login");
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  AppButton(
                    text: "Create an Account",
                    type: ButtonType.PRIMARY,
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
