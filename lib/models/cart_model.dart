import 'package:uni_libro/models/book_model.dart';

class CartModel {
  List<BookModel>? books;
  int? totalPrice;
  int? discount;

  CartModel();

  CartModel.create({
    this.books,
    this.totalPrice,
    this.discount,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    books = (json['books'] as List)
        .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
        .toList();
    totalPrice = json['totalPrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = totalPrice;
    data['discount'] = discount;
    return data;
  }

  @override
  String toString() {
    return 'CartModel{books: $books, totalPrice: $totalPrice, discount: $discount}';
  }
}
