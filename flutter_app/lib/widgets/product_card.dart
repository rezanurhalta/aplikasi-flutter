import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDetail;
  const ProductCard(
      {super.key,
      required this.product,
      required this.onEdit,
      required this.onDelete,
      required this.onDetail});
  String formatrupiah(int angka) {
    String hasil = angka.toString();
    String result = '';
    int counter = 0;
    for (int i = hasil.length - 1; i >= 0; i--) {
      result = hasil[i] + result;
      counter++;
      if (counter == 3 && i != 0) {
        result = ".$result";
        counter = 0;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onDetail,
        child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: product.gambar == null || product.gambar!.isEmpty
                          ? Image.asset("assets/laptop.jpg",
                              height: 120, width: 120, fit: BoxFit.cover)
                          : Image.network(
                              "http://127.0.0.1:8000/storage/product/${product.gambar}",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, Error, StackTrace) {
                                return Image.asset("assets/laptop.jpg",
                                    height: 200, width: 200, fit: BoxFit.cover);
                              },
                            )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  product.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Harga: RP ${formatrupiah(product.harga)}",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "stok: ${product.stok}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${product.deskripsi}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text("edit"),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text("hapus"),
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
