class BookModel {
  String? name;
  String? authorName;
  String? imageUrl;
  String? description;
  int? price;
  String? category;

  BookModel();

  BookModel.create({
    this.name,
    this.authorName,
    this.imageUrl,
    this.description,
    this.price,
    this.category,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    authorName = json['authorName'];
    imageUrl = json['imageUrl'];
    description = json['description'];
    price = json['price'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (authorName != null) data['authorName'] = authorName;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (category != null) data['category'] = category;
    return data;
  }

  @override
  String toString() {
    return 'BookModel{name: $name, authorName: $authorName, imageUrl: $imageUrl, description: $description, price: $price, category: $category}';
  }
}
