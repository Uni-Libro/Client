import 'package:uni_libro/models/book_model.dart';

class CartModel {
  List<BookModel>? books;
  int? totalPrice;
  int? discount;
  int? finalPrice;

  CartModel();

  CartModel.create({
    this.books,
    this.totalPrice,
    this.discount,
    this.finalPrice,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    books = (json['books'] as List)
        .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
        .toList();
    totalPrice = json['totalPrice'];
    discount = json['discount'] ?? 0;
    finalPrice = json['finalPrice'] ?? totalPrice;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = totalPrice;
    data['discount'] = discount;
    data['finalPrice'] = finalPrice;
    return data;
  }

  @override
  String toString() {
    return 'CartModel{books: $books, totalPrice: $totalPrice, discount: $discount, finalPrice: $finalPrice}';
  }
}
