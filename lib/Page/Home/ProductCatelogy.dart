import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/Page/Trangchu/productWidget.dart';

class ProductCategory extends StatefulWidget {
  final String categoryId;

  const ProductCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  _ProductCategoryState createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _getProductsByCategory(widget.categoryId);
  }

  Future<List<ProductModel>> _getProductsByCategory(String categoryId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accountId = prefs.getString('accountID') ?? '';
      String token = prefs.getString('token') ?? '';

      List<ProductModel> allProducts =
          await APIRepository().getProduct(accountId, token);
      int maloai = int.parse(categoryId);
      List<ProductModel> filteredProducts =
          allProducts.where((product) => product.categoryId == maloai).toList();

      return filteredProducts;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products by Category'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No products available'),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemProduct = snapshot.data![index];
                return SanPhamWidget(pro: itemProduct);
              },
            );
          }
        },
      ),
    );
  }
}
