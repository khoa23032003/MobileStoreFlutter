import 'package:doanthuchanh/Page/SanPham/ChiTiet.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/category.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trangchu extends StatefulWidget {
  const Trangchu({super.key});

  @override
  State<Trangchu> createState() => _TrangchuState();
}

class _TrangchuState extends State<Trangchu> {
  final DatabaseHelper _databaseService = DatabaseHelper(); // Tạo giỏ hàng

  // Tạo hàm để lấy danh sách sản phẩm từ API
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getProduct(accountId, token);
  }

  // Tạo hàm để lấy danh sách danh mục sản phẩm từ API
  Future<List<CategoryModel>> _getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getCategory(accountId, token);
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

  Future<void> _onSavF(ProductModel pro) async {
    _databaseService.insertProductf(
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Minh Khoa Mobile'),
          Image.asset('assets/images/ip15banner.jpg'),
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
                    return SanPham(itemProduct, context);
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

  // Sản phẩm
  // Sản phẩm
  Widget SanPham(ProductModel pro, BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Chitiet(sp: pro)));
        },
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hiển thị hình ảnh sản phẩm
                if (pro.imageUrl != null && pro.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      pro.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 10),
                // Hiển thị tên sản phẩm
                Text(
                  pro.name,
                  style: AppStyles.h5.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Hiển thị giá sản phẩm
                Text(
                  'Giá: ${pro.price.toString()} VND',
                  style: AppStyles.h6.copyWith(color: Colors.red),
                ),
                SizedBox(height: 10),
                // Nút thêm vào giỏ hàng
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _onSave(pro),
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue, // Màu nền của nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _onSavF(pro),
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue, // Màu nền của nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Thêm vào yêu thích',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
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

  // Danh mục sản phẩm
  Widget DanhMuc(CategoryModel cate, BuildContext build) {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(cate.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
          ),
          Text(cate.name),
        ],
      ),
    );
  }
}
