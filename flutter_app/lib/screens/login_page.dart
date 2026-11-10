// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService api = ApiService();
  bool isLoding = false;

  Future<void> login() async {
    String? token =
        await api.login(emailController.text, passwordController.text);
    if (token != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("token", token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_)=> const HomePage(),
        )
        );
    }
     else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login gagal|email/password salah")
          ));
    }
  }
//kalo pake data dummy
  // void login() {
  //   if (emailController.text == "rezan@gmail.com" &&
  //       passwordController.text == "1234") {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_)=> const HomePage(),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Login gagal|email/password salah")
  //         ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(Icons.shopping_bag,
                  size: 50, color: Color.fromARGB(255, 59, 93, 243)),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Aplikasi CRUD",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: login, child: const Text("Login")),
              )
            ],
          ),
        ),
      )),
    );
  }
}
