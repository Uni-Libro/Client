import 'book_model.dart';

class CategoryModel {
  int? id;
  String? name;
  List<BookModel>? books;

  CategoryModel();

  CategoryModel.create({
    this.id,
    this.name,
    this.books,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
