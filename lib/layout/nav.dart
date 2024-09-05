import 'dart:convert';
import 'package:doanthuchanh/Page/SanPham/SanPham.dart';
import 'package:doanthuchanh/Page/Trangchu/TrangChu2.dart';

import 'package:doanthuchanh/admin/category/category_list.dart';
import 'package:doanthuchanh/admin/product/product_list.dart';
import 'package:doanthuchanh/layout/detail.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart'; // Import model user

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Future<User> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null) {
      return User.fromJson(jsonDecode(strUser));
    } else {
      return User.userEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<User>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text('Error loading user data'),
                  ),
                );
              } else {
                User user = snapshot.data ?? User.userEmpty();
                return UserAccountsDrawerHeader(
                  accountName: Text(user.fullName ?? 'N/A'),
                  accountEmail: Text(user.phoneNumber ?? 'N/A'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: user.imageURL != null && user.imageURL!.isNotEmpty
                          ? Image.network(
                              user.imageURL!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/user.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://cdn.vjshop.vn/tin-tuc/cach-chup-anh-phong-canh/cach-chup-anh-phong-canh-dep-15.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          // Trang chủ
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Trang chủ'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(body: TrangSanPham())));
            },
          ),
          // Yêu thích
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Yêu thích'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Detail()));
            },
          ),
          // Tài khoản
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Tài khoản'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Detail()));
            },
          ),
          // Quản lý loại sản phẩm
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Quản lý loại sản phẩm'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductList()));
            },
          ),
          // Quản lý sản phẩm
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Quản lý sản phẩm'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryList()));
            },
          ),
        ],
      ),
    );
  }
}
