import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pulo_seller_app/pages/add_product.dart';

import '../global/global_var.dart';
import '../models/seller_products.dart';
import '../utils/color_resources.dart';
import '../utils/light_themes.dart';
import 'product_details.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    super.key,
  });
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  DatabaseReference items =
      FirebaseDatabase.instance.ref().child("sellerItems");

  void getDataOnce() async {
    DataSnapshot itemsSnapshot =
        await items.orderByChild("sellerId").equalTo(userID).get();

    if (itemsSnapshot.exists) {
      Map<dynamic, dynamic> itemsProduct = itemsSnapshot.value as Map;
      itemsProduct.forEach((itemsKey, itemsData) {
        sellerProducts.add(SellerProducts(
          productId: itemsKey,
          sellerId: itemsData["sellerId"],
          productCategory: itemsData["productCategory"],
          productDescription: itemsData["productDescription"],
          productImage: itemsData["productImage"],
          productName: itemsData["productName"],
          productPrice: itemsData["productPrice"],
          productStock: itemsData["productStock"],
        ));
      });
    }
    setState(() {});
  }

  final List<String> categories = [
    'food',
    'pasar',
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorResources.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProduct(),
              ),
            ),
            icon: const Icon(Icons.add),
          )
        ],
        title: const Text("Daftar Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
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
                      side: BorderSide(
                        color: blue1,
                        width: 0.8,
                      ),
                      selectedShadowColor: blue1,
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
                child: content(),
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
                onTap: (() => Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                              sellerProductsDetails: product,
                            )))),
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
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(product.productPrice),
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
