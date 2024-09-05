import 'dart:convert';

class Favourite {
  int productID;
  String name;
  dynamic price;
  String img;
  String des;
  int count;
  //constructor
  Favourite(
      {required this.name,
      required this.price,
      required this.img,
      required this.des,
      required this.count,
      required this.productID});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'img': img,
      'des': des,
      'count': count,
      'productID': productID
    };
  }

  factory Favourite.fromMap(Map<String, dynamic> map) {
    return Favourite(
        productID: map['productID'] ?? 0,
        name: map['name'] ?? '',
        price: map['price'] ?? '',
        img: map['img'] ?? '',
        des: map['des'] ?? '',
        count: map['count'] ?? 1);
  }

  String toJson() => json.encode(toMap());

  factory Favourite.fromJson(String source) =>
      Favourite.fromMap(json.decode(source));

  @override
  String toString() =>
      'Product(productID: $productID, name: $name, price: $price, img: $img, des: $des, count: $count)';
}
