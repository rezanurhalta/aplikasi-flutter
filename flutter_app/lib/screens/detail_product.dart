// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/edit_page.dart';
// import 'package:flutter_app/screens/home_page.dart';
import '../models/product.dart';

class DetailProduct extends StatelessWidget {
  final Product product;
  const DetailProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: product.id!,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: product.gambar==null||product.gambar!.isEmpty ?Image.asset("assets/laptop.jpg",width :double.infinity,height: 200,fit: BoxFit.cover,
)
:Image.network(  "http://127.0.0.1:8000/storage/product/${product.gambar}",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, Error, StackTrace) {
                                return Image.asset("assets/laptop.jpg",
                                    height: 200, width: 200, fit: BoxFit.cover);
                            },
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nama,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "RP ${product.harga}",
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.inventory),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          " STOK :${product.stok}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 15,
                    ),
                    const Text(
                      "Deskripsi Produk",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${product.deskripsi}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Produk"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () async{
                          final hasil=await 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPage(product: product),
                            ),
                          );
                          if (hasil==true){
                            //tambahan
                           if (context.mounted) {
          // Tutup halaman DetailProduct dan kirim sinyal 'true' ke HomePage
          Navigator.pop(context, true);
        }
      }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Kembali"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.pop(context,true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
        ),
      ),
    );
  }
}
