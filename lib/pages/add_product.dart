import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulo_seller_app/pages/dashboard.dart';
import 'package:pulo_seller_app/utils/color_resources.dart';

import '../global/global_var.dart';
import '../models/seller_products.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  String selectedCategory = ''; // Menyimpan nilai kategori yang dipilih
  String productImage = "";

  // Daftar kategori yang dapat dipilih
  final List<String> categories = [
    'Makanan',
    'Pasar',
  ];

  Future<void> getUserInfo() async {
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
          });
        }
      }
    });
  }

  saveData() {
    DatabaseReference productRef =
        FirebaseDatabase.instance.ref().child("sellerItems");

    String? productRefKey = productRef.push().key;
    String productName = nameController.text;
    String productPriceText = priceController.text;
    int productPrice = int.parse(productPriceText);
    String productDescription = descriptionController.text;
    String productStockText = stockController.text;
    int productStock = int.parse(productStockText);

    if (productImage.isEmpty &&
        productStockText.isEmpty &&
        productPriceText.isEmpty &&
        productName.isEmpty &&
        productDescription.isEmpty &&
        selectedCategory.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Isi bagian yang kosong dulu ya!")));
    }

    // Simpan data ke Firebase
    productRef.push().set({
      "productId": productRefKey,
      "sellerId": userID,
      "sellerName": userName,
      "productName": productName,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "productStock": productStock,
      "productCategory": selectedCategory,
      "productImage": productImage,
    }).then((_) {
      // print("Data saved successfully");
      Navigator.pop(context);
    }).catchError((e) {
      // print(e);
    });

    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    stockController.clear();
    setState(() {
      selectedCategory = '';
      productImage = '';
    });
    sellerProducts.clear(); // Setel kategori kembali ke nilai awal
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
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: ColorResources.black,
            onPressed: () => Navigator.pop(context)),
        title: const Text("Tambah Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stok'),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            DropdownButton<String>(
              value: selectedCategory.isEmpty ? null : selectedCategory,
              hint: const Text('Pilih Kategori'),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ElevatedButton(
              onPressed: () {
                pickImageFromGallery();
              },
              child: const Text('Unggah Gambar Produk'),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ElevatedButton(
              onPressed: () {
                if (productImage.isNotEmpty) {
                  saveData();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
