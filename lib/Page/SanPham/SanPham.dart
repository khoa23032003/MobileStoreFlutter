import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/category.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:doanthuchanh/value/app_font.dart';

import 'ChiTiet.dart';

class TrangSanPham extends StatefulWidget {
  const TrangSanPham({Key? key}) : super(key: key);

  @override
  State<TrangSanPham> createState() => _TrangSanPhamState();
}

class _TrangSanPhamState extends State<TrangSanPham> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    try {
      var products = await APIRepository().getProduct(accountId, token);
      setState(() {
        _products = products;
        _filteredProducts = products;
      });
    } catch (ex) {
      print('Error fetching products: $ex');
    }
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _products;
      });
      return;
    }

    List<ProductModel> results = _products.where((product) {
      String name = product.name.toLowerCase();
      String searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredProducts = results;
    });
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

  Future<void> _toggleFavourite(ProductModel pro) async {
    List<Favourite> favourites = await _databaseService.productsf();
    bool isFavourite = favourites.any((fav) => fav.productID == pro.id);
    if (isFavourite) {
      Favourite? fav = await _databaseService.getFavouriteById(pro.id);
      if (fav != null && fav.count > 1) {
        fav.count--;
        await _databaseService.updateFavourite(fav);
      } else {
        await _databaseService.deleteProductf(pro.id);
      }
    } else {
      Favourite newFavourite = Favourite(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1,
      );
      await _databaseService.insertProductf(newFavourite);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'),
        backgroundColor: Color.fromARGB(255, 139, 198, 250),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _searchProducts,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final itemProduct = _filteredProducts[index];
                return ProductCard(
                  product: itemProduct,
                  onToggleFavourite: _toggleFavourite,
                  onSave: _onSave,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final Function(ProductModel) onToggleFavourite;
  final Function(ProductModel) onSave;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onToggleFavourite,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chitiet(sp: product)),
        );
      },
      child: Container(
        height: 350,
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
                if (product.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.network(
                          product.imageUrl,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppStyles.h5.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 1, 34, 61),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                          onPressed: () => onToggleFavourite(product),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Giá: ${product.price.toString()} VND',
                  style: AppStyles.h6.copyWith(color: Colors.red),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => onSave(product),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Thêm vào giỏ hàng',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
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
