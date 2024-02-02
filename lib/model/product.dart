import 'dart:convert';
/// _id : "65ba93766096740150c540b4"
/// ProductName : "Hand Bag"
/// ProductCode : "102"
/// Img : "https://static-01.daraz.com.bd/p/3fa1f7319d65ca8b138acc29f6a15b34.jpg_200x200q80-product.jpg_.webp"
/// UnitPrice : "50000"
/// Qty : "1 psc"
/// TotalPrice : "50000"
/// CreatedDate : "2024-01-24T09:34:55.480Z"

class Product {
  Product({
      this.id, 
      this.productName, 
      this.productCode, 
      this.img, 
      this.unitPrice, 
      this.qty, 
      this.totalPrice, 
      this.createdDate,});

  Product.fromJson(dynamic json) {
    id = json['_id'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    img = json['Img'];
    unitPrice = json['UnitPrice'];
    qty = json['Qty'];
    totalPrice = json['TotalPrice'];
    createdDate = json['CreatedDate'];
  }
  String? id;
  String? productName;
  String? productCode;
  String? img;
  String? unitPrice;
  String? qty;
  String? totalPrice;
  String? createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['ProductName'] = productName;
    map['ProductCode'] = productCode;
    map['Img'] = img;
    map['UnitPrice'] = unitPrice;
    map['Qty'] = qty;
    map['TotalPrice'] = totalPrice;
    map['CreatedDate'] = createdDate;
    return map;
  }

}