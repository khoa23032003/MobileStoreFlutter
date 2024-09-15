import 'package:doanthuchanh/Page/Product/detail.dart';
import 'package:doanthuchanh/Page/Trangchu/TrangChu.dart';
import 'package:doanthuchanh/Page/Trangchu/homePage.dart';
import 'package:doanthuchanh/layout/bottomnav.dart';
import 'package:doanthuchanh/Page/cart/cart.dart';
import 'package:doanthuchanh/layout/detail.dart';
import 'package:doanthuchanh/Page/favourite/favourite.dart';
import 'package:doanthuchanh/admin/category/category_list.dart';
import 'package:doanthuchanh/admin/product/product_list.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/layout/nav.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/history/history_screen.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _HomepageState();
}

class _HomepageState extends State<Mainpage> {
  final DatabaseHelper _databaseService = DatabaseHelper(); // Tạo giỏ hàng
//xử lý navbottom
  final List<Widget> _page = [
    Trangchu2(),
    FavouriteScreen(),
    HistoryScreen(),
    Detail(),
  ];
  int select = 0;
  void navigaBottomBar(int index) {
    setState(() {
      select = index;
    });
  }
//xử lý navbottom

  // Tạo hàm để lấy danh sách sản phẩm từ API
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Dùng để lưu lại trạng thái đăng nhập bằng một cặp khóa giá trị
    // Dữ liệu sẽ lưu lại kể cả khi bạn đóng ứng dụng
    return await APIRepository().getProductAdmin(
      prefs.getString('accountID').toString(),
      // Lấy dữ liệu
      prefs.getString('token').toString(),
    );
    // Token là trạng thái xác minh thông tin đăng nhập
  }

  Future<void> _onSave(ProductModel pro) async {
    _databaseService.insertProduct(
      Cart(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Trang chủ',
        //   style: AppStyles.h3,
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.card_travel),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      //
      drawer: NavBar(),
      body: _page[select],
      bottomNavigationBar: MyBottomNavBar(onTabChange: navigaBottomBar),
    );
  }

  // Sản phẩm
  Widget SanPham(ProductModel pro, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chitiet(sp: pro)));
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            // Added SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://dichthuatcongchung247.com/wp-content/uploads/2022/08/google-dich.jpg',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text(
                  pro.name,
                  style: AppStyles.h5.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Text(
                //   pro.description,
                //   style: AppStyles.h4,
                // ),
                SizedBox(height: 5),
                Text(
                  'Giá: ${pro.price.toString()} VND',
                  style: AppStyles.h6.copyWith(color: Colors.red),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _onSave(pro),
                  child: Center(
                    child: Text(
                      'Thêm vào giỏ hàng',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
