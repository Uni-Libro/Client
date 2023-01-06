import 'book_model.dart';

class AuthorModel {
  int? id;
  String? name;
  String? imageUrl;
  String? description;
  List<BookModel>? books;

  AuthorModel();

  AuthorModel.create({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.books,
  });

  AuthorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    description = json['description'];
    books = (json['books'] as List?)
        ?.map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (description != null) data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return 'BookModel{name: $name, imageUrl: $imageUrl, description: $description}';
  }
}
