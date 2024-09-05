import 'package:doanthuchanh/Page/cart/ThanhCong.dart';
import 'package:doanthuchanh/layout/homePage.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Cart>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Giỏ hàng trống"));
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
          BottomNav()
        ],
      ),
    );
  }

  Widget _buildProduct(Cart pro) {
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
                  width: 100, // Cập nhật width để hiển thị hình ảnh
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
                    Text('Count: ' + pro.count.toString()),
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
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  DatabaseHelper().minus(pro);
                                });
                              },
                              icon: Icon(
                                Icons.remove,
                                color: Colors.yellow.shade800,
                              ),
                            ),
                            Text(
                              pro.count.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  DatabaseHelper().add(pro);
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.yellow.shade800,
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

  Widget BottomNav() {
    return Column(
      children: [
        Container(
          color: AppColors.primaryColor,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text('Mã giảm giá'),
                  ],
                ),
                Text('chọn mã giảm giá'),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.primaryColor,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color of the button
                        borderRadius:
                            BorderRadius.circular(25.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2), // Shadow color
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //primary: Colors
                          //.transparent, // Transparent background to show Container's background
                          shadowColor:
                              Colors.transparent, // Remove default shadow
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25), // Match Container's border radius
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          List<Cart> temp = await _databaseHelper.products();
                          await APIRepository().addBill(
                              temp, pref.getString('token').toString());
                          _databaseHelper.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Thanhcong()),
                          );
                        },
                        child: const Text(
                          'Đặt hàng',
                          style: TextStyle(
                              color: Colors.black, fontSize: 16 // Text color
                              ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
