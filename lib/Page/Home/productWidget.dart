import 'package:doanthuchanh/Page/Product/detail.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/material.dart';

class SanPhamWidget extends StatefulWidget {
  final ProductModel pro;
  const SanPhamWidget({Key? key, required this.pro}) : super(key: key);

  @override
  _SanPhamWidgetState createState() => _SanPhamWidgetState();
}

class _SanPhamWidgetState extends State<SanPhamWidget> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
  }

  Future<void> _checkIfFavourite() async {
    List<Favourite> favourites = await _databaseService.productsf();
    for (var fav in favourites) {
      if (fav.productID == widget.pro.id) {
        setState(() {
          isFavourite = fav.count > 0;
        });
        break;
      }
    }
  }

  Future<void> _toggleFavourite(ProductModel pro) async {
    if (isFavourite) {
      // Xóa khỏi yêu thích
      Favourite? fav = await _databaseService.getFavouriteById(pro.id);
      if (fav != null && fav.count > 1) {
        fav.count--;
        await _databaseService.updateFavourite(fav);
      } else {
        await _databaseService.deleteProductf(pro.id);
      }
    } else {
      // Thêm vào yêu thích
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
    setState(() {
      isFavourite = !isFavourite;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Chitiet(sp: widget.pro)));
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
                if (widget.pro.imageUrl != null &&
                    widget.pro.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.network(
                          widget.pro.imageUrl,
                          height: 100,
                          // width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                // Hiển thị tên sản phẩm
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.pro.name,
                        style: AppStyles.h5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 1, 34, 61)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavourite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavourite(widget.pro),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                // Hiển thị giá sản phẩm
                Text(
                  'Giá: ${widget.pro.price.toString()} VND',
                  style: AppStyles.h6.copyWith(color: Colors.red),
                ),
                SizedBox(height: 10),
                // Nút thêm vào giỏ hàng
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _onSave(widget.pro),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Thêm vào giỏ hàng',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
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
