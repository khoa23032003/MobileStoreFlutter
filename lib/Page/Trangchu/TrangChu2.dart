import 'package:doanthuchanh/Page/SanPham/ChiTiet.dart';
import 'package:doanthuchanh/Page/Trangchu/ProductCatelogy.dart';
import 'package:doanthuchanh/Page/Trangchu/sanpham.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/category.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trangchu2 extends StatefulWidget {
  const Trangchu2({Key? key}) : super(key: key);

  @override
  State<Trangchu2> createState() => _Trangchu2State();
}

class _Trangchu2State extends State<Trangchu2> {
  final DatabaseHelper _databaseService = DatabaseHelper();

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getProduct(accountId, token);
  }

  Future<List<CategoryModel>> _getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getCategory(accountId, token);
  }

  Future<void> _onSave(ProductModel pro) async {
    await _databaseService.insertProduct(
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

  Future<void> _onSavF(ProductModel pro) async {
    await _databaseService.insertProductf(
      Favourite(
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

// Hàm tìm kiếm sản phẩm

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 139, 198, 250),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Minh Khoa Mobile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/ip15banner.jpg'),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Danh mục sản phẩm',
                  style: AppStyles.h4.copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
          // FutureBuilder cho danh mục
          FutureBuilder<List<CategoryModel>>(
            future: _getCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                return Container(
                  height: 150, // Chiều cao cụ thể cho ListView
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final itemCategory = snapshot.data![index];
                      return DanhMuc(itemCategory, context);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No categories available'),
                );
              }
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sản phẩm',
                style: AppStyles.h4.copyWith(color: Colors.blue),
              ),
            ),
          ),
          // Hiển thị danh sách sản phẩm
          FutureBuilder<List<ProductModel>>(
            future: _getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Số cột trong lưới
                    crossAxisSpacing: 10.0, // Khoảng cách giữa các cột
                    mainAxisSpacing: 10.0, // Khoảng cách giữa các hàng
                    childAspectRatio: 0.7, // Tỉ lệ khung hình của các mục
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final itemProduct = snapshot.data![index];
                    return SanPhamWidget(pro: itemProduct);
                  },
                );
              } else {
                return const Center(
                  child: Text('No products available'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget DanhMuc(CategoryModel cate, BuildContext build) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          build,
          MaterialPageRoute(
            builder: (context) => ProductCategory(
                categoryId: cate.id.toString()), // Chuyển đổi id thành chuỗi
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(cate.imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              cate.name,
              style: AppStyles.h5.copyWith(
                  color: Color.fromARGB(255, 42, 109, 163),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
