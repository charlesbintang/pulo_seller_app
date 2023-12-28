import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulo_seller_app/global/global_var.dart';

import '../utils/constants.dart';
import '../utils/light_themes.dart';
import '../widgets/latest_orders.dart';
import '../widgets/location_slider.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    super.key,
  });
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Future<FirebaseApp> fapp = Firebase.initializeApp();

  DatabaseReference food = FirebaseDatabase.instance
      .ref()
      .child("sellerItems")
      .child(userID)
      .child("food");

  void getDataOnce() async {
    DataSnapshot foodSnapshot = await food.get();
    if (foodSnapshot.exists) {
      Map<dynamic, dynamic> foodItems = foodSnapshot.value as Map;
      foodItems.forEach((foodItemKey, foodItemData) {
        // productPrice.add(foodItemData["productPrice"]);
        // productImage.add(foodItemData["productImage"]);
        allProduct.add(Text(foodItemData["productName"]));
      });
    } else {
      allProduct.add(
        Text("No Product Available"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allProduct.isEmpty) {
      getDataOnce();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
        title: const Text("Daftar Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SearchBoxDaftarProduk(),
            SizedBox(
              height: ScreenUtil().setHeight(300),
              child: FutureBuilder(
                future: fapp,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong with firebase");
                  } else if (snapshot.hasData) {
                    return content();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget content() {
    ///
    /// listening always run!
    ///
    // food.onValue.listen((event) {
    //   DataSnapshot foodSnapshot = event.snapshot;
    //   if (foodSnapshot.value != null) {
    //     // Iterasi melalui setiap food item
    //     Map<dynamic, dynamic> foodItems = foodSnapshot.value as Map;
    //     foodItems.forEach((foodItemKey, foodItemData) {
    //       // Mendapatkan productName dari setiap food item
    //       setState(() {
    //         allProduct.add(
    //           Text(
    //             foodItemData["productName"].toString(),
    //           ),
    //         );
    //       });

    //       // Lakukan sesuatu dengan foodItemKey, productName, dan data lainnya
    //     });
    //   } else {
    //     print("Tidak ada data di dalam food");
    //   }
    // }, onError: (error) {
    //   // Handle jika terjadi kesalahan.
    // });

    // List<Widget> allProductAfterInitState() {
    //   List<Widget> data = [];

    //   return data;
    // }
    return Column(
        children: allProduct.isEmpty ? [Text("tidak ada")] : allProduct);
    // ListView.builder(
    //       shrinkWrap: true,
    //       physics: const ScrollPhysics(),
    //       scrollDirection: Axis.horizontal,
    //       itemCount: smallcon.length,
    //       itemBuilder: ((context, index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: InkWell(
    //             onTap: (() {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: ((context) => FoodDetails(
    //                         details: smallcon[index],
    //                         detail: BigCon[index],
    //                       )),
    //                 ),
    //               );
    //             }),
    //             child: Container(
    //               width: screenSize.width * 0.22,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(55),
    //                 color: Colors.white,
    //                 boxShadow: [
    //                   BoxShadow(
    //                     blurRadius: 0.8,
    //                     color: blue1,
    //                     offset: Offset(0.0, 0.5),
    //                   )
    //                 ],
    //               ),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(4.0),
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       height: screenSize.height * 0.1,
    //                       width: screenSize.width * 0.2,
    //                       decoration: BoxDecoration(
    //                           image: DecorationImage(
    //                               fit: BoxFit.cover,
    //                               image: NetworkImage(smallcon[index].image)),
    //                           shape: BoxShape.circle),
    //                     ),
    //                     SizedBox(
    //                       height: screenSize.height * 0.015,
    //                     ),
    //                     Text(
    //                       smallcon[index].name,
    //                       style: const TextStyle(
    //                         color: Colors.black,
    //                         //fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       }),
    //     );
  }
}

class SearchBoxDaftarProduk extends StatelessWidget {
  const SearchBoxDaftarProduk({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: ScreenUtil().setHeight(100),
          width: ScreenUtil().setWidth(351),
          child: TextFormField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: "Cari produk",
              hintStyle: const TextStyle(color: Colors.black54),
              fillColor: Colors.white70,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
