import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../global/global_var.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Future<FirebaseApp> fapp = Firebase.initializeApp();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  String selectedCategory = ''; // Menyimpan nilai kategori yang dipilih
  String productImage = "";

  // Daftar kategori yang dapat dipilih
  final List<String> categories = [
    'food',
    'mart',
    'pasar',
    'rental',
  ];

  void saveData() async {
    DatabaseReference productRef = FirebaseDatabase.instance
        .ref()
        .child("sellerItems")
        .child(userID)
        .child(selectedCategory);

// TODO masukkan productImage

    String productName = nameController.text;
    String productPrice = priceController.text;
    String productDescription = descriptionController.text;
    String productStock = stockController.text;

    // Simpan data ke Firebase
    productRef.push().set({
      "productName": productName,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "productStock": productStock,
      "productCategory": selectedCategory,
      "productImage": productImage,
      //  TODO "productImage": ,
    }).then((_) {
      print("Data saved successfully");
    }).catchError((e) {
      print(e);
    });

    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    stockController.clear();
    setState(() {
      selectedCategory = '';
      productImage = ''; // Setel kategori kembali ke nilai awal
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Stok'),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ElevatedButton(
              onPressed: () {
                pickImageFromGallery();
              },
              child: Text('Unggah Gambar Produk'),
            ),

            SizedBox(height: ScreenUtil().setHeight(20)),
            // DropdownButton untuk kategori
            DropdownButton<String>(
              value: selectedCategory.isEmpty ? null : selectedCategory,
              hint: Text('Pilih Kategori'),
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
                saveData();
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
