import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulo_seller_app/global/global_var.dart';
import 'package:pulo_seller_app/models/seller_products.dart';

import '../utils/color_resources.dart';
import '../utils/light_themes.dart';

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
  DatabaseReference mart = FirebaseDatabase.instance
      .ref()
      .child("sellerItems")
      .child(userID)
      .child("mart");
  DatabaseReference pasar = FirebaseDatabase.instance
      .ref()
      .child("sellerItems")
      .child(userID)
      .child("pasar");
  DatabaseReference rental = FirebaseDatabase.instance
      .ref()
      .child("sellerItems")
      .child(userID)
      .child("rental");

  void getDataOnce() async {
    DataSnapshot foodSnapshot = await food.get();
    DataSnapshot martSnapshot = await mart.get();
    DataSnapshot pasarSnapshot = await pasar.get();
    DataSnapshot rentalSnapshot = await rental.get();
    if (foodSnapshot.exists) {
      Map<dynamic, dynamic> foodItems = foodSnapshot.value as Map;
      print(foodItems);
      foodItems.forEach((foodItemKey, foodItemData) {
        sellerProducts.add(
          SellerProducts(
              productId: foodItemKey.toString(),
              productCategory: foodItemData["productCategory"].toString(),
              productDescription: foodItemData["productDescription"].toString(),
              productImage: foodItemData["productImage"].toString(),
              productName: foodItemData["productName"].toString(),
              productPrice: foodItemData["productPrice"].toString()),
        );
        print(foodItemKey);
        print(foodItemData["productCategory"]);
        print(foodItemData["productDescription"]);
        print(foodItemData["productImage"]);
        print(foodItemData["productName"]);
        print(foodItemData["productPrice"]);
      });
    }
    if (martSnapshot.exists) {
      Map<dynamic, dynamic> martItems = martSnapshot.value as Map;
      martItems.forEach((martItemKey, martItemData) {
        sellerProducts.add(
          SellerProducts(
              productId: martItemKey.toString(),
              productCategory: martItemData["productCategory"],
              productDescription: martItemData["productDescription"],
              productImage: martItemData["productImage"],
              productName: martItemData["productName"],
              productPrice: martItemData["productPrice"]),
        );
        // print(martItemKey.toString());
        // print(martItems["productCategory"]);
        // print(martItems["productDescription"]);
        // print(martItems["productImage"]);
        // print(martItems["productName"]);
        // print(martItems["productPrice"]);
      });
    }
    if (pasarSnapshot.exists) {
      Map<dynamic, dynamic> pasarItems = pasarSnapshot.value as Map;
      pasarItems.forEach((pasarItemKey, pasarItemData) {
        sellerProducts.add(
          SellerProducts(
              productId: pasarItemKey.toString(),
              productCategory: pasarItemData["productCategory"],
              productDescription: pasarItemData["productDescription"],
              productImage: pasarItemData["productImage"],
              productName: pasarItemData["productName"],
              productPrice: pasarItemData["productPrice"]),
        );
        // print(pasarItemKey.toString());
        // print(pasarItems["productCategory"]);
        // print(pasarItems["productDescription"]);
        // print(pasarItems["productImage"]);
        // print(pasarItems["productName"]);
        // print(pasarItems["productPrice"]);
      });
    }
    if (rentalSnapshot.exists) {
      Map<dynamic, dynamic> rentalItems = rentalSnapshot.value as Map;
      rentalItems.forEach((rentalItemKey, rentalItemData) {
        sellerProducts.add(
          SellerProducts(
              productId: rentalItemKey.toString(),
              productCategory: rentalItemData["productCategory"],
              productDescription: rentalItemData["productDescription"],
              productImage: rentalItemData["productImage"],
              productName: rentalItemData["productName"],
              productPrice: rentalItemData["productPrice"]),
        );
        // print(rentalItemKey.toString());
        // print(rentalItems["productCategory"]);
        // print(rentalItems["productDescription"]);
        // print(rentalItems["productImage"]);
        // print(rentalItems["productName"]);
        // print(rentalItems["productPrice"]);
      });
    }
    setState(() {});
  }

  final List<String> categories = [
    'food',
    'mart',
    'pasar',
    'rental',
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    if (sellerProducts.isEmpty) {
      setState(() {
        getDataOnce();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            // const SearchBoxDaftarProduk(),
            SizedBox(
              height: ScreenUtil().setHeight(50),
              child: ListView.builder(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterChip(
                      label: Text(categories[index]),
                      selected: selectedCategories.contains(categories[index]),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(categories[index]);
                          } else {
                            selectedCategories.remove(categories[index]);
                          }
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, ScreenUtil().setHeight(6.5), 0, ScreenUtil().setHeight(5)),
              child: SizedBox(
                height: ScreenUtil().setHeight(569.4),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget content() {
    final filterSellerProducts = sellerProducts.where((product) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(product.productCategory);
    }).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: filterSellerProducts.length,
      itemBuilder: ((context, index) {
        final product = filterSellerProducts[index];
        return Padding(
          padding: const EdgeInsets.all(7.0),
          child: Stack(
            children: [
              InkWell(
                onTap: (() {}),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ColorResources.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0.8,
                        color: blue1,
                        offset: const Offset(0.0, 0.5),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: ScreenUtil().setWidth(100),
                        width: ScreenUtil().setWidth(100),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(product.productImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: TextStyle(
                                  color: blue1,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(5),
                            ),
                            Text(
                              product.productPrice,
                              style: const TextStyle(
                                  fontSize: 18.5,
                                  color: ColorResources.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              product.productDescription,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
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
          height: ScreenUtil().setHeight(50),
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
