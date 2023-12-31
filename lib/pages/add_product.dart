import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

  // Daftar kategori yang dapat dipilih
  final List<String> categories = [
    'food',
    'mart',
    'pasar',
    'rental',
  ];

  void saveData() {
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
      "productImage":
          "https://img.freepik.com/free-vector/vector-icon-illustration-white-carton-box-mockup_134830-1994.jpg",
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
      selectedCategory = ''; // Setel kategori kembali ke nilai awal
    });
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
            SizedBox(height: 10),
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
            SizedBox(height: 20),
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
