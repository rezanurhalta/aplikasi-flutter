// import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();
  final deskripsiController = TextEditingController();

  final ApiService api = ApiService();
  bool loading = false;
  File? image;
  final picker = ImagePicker();
  Future<void> pilihgambar() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> simpandata() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    Product product = Product(
      nama: namaController.text,
      harga: int.parse(hargaController.text),
      stok: int.parse(stokController.text),
      deskripsi: deskripsiController.text,
    );

    bool berhasil = await api.storeProduct(product,image);

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk gagal ditambahkan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Page tambah Produk",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Column(children: [
              Center(
                child: GestureDetector(
                    onTap: pilihgambar,
                    child: image == null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 99, 44, 252),
                                borderRadius: BorderRadius.circular(16)),
                            child: const Icon(
                              Icons.add_a_photo,
                              size: 60,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              image!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                          ),
                          
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                            controller: namaController,
                            decoration: const InputDecoration(
                              labelText: "nama Produk",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.shopping_bag),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "nama wajib diisi";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        //harga
                        TextFormField(
                            controller: hargaController,
                            decoration: const InputDecoration(
                              labelText: "harga Produk",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.money),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "harga wajib diisi";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        //stok
                        TextFormField(
                            controller: stokController,
                            decoration: const InputDecoration(
                              labelText: "stok Produk",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.inventory),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "stok wajib diisi";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        //deskripsi
                        TextFormField(
                            controller: deskripsiController,
                            decoration: const InputDecoration(
                              labelText: "deskripsi Produk",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.description),
                              
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "deskripsi wajib diisi";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: loading ? null : simpandata,
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "simpan data",
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ))
                      ],
                    )),
              ),
            ]))));
  }
}
