import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatefulWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  State<MyBottomNavBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.only(bottom: 6), //tạo khoảng cách dưới
      child: GNav(
        color: Colors.blue,
        activeColor: Colors.blue[900], //khi thực hiện hành động sẽ đổi màu
        mainAxisAlignment: MainAxisAlignment.center, //cho về giữa giao diện
        tabBackgroundColor:
            Color.fromARGB(255, 203, 223, 239), //tạo màu nền của tap
        tabBorder: Border.all(color: Colors.white),
        padding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: 20), //tạo chiều cao bà chiều dọc của tab
        gap: 2, //tạo khoảng cách giữa button và chữ
        tabBorderRadius: 30, //bo tròn
        onTabChange: (value) => widget.onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Trang chủ',
          ),
          GButton(
            icon: Icons.favorite_sharp,
            text: 'Yêu thích',
          ),
          GButton(
            icon: Icons.history,
            text: 'Lịch sử',
          ),
          GButton(
            icon: Icons.admin_panel_settings_rounded,
            text: 'Admin',
          ),
        ],
      ),
    );
  }
}
