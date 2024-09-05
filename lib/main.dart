import 'package:doanthuchanh/Page/Trangchu/TrangChu.dart';
import 'package:doanthuchanh/Page/Trangchu/TrangChu2.dart';
import 'package:doanthuchanh/Page/auth/login.dart';

import 'package:doanthuchanh/Page/cart/cart.dart';
import 'package:doanthuchanh/layout/homePage.dart';
import 'package:doanthuchanh/model/history/history_screen.dart';

import 'package:doanthuchanh/value/app_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.primaryColor),
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
