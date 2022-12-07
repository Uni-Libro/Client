import 'author_model.dart';
import 'category_model.dart';

class BookModel {
  int? id;
  String? name;
  List<AuthorModel>? authorModels;
  String? imageUrl;
  String? description;
  int? price;
  List<CategoryModel>? categoryModels;

  bool isMark = false;

  BookModel();

  BookModel.create({
    this.id,
    this.name,
    this.authorModels,
    this.imageUrl,
    this.description,
    this.price,
    this.categoryModels,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    authorModels = (json['AuthorModels'] as List)
        .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
        .toList();
    imageUrl = json['imageUrl'];
    description = json['description'];
    price = json['price'];
    categoryModels = (json['CategoryModels'] as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (authorModels != null) {
      data['authorName'] = authorModels!.map((e) => e.toJson()).toList();
    }
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (categoryModels != null) {
      data['category'] = categoryModels!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'BookModel{name: $name, authorName: $authorModels, imageUrl: $imageUrl, description: $description, price: $price, category: $categoryModels}';
  }
}
