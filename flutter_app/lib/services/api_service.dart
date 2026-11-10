import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import 'dart:io';

class ApiService {
  static const String baseURL = "http://127.0.0.1:8000/api/";

  Future<List<Product>> getProducts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    final response = await http.get(Uri.parse("${baseURL}products"), headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("gagal ambil data");
    }
  }

  Future<bool> storeProduct(
    Product product,
    File? image,
  ) async {
    // final response = await http.post(Uri.parse("${baseURL}products"), body: {
    //   "nama": product.nama,
    //   "harga": product.harga.toString(),
    //   "stok": product.stok.toString(),
    //   "deskripsi": product.deskripsi,

    // });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${baseURL}products"),
    );
    request.headers.addAll(
        {"Authorization": "Bearer $token", "Accept": "application/json"});
    request.fields["nama"] = product.nama;
    request.fields["harga"] = product.harga.toString();
    request.fields["stok"] = product.stok.toString();
    request.fields["deskripsi"] = product.deskripsi;
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("gambar", image.path),
      );
    }
    var response = await request.send();
    return response.statusCode == 201;
  }

  Future<bool> updateProduct(
    Product product,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    final response =
        await http.put(Uri.parse("${baseURL}products/${product.id}"), headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json"
    }, body: {
      "nama": product.nama,
      "harga": product.harga.toString(),
      "stok": product.stok.toString(),
      "deskripsi": product.deskripsi,
    });
    return response.statusCode == 200;
  }

  Future<bool> deleteProduct(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    try {
      final response = await http.delete(
        Uri.parse("${baseURL}products/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      // ✅ Menerima status 200, 204, dan semua status 2xx lainnya sebagai BERHASIL
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print("Error deleteProduct: $e");
      return false;
    }
  }

  // Future<bool> deleteProduct(int id) async {
  //   final response = await http.delete(Uri.parse("${baseURL}products/$id"),);
  //       return response.statusCode==200;
  // }

  Future<String?> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${baseURL}login"),
      body: {
        "email": email,
        "password": password,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    }
    //tambahan
      return null; 
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    await http.post(
      Uri.parse("${baseURL}logout"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorrization": "Bearer $token",
      },
    );
    await pref.remove("token");
  }
}
