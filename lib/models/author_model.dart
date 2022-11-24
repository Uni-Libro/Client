class AuthorModel {
  String? name;
  String? imageUrl;
  String? description;

  AuthorModel();

  AuthorModel.create({
    this.name,
    this.imageUrl,
    this.description,
  });

  AuthorModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
    description = json['description'];
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
