// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/models/product.dart';

class EditPage extends StatefulWidget {
  final Product product;
  const EditPage({super.key, required this.product});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();
  final deskripsiController = TextEditingController();

  final ApiService api = ApiService();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    namaController.text = widget.product.nama;
    hargaController.text = widget.product.harga.toString();
    stokController.text = widget.product.stok.toString();
    deskripsiController.text = widget.product.deskripsi;
  }

  Future<void> updatedata() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    Product product = Product(
      id: widget.product.id,
      nama: namaController.text,
      harga: int.parse(hargaController.text),
      stok: int.parse(stokController.text),
      deskripsi: deskripsiController.text,
      gambar: widget.product.gambar,
    );

    bool berhasil = await api.updateProduct(product);

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil diubah")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk gagal diubah")),
      );
    }
  }

  Future<void> konfirmasiUpdate() async {
    bool? hasil = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("konfimasi"),
            content: const Text("apakah yaki ingin mengganti data ini"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Ya"),
              ),
            ],
          );
        });
    if (hasil == true) {
      updatedata();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Page update produk",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                      onPressed: loading ? null : konfirmasiUpdate,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "update data",
                              style: TextStyle(fontSize: 16),
                            ),
                    ))
              ],
            )),
      ),
    );
  }
}
