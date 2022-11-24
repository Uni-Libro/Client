import 'dart:math';

import '../models/author_model.dart';
import '../models/book_model.dart';

class MockData {
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  String getAvatar() {
    return 'https://picsum.photos/${Random().nextInt(10) + 40}';
  }

  List<BookModel> getMyBooks() {
    return [];
    // return List.generate(
    //   10,
    //   (i) => BookModel(
    //     '‌Book ${i + 1}',
    //     'Author ${i + 1}',
    //     'https://picsum.photos/${i + 1 + 150}',
    //     'This is th description of book 4 ' * 5,
    //   ),
    // )..shuffle();
  }

  List<BookModel> getBooks() {
    return [];
    // return List.generate(
    //   10,
    //   (i) => BookModel(
    //     "Book ${i + 1}",
    //     "Author ${i + 1}",
    //     'https://picsum.photos/${i + 1 + 150}',
    //   ),
    // )..shuffle();
  }

  List<AuthorModel> getAuthors() {
    return [];
    // return List.generate(
    //   10,
    //   (i) => AuthorModel(
    //     "Author ${i + 1}",
    //     'https://picsum.photos/${i + 1 + 50}',
    //   ),
    // )..shuffle();
  }
}

//  'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg';