import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/author_model.dart';
import '../models/book_model.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import 'local_api.dart';
import 'localization/strs.dart';

class API {
  static final API _instance = API._initialize();

  API._initialize();

  factory API([String? token]) {
    token != null ? _instance.token = token : null;
    return _instance;
  }

  final String _apiUrl = 'http://5.161.68.41:12345';
  final Map<String, String> _headers = {
    'content-Type': 'application/json',
    'accept': 'application/json',
    'authorization': '',
  };

  String? _token;
  String? get token => _token;

  set token(String? token) {
    _token = token;
    _headers['authorization'] = 'Bearer $token';
  }

  Future<bool> loginOTP(UserModel user) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/otp/send'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [String] Session's Token
  Future<String> signIn(UserModel user) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/login'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode == 200) {
      token = (jsonDecode(res.body) as Map<String, dynamic>)['data']['token'];
      return token!;
    } else if (res.statusCode.toString().startsWith('4')) {
      throw Exception(Strs.signInError);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<String> validateOTPCode(UserModel user, String otp) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/otp/validate'),
      headers: _headers,
      body: jsonEncode({
        'phone': user.phone,
        'otp': int.parse(otp),
      }),
    );

    if (res.statusCode == 200) {
      return token =
          (jsonDecode(res.body) as Map<String, dynamic>)['data']['token'];
    } else if (res.statusCode.toString().startsWith('4')) {
      throw Exception(Strs.otpCodeError);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [bool] isValid Token
  Future<bool> validate() async {
    if (token == null) return false;

    final res = await http.post(
      Uri.parse('$_apiUrl/validate'),
      headers: _headers,
    );

    if (res.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  /// => [bool] isSignedOut
  Future<bool> signOut() async {
    if (token == null) return false;

    final res = await http.post(
      Uri.parse('$_apiUrl/logout'),
      headers: _headers,
    );

    token = null;

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// => [UserModel] currentUserProfile
  Future<UserModel> getProfile() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/profile'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(
          (jsonDecode(res.body) as Map<String, dynamic>)['data']);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<UserModel> updatePassword(UserModel user) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/update-password'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(
          (jsonDecode(res.body) as Map<String, dynamic>)['data']);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<List<BookModel>> getUserBooks() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/user-books'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return ((jsonDecode(res.body) as Map<String, dynamic>)['data'] as List)
          .map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [BookModel] get all books
  Future<List<BookModel>> getBooks() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/books'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return ((jsonDecode(res.body) as Map<String, dynamic>)['data'] as List)
          .map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [CategoryModel] get all books
  Future<List<CategoryModel>> getCategories() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/categories'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return ((jsonDecode(res.body) as Map<String, dynamic>)['data'] as List)
          .map<CategoryModel>(
              (categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [AuthorModel] get all books
  Future<List<AuthorModel>> getAuthors() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/authors'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      return ((jsonDecode(res.body) as Map<String, dynamic>)['data'] as List)
          .map<AuthorModel>((authorJson) => AuthorModel.fromJson(authorJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<bool> addBookmark(int bookId) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/bookmarks'),
      headers: _headers,
      body: jsonEncode({'bookId': bookId}),
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return true;
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<bool> removeBookmark(int bookId) async {
    final res = await http.delete(
      Uri.parse('$_apiUrl/bookmarks'),
      headers: _headers,
      body: jsonEncode({'bookId': bookId}),
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return true;
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<List<BookModel>> getBookmarks() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/bookmarks'),
      headers: _headers,
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return ((jsonDecode(res.body) as Map<String, dynamic>)['data'] as List)
          .map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> addToCart(int bookId) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/cart'),
      headers: _headers,
      body: jsonEncode({'bookId': bookId}),
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return true;
    } else if (res.body.contains('Valid')) {
      throw Exception(Strs.duplicateBook);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<bool> removeFromCart(int bookId) async {
    final res = await http.delete(
      Uri.parse('$_apiUrl/cart'),
      headers: _headers,
      body: jsonEncode({'bookId': bookId}),
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return true;
    } else {
      throw Exception(Strs.serverError);
    }
  }

  Future<CartModel> getCart() async {
    final res = await http.get(
      Uri.parse('$_apiUrl/cart'),
      headers: _headers,
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return CartModel.fromJson(
          (jsonDecode(res.body) as Map<String, dynamic>)['data']);
    } else {
      return CartModel();
    }
  }

  Future<CartModel> applyVoucherToCart(String voucherCode) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/voucher/apply'),
      headers: _headers,
      body: jsonEncode({'voucherCode': voucherCode}),
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return CartModel.fromJson(
          (jsonDecode(res.body) as Map<String, dynamic>)['data']);
    } else {
      throw Exception(Strs.invalidVoucherCode);
    }
  }

  Future<bool> payment(String voucherCode) async {
    final res = await http.post(
      Uri.parse('$_apiUrl/payment'),
      headers: _headers,
      body: jsonEncode({'voucherCode': voucherCode}),
    );

    if ([200, 201, 204].contains(res.statusCode)) {
      return true;
    } else if ([501].contains(res.statusCode)) {
      throw Exception('nim');
    } else {
      throw Exception(Strs.invalidVoucherCode);
    }
  }

  Future<List<BookModel>> searchBook(String search) async {
    return LocalAPI()
        .currentUsersBooks
        .where((book) => book.toString().contains(search))
        .toList();
    // final res = await http.get(
    //   Uri.parse('$_apiUrl/bookmarks'),
    //   headers: _headers,
    // );

    // if ([200, 201, 204].contains(res.statusCode)) {
    //   return ((jsonDecode(res.body) as Map<String, dynamic>)['data'] as List)
    //       .map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
    //       .toList();
    // } else {
    //   return [];
    // }
  }
}
