import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Favourite>> _getProducts() async {
    return await _databaseHelper.productsf();
  }

  Future<void> _toggleFavourite(Favourite pro) async {
    if (pro.count > 1) {
      pro.count--;
      await _databaseHelper.updateFavourite(pro);
    } else {
      await _databaseHelper.deleteProductf(pro.productID);
    }
    setState(() {});
  }

  Future<void> _addToCart(Favourite pro) async {
    await _databaseHelper.insertProduct(
      Cart(
        productID: pro.productID,
        name: pro.name,
        des: pro.des,
        price: pro.price,
        img: pro.img,
        count: 1,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sản phẩm yêu thích',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Favourite>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Chưa có sản phẩm yêu thích"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final itemProduct = snapshot.data![index];
                    return _buildProduct(itemProduct);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(Favourite pro) {
    bool isFavourite = pro.count > 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  pro.img,
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pro.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          'Đổi trả 15 ngày',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Description: ' + pro.des),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          NumberFormat('#,##0').format(pro.price),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            // IconButton(
                            //   onPressed: () => _toggleFavourite(pro),
                            //   icon: Icon(
                            //     isFavourite ? Icons.favorite : Icons.favorite_border,
                            //     color: isFavourite ? Colors.red : Colors.grey,
                            //   ),
                            // ),
                            IconButton(
                              onPressed: () => _addToCart(pro),
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  DatabaseHelper().deleteProduct(pro.productID);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
