import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/location.dart';

class StatistikToko extends StatelessWidget {
  const StatistikToko({super.key});

  @override
  Widget build(BuildContext context) {
    // Model to represent each card

    // Make a list to represent each card
    List<DetailsStatistikToko> listStatistikToko = [
      DetailsStatistikToko(
        title: "Produk Dilihat",
        color: const Color.fromRGBO(89, 69, 199, 1),
        point: "Tambah Produk",
        imagePath: "assets/images/house1.png",
        persentase: "0% dari 30 hari terakhir",
      ),
      DetailsStatistikToko(
        title: "Dalam Keranjang",
        color: const Color.fromRGBO(237, 116, 41, 1),
        point: "0",
        imagePath: "assets/images/house2.png",
        persentase: "0% dari 30 hari terakhir",
      )
    ];
    return SizedBox(
      height: ScreenUtil().setHeight(90.0),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: ScreenUtil().setWidth(158.0),
              decoration: BoxDecoration(
                color: listStatistikToko[index].color,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(169, 176, 185, 0.42),
                    spreadRadius: 0,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 12.0,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${listStatistikToko[index].title}\n",
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        TextSpan(
                          text: "${listStatistikToko[index].point}\n",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            fontSize: 16.0,
                          ),
                        ),
                        TextSpan(
                          text: "${listStatistikToko[index].persentase}\n",
                          style: const TextStyle(
                            height: 1.5,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 15.0,
          );
        },
        itemCount: listStatistikToko.length,
      ),
    );
  }
}
