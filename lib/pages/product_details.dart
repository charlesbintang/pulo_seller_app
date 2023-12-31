import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/seller_products.dart';
import '../utils/color_resources.dart';
import '../utils/constants.dart';
import '../utils/light_themes.dart';

class ProductDetails extends StatefulWidget {
  final SellerProducts sellerProductsDetails;
  const ProductDetails({
    super.key,
    required this.sellerProductsDetails,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(300),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                            widget.sellerProductsDetails.productImage),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: ScreenUtil().setHeight(35),
                        width: ScreenUtil().setWidth(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Constants.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: ColorResources.black,
                                  blurRadius: 1,
                                  offset: Offset.zero)
                            ]),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_rounded,
                                color: ColorResources.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   right: 0,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: Container(
                  //       height: ScreenUtil().setHeight(5),
                  //       width: ScreenUtil().setWidth(3),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           color: const Color(0xff757283)),
                  //       child: Center(
                  //           child: Icon(
                  //         Icons.favorite_rounded,
                  //         color: ColorResources.white,
                  //       )),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(4),
                    ),
                    Text(
                      widget.sellerProductsDetails.productName,
                      style: TextStyle(
                          fontSize: 21.5,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.black),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.star,
                    //       color: Color(0xffFCD506),
                    //       size: 16,
                    //     ),
                    //     Text(
                    // widget.sellerProductsDetails.ratting,
                    //       style: TextStyle(
                    //           fontSize: 12.5, color: ColorResources.black),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: ScreenUtil().setHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.sellerProductsDetails.productPrice,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: ColorResources.black),
                        ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       height: ScreenUtil().setHeight(4),
                        //       width: ScreenUtil().setWidth(10),
                        //       decoration: BoxDecoration(
                        //           color: blue2, shape: BoxShape.circle),
                        //       child: Center(
                        //         child: Icon(
                        //           Icons.remove,
                        //           color: ColorResources.white,
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: ScreenUtil().setWidth(5),
                        //     ),
                        //     Text(
                        //       "1",
                        //       style: TextStyle(
                        //         fontSize: 22,
                        //         color: ColorResources.black,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: ScreenUtil().setWidth(5),
                        //     ),
                        //     Container(
                        //       height: ScreenUtil().setHeight(8),
                        //       width: ScreenUtil().setWidth(10),
                        //       decoration: BoxDecoration(
                        //           color: blue2, shape: BoxShape.circle),
                        //       child: Center(
                        //           child: Icon(
                        //         Icons.add,
                        //         color: ColorResources.white,
                        //       )),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Text(
                      widget.sellerProductsDetails.productDescription,
                      style: TextStyle(
                        fontSize: 15,
                        color: ColorResources.black,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(70),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Constants.primaryColor)),
                          child: Text(
                            "Update",
                            style: TextStyle(color: ColorResources.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Remove",
                            style: TextStyle(color: ColorResources.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(ColorResources.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
