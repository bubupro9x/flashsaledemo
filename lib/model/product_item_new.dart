// To parse this JSON data, do
//
//     final itemProductNew = itemProductNewFromJson(jsonString);

import 'dart:convert';

ItemProductNew itemProductNewFromJson(String str) {
  final jsonData = json.decode(str);
  return ItemProductNew.fromJson(jsonData);
}

String itemProductNewToJson(ItemProductNew data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ItemProductNew {
  int status;
  String message;
  Data data;

  ItemProductNew({
    this.status,
    this.message,
    this.data,
  });

  factory ItemProductNew.fromJson(Map<String, dynamic> json) => new ItemProductNew(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<Product> products;

  Data({
    this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    products: new List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "products": new List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  int productId;
  int finalPrice;
  var image;
  String urlKey;
  var name;
  int remain;
  int price;
  int quantity;
  var productDisplay;
  var buttonText;
  int shoptype;

  Product({
    this.productId,
    this.finalPrice,
    this.image,
    this.urlKey,
    this.name,
    this.remain,
    this.price,
    this.quantity,
    this.productDisplay,
    this.buttonText,
    this.shoptype,
  });

  factory Product.fromJson(Map<String, dynamic> json) => new Product(
    productId: json["product_id"],
    finalPrice: json["final_price"],
    image: json["image"],
    urlKey: json["url_key"],
    name: json["name"],
    remain: json["remain"],
    price: json["price"],
    quantity: json["quantity"],
    productDisplay: json["product_display"],
    buttonText: json["button_text"],
    shoptype: json["shoptype"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "final_price": finalPrice,
    "image": image,
    "url_key": urlKey,
    "name": name,
    "remain": remain,
    "price": price,
    "quantity": quantity,
    "product_display": productDisplay,
    "button_text": buttonText,
    "shoptype": shoptype,
  };

}

class ProductRow {
  Product item;

  ProductRow({this.item});

  ProductRow.empty() {
    item = null;
  }
}



