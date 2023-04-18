import 'package:flutter/material.dart';
import 'package:no_banjir/add.dart';
import 'package:no_banjir/dashboard.dart';
import 'package:no_banjir/detail.dart';
import 'package:no_banjir/log.dart';
import 'package:no_banjir/login.dart';
import 'package:no_banjir/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //menghilangkan tulisan debug pada aplikasi
      debugShowCheckedModeBanner: false,

      //initial route ke login, berfungsi agar ketika 
      //masuk ke aplikasi akan langsung ke route login
      initialRoute: '/login',

      //routes berfungsi menginisiasi alamat dari semua page
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/dashboard': (context) => DashboardPage(),
        '/detail': (context) => DetailPage(),
        '/log': (context) => LogPage(),
        '/add': (context) => AddLokasiPage(),
      },
    );
  }
}
