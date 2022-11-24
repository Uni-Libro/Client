import 'book_model.dart';

class CategoryModel {
  String? name;
  List<BookModel>? books;

  CategoryModel();

  CategoryModel.create({
    this.name,
    this.books,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // books = (json['books'] as List)
    //     .map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
    //     .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (books != null) {
      data['books'] = books?.map((book) => book.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'CategoryModel{name: $name, books: $books}';
  }
}
