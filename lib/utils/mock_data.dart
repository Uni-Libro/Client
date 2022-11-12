import 'dart:math';

import '../widgets/authors_view.dart/authors_view.dart';
import '../widgets/books_view.dart/books_view.dart';
import '../widgets/my_books_widget/my_books_content.dart';

class MockData {
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  String getAvatar() {
    return 'https://picsum.photos/${Random().nextInt(10) + 40}';
  }

  List<MyBookItemDelegate> getMyBooks() {
    return List.generate(
      10,
      (i) => MyBookItemDelegate(
        '‌Book ${i + 1}',
        'Author ${i + 1}',
        'https://picsum.photos/${i + 1 + 150}',
        'This is th description of book 4 ' * 5,
      ),
    )..shuffle();
  }

  List<BookContentDelegate> getBooks() {
    return List.generate(
      10,
      (i) => BookContentDelegate(
        "Book ${i + 1}",
        "Author ${i + 1}",
        'https://picsum.photos/${i + 1 + 150}',
      ),
    )..shuffle();
  }

  List<AuthorContentDelegate> getAuthors() {
    return List.generate(
      10,
      (i) => AuthorContentDelegate(
        "Author ${i + 1}",
        'https://picsum.photos/${i + 1 + 50}',
      ),
    )..shuffle();
  }
}

//  'https://iranbanou.com/wp-content/uploads/2020/11/New-folder20iranbanou.com111619.jpg';