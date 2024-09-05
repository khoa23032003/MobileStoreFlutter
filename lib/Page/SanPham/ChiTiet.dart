import 'package:doanthuchanh/model/product.dart';
import 'package:flutter/material.dart';

class Chitiet extends StatefulWidget {
  final ProductModel sp;

  Chitiet({Key? key, required this.sp}) : super(key: key);

  @override
  State<Chitiet> createState() => _ChitietState();
}

class _ChitietState extends State<Chitiet> {
  late ProductModel sps;
  bool isFavorite = false; // Trạng thái yêu thích

  @override
  void initState() {
    super.initState();
    sps = widget.sp;
  }

  // Hàm thay đổi trạng thái yêu thích
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  // Hàm xử lý khi người dùng nhấn nút "Thêm vào giỏ hàng"
  void addToCart() {
    // Thêm logic xử lý thêm sản phẩm vào giỏ hàng ở đây
    // Ví dụ:
    print('Đã thêm sản phẩm ${sps.name} vào giỏ hàng.');
    // Hiển thị thông báo hoặc cập nhật trạng thái giỏ hàng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 139, 198, 250),
        title: Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: CTSP(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addToCart,
        icon: Icon(Icons.shopping_cart),
        label: Text('Thêm vào giỏ hàng'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget CTSP() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                sps.imageUrl,
                height: 300,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${sps.price}',
                style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 247, 69, 69),
                    fontWeight: FontWeight.bold),
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Cam kết giá thị trường'),
                  ))
            ],
          ),
          Text(
            sps.name,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 98, 177)),
          ),
          SizedBox(height: 8),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 238, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.25), // Thêm màu và độ mờ cho BoxShadow
                  offset: Offset(2, 0),
                  blurRadius: 4.0, // Thêm bán kính mờ để có hiệu ứng tốt hơn
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Đảm bảo căn chỉnh text bên trái
                  children: [
                    Text(
                      'Mô tả sản phẩm :',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      sps.description,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
