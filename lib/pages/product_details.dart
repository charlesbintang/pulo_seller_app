import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulo_seller_app/pages/dashboard.dart';

import '../global/global_var.dart';
import '../models/seller_products.dart';
import '../utils/color_resources.dart';
import '../utils/constants.dart';

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
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  String selectedCategory = '';
  String selectedCategoryBefore = '';
  String productImage = "";
  final List<String> categories = [
    'food',
    'mart',
    'pasar',
    'rental',
  ];

  void updateData(
    String productName,
    String productPrice,
    String productDescription,
    String productStock,
    String selectedCategory,
    String productImage,
  ) {
    DatabaseReference productRefKey = FirebaseDatabase.instance
        .ref()
        .child("sellerItems")
        .child(userID)
        .child(selectedCategory);

    final editData = {
      "productName": productName,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "productStock": productStock,
      "productCategory": selectedCategory,
      "productImage": productImage,
    };

    productRefKey
        .child(widget.sellerProductsDetails.productId)
        .update(editData)
        .then((value) {
      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      stockController.clear();
      setState(() {
        selectedCategory = '';
        productImage = '';
        sellerProducts.clear();
      });
      print("berhasil");
    });
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    // Get the reference to storage root
    // We create the image folder first and insider folder we upload the image
    Reference referenceRoot = FirebaseStorage.instance.ref().child("Images");

    // we have creata reference for the image to be stored
    Reference referenceImageaToUpload = referenceRoot.child(fileName);

    try {
      await referenceImageaToUpload.putFile(File(returnedImage.path));

      // We have successfully upload the image now
      // make this upload image link in firebase database

      productImage = await referenceImageaToUpload.getDownloadURL();
      print(productImage);
    } catch (error) {
      //some error
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.sellerProductsDetails.productName;
    priceController.text = widget.sellerProductsDetails.productPrice;
    descriptionController.text =
        widget.sellerProductsDetails.productDescription;
    stockController.text = widget.sellerProductsDetails.productStock;
    selectedCategory = widget.sellerProductsDetails.productCategory;
    productImage = widget.sellerProductsDetails.productImage;
  }

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
                    left: -5,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: BackButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Dashboard(),
                            ),
                          ),
                          color: ColorResources.white,
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Constants.primaryColor)),
                        )),
                  ),
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
                      style: const TextStyle(
                          fontSize: 21.5,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.black),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(3),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.sellerProductsDetails.productPrice,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: ColorResources.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Text(
                      widget.sellerProductsDetails.productDescription,
                      style: const TextStyle(
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
                          onPressed: () {
                            updateProduct(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Constants.primaryColor)),
                          child: const Text(
                            "Update",
                            style: TextStyle(color: ColorResources.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            deleteProduct(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(ColorResources.red),
                          ),
                          child: const Text(
                            "Remove",
                            style: TextStyle(color: ColorResources.white),
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

  Future<dynamic> deleteProduct(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Remove This Product',
        ),
        content: const Text("Are you sure to remove this product?"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(ColorResources.green)),
            child: const Text(
              'No',
              style: TextStyle(color: ColorResources.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              DatabaseReference productRef = FirebaseDatabase.instance
                  .ref()
                  .child("sellerItems")
                  .child(userID)
                  .child(widget.sellerProductsDetails.productCategory)
                  .child(widget.sellerProductsDetails.productId);
              productRef.remove().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Dashboard()));
              });
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ColorResources.red)),
            child: const Text(
              'Yes',
              style: TextStyle(color: ColorResources.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> updateProduct(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Update This Product',
        ),
        content: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stok'),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  productImage = "";
                });

                pickImageFromGallery();
              },
              child: const Text('Unggah Gambar Produk'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ColorResources.red)),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorResources.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (productImage.isNotEmpty) {
                updateData(
                  nameController.text,
                  priceController.text,
                  descriptionController.text,
                  stockController.text,
                  selectedCategory,
                  productImage,
                );
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Dashboard()));
              }
            },
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(ColorResources.green)),
            child: const Text(
              'Save',
              style: TextStyle(color: ColorResources.white),
            ),
          ),
        ],
      ),
    );
  }
}
