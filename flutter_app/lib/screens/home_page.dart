// import 'package:flutter/foundation.dart';
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/screens/add_page.dart';
import 'package:flutter_app/screens/detail_product.dart';
import 'package:flutter_app/screens/edit_page.dart';
import 'package:flutter_app/screens/login_page.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/widgets/dashboard_card.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();
  TextEditingController searchController = TextEditingController();
  List<Product> semuaproduk = [];
  List<Product> hasilpencaharian = [];
  String filterharga = "semua";
  String sorting = "Nama A-Z";

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      final data = await api.getProducts();
      if (!mounted) return;
      setState(() {
        semuaproduk = data;
        hasilpencaharian = List.from(data);
      });

      prosesdata();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengambil data:$e')));
    }
  }

  // Future<List<Product>>? futureProduk;

  // void cariProduk(String keyword) {
  //   hasilpencaharian = semuaproduk.where((Product) {
  //     return Product.nama.toLowerCase().contains(keyword.toLowerCase());
  //   }).toList();
  //   setState(() {});
  // }

  void prosesdata() {
    List<Product> data = List.from(semuaproduk);
    final keyword = searchController.text.toLowerCase().trim();

    if (keyword.isNotEmpty) {
      data = data.where((Product) {
        return Product.nama.toLowerCase().contains(keyword);
      }).toList();
    }
    // if (filterharga == "< 50000") {
    //   data = data.where((Product) {
    //     return Product.harga < 50000;
    //   }).toList();
    // }
    // if (filterharga == "50000-100000") {
    //   data = data.where((Product) {
    //     return Product.harga >= 50000 && Product.harga >= 50000;
    //   }).toList();
    // }
    // if (filterharga == "50000-100000") {
    //   data = data.where((Product) {
    //     return Product.harga > 100000;
    //   }).toList();
    // }
    if (filterharga == "< 50000") {
      data = data.where((product) => product.harga < 50000).toList();
    }
    if (filterharga == "50000-100000") {
      data = data
          .where((product) => product.harga >= 50000 && product.harga <= 100000)
          .toList();
    }
    if (filterharga == "> 100000") {
      data = data.where((product) => product.harga > 100000).toList();
    }
    if (sorting == "Nama A-Z") {
      data.sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    }
    if (sorting == "Nama Z-A") {
      data.sort((a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()));
    }
    if (sorting == "harga Tertinggi") {
      data.sort((a, b) => b.harga.compareTo(a.harga));
    }
    if (sorting == "harga terendah") {
      data.sort((a, b) => a.harga.compareTo(b.harga));
    }
    if (sorting == "stok banyak") {
      data.sort((a, b) => b.stok.compareTo(a.stok));
    }
    if (sorting == "stok sedikit") {
      data.sort((a, b) => a.stok.compareTo(b.stok));
    }

    setState(() {
      hasilpencaharian = data;
    });
  }

  void cariproduk(String keyword) {
    prosesdata();
  }

  void pilihfilterharga(String? pilihan) {
    if (pilihan == null) return;
    setState(() {
      filterharga = pilihan;
    });
    prosesdata();
  }

  void pilihsorting(String? pilihan) {
    if (pilihan == null) return;
    setState(() {
      sorting = pilihan;
    });
    prosesdata();
  }

  int totalStok() {
    return semuaproduk.fold(0, (total, item) => total + item.stok);
  }

  int totalharga() {
    return semuaproduk.fold(
        0, (total, item) => total + (item.harga * item.stok));
  }

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
    return ".$result";
  }

//  refreshData
  Future<void> refreshData() async {
    await loadProduct();
  }

// void refreshData() {
//   // setState(() {
//   //   // futureProduk = api.getProducts();
//   // });
//     loadProduct();
// }

  Future<void> hapusproduk(Product product) async {
    bool? konfirmasi = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("konfimasi"),
            content:
                Text("Apakah yakin ingin menghapus data ${product.nama} ?)"),
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
    if (konfirmasi != true) {
      return;
    }
    if (konfirmasi == true) {
      bool hasil = await api.deleteProduct(product.id!);

      if (!mounted) return;
      if (hasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil dihapus!")),
        );
        // setState(() {});
        await loadProduct();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus data.")),
        );
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Data produk "),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () async {
                  await api.logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                icon: const Icon(Icons.logout))
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPage(),
            ),
          );
          if (hasil == true) {
            refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: loadProduct,
        child: FutureBuilder(
            future: loadProduct(),
            builder: (context, snapshot) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Halo Admin",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text("selamat datang di aplikasi Crud ",
                          style: TextStyle(fontSize: 14, color: Colors.lime)),
                    ],
                  ),
                  TextField(
                    controller: searchController,
                    onChanged: (val) => prosesdata(),
                    decoration: InputDecoration(
                        hintText: "cari produk",
                        prefix: const Icon(Icons.search),
                        suffixIcon: searchController.text.isEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  prosesdata();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                      value: filterharga,
                      decoration: const InputDecoration(
                        labelText: 'Filter Harga',
                        prefixIcon: Icon(Icons.tune),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "semua", child: Text("Semua Harga")),
                        DropdownMenuItem(
                            value: "< 50000", child: Text("< Rp50.000")),
                        DropdownMenuItem(
                            value: "50000-100000",
                            child: Text("Rp50.000 - Rp100.000")),
                        DropdownMenuItem(
                            value: "> 100000", child: Text("> Rp100.000")),
                      ],
                      onChanged: pilihfilterharga),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                      value: sorting,
                      decoration: const InputDecoration(
                        labelText: 'mengurutkan berdasarkan',
                        prefixIcon: Icon(Icons.sort),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "Nama A-Z", child: Text("Ascending")),
                        DropdownMenuItem(
                            value: "Nama Z-A", child: Text("Desending")),
                        DropdownMenuItem(
                            value: "harga Tertinggi",
                            child: Text("Harga Tertinggi")),
                        DropdownMenuItem(
                            value: "Harga terendah",
                            child: Text("harga terendah")),
                        DropdownMenuItem(
                            value: "stok banyak",
                            child: Text("stok Terbanyak")),
                        DropdownMenuItem(
                            value: "stok sedikit",
                            child: Text("stok paling dikit")),
                      ],
                      onChanged: pilihsorting),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: DashboardCard(
                              title: "produk",
                              value: "${semuaproduk.length}",
                              icon: Icons.shopping_bag,
                              color: Colors.tealAccent)),
                      Expanded(
                          child: DashboardCard(
                              title: "harga",
                              value: "${totalharga()}",
                              icon: Icons.payment,
                              color: const Color.fromARGB(255, 3, 99, 51))),
                      Expanded(
                          child: DashboardCard(
                              title: "stok",
                              value: "${totalStok()}",
                              icon: Icons.shopping_bag,
                              color: const Color.fromARGB(255, 3, 83, 65)))
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(child: DashboardCard(title: "totalharga", value: formatrupiah(totalharga()), icon: Icons.payment, color: Colors.orangeAccent)),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Daftar Produk",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (hasilpencaharian.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          "produk tidak ditemukan",
                          style: TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    )
                  else
                    ...hasilpencaharian.map((Product) {
                      return ProductCard(
                        product: Product,
                        onEdit: () async {
                          final hasil = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditPage(product: Product)));
                          if (hasil == true) {
                            refreshData();
                          }
                        },
                        onDelete: () {
                          hapusproduk(
                            Product,
                          );
                        },
                        onDetail: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DetailProduct(product: Product)));
                          refreshData();
                        },
                      );
                    })
                ],
              );
            }),
      ),
    );
  }
}





  //lama
//               return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return ProductCard(
//                       product: snapshot.data![index],
//                       onEdit: () async {
//                         final hasil = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) =>
//                                     EditPage(product: snapshot.data![index])));
//                         if (hasil == true) {
//                           setState(() {});
//                         }
//                       },
//                       onDelete: () {
//                         hapusproduk(snapshot.data![index]);
//                       },

//lama
//                       onDetail: () async {
//                         final hasil = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => DetailProduct(
//                               product: snapshot.data![index]
//                             ),
//                           ),
//                         );
//                         if (hasil == true) {
//                           setState(() {});
//                         }
//                       },

//lama coba coba error

//                       // onDetail: () async {
//                       //   await Navigator.push(
//                       //       context,
//                       //       MaterialPageRoute(
//                       //           builder: (_) => DetailProduct(
//                       //               product: snapshot.data![index])));
//                       // },
//                     );
//                   });



                        // onDetail: () async {
                        //   final hasil = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => DetailProduct(
                        //         product: Product
                        //       ),
                        //     ),
                        //   );
                        //   if (hasil == true) {
                        //     refreshData();
                        //   }
                        // },
                             // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              // if (snapshot.hasError) {
              //   return ListView(
              //     physics: const AlwaysScrollableScrollPhysics(),
              //     children: [
              //       SizedBox(
              //         height: MediaQuery.of(context).size.height * 0.25,
              //       ),
              //       Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(
              //               Icons.error,
              //               color: Colors.red,
              //             ),
              //             const SizedBox(
              //               height: 5,
              //             ),
              //             const Text(
              //               "Terjadi kesalahan pada data",
              //               style: TextStyle(
              //                   fontSize: 15, fontWeight: FontWeight.bold),
              //             ),
              //             const SizedBox(
              //               height: 5,
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.symmetric(horizontal: 20),
              //               child: Text(snapshot.error.toString(),
              //                   textAlign: TextAlign.center),
              //             ),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             ElevatedButton(
              //                 onPressed: refreshData,
              //                 child: const Text("COBA LAGI"))
              //           ],
              //         ),
              //       )
              //     ],
              //   );
              // }
              

              // if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //   semuaproduk = [];
              //   hasilpencaharian = [];
               
              //   return ListView(
              //     physics: const AlwaysScrollableScrollPhysics(),
              //     children: [
              //       SizedBox(
              //         height: MediaQuery.of(context).size.height * 0.25,
              //       ),
              //       Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(
              //               Icons.inventory_2_sharp,
              //               color: Colors.orange,
              //             ),
              //             const SizedBox(
              //               height: 5,
              //             ),
              //             const Text(
              //               "belum ada produk",
              //               style: TextStyle(
              //                   fontSize: 15, fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //       )
              //     ],
              //   );
              // }
              // semuaproduk = snapshot.data!;
              // if (searchController.text.isEmpty) {
              //   hasilpencaharian = semuaproduk;
              // }