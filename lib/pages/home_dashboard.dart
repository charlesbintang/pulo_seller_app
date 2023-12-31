import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_resources.dart';
import '../utils/constants.dart';
import '../widgets/latest_orders.dart';
import '../widgets/location_slider.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Positioned(
        //   right: 0.0,
        //   top: -20.0,
        //   child: Opacity(
        //     opacity: 0.3,
        //     child: Image.asset(
        //       "assets/images/washing_machine_illustration.png",
        //     ),
        //   ),
        // ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome Back,\n",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: ColorResources.white,
                                    ),
                              ),
                              TextSpan(
                                text: "Users!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/images/user.png",
                          height: 80,
                          width: 80,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200.0,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Constants.scaffoldBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Statistik Toko",
                        style: TextStyle(
                          color: Color.fromRGBO(19, 22, 33, 1),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    SizedBox(
                      height: ScreenUtil().setHeight(100.0),
                      child: const Center(
                        // lets make a widget for the cards
                        child: StatistikToko(),
                      ),
                    ),
                    LatestOrders(),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
