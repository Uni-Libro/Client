import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/author_model.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import 'localization/strs.dart';

class API {
  static final API _instance = API._initialize();

  API._initialize();

  factory API([String? token]) {
    token != null ? _instance._token = token : null;
    return _instance;
  }

  final String _apiUrl = 'http://5.161.68.41:12345';
  final Map<String, String> _headers = {
    'content-Type': 'application/json',
    'accept': 'application/json',
  };

  String? _token;
  String? get token => _token;

  /// => [bool] isSuccess
  Future<bool> signUp(UserModel user) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/signup'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode.toString().startsWith('4')) {
      throw Exception(Strs.signUpError);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [String] Session's Token
  Future<String> signIn(UserModel user) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/login'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      _token =
          (jsonDecode(response.body) as Map<String, dynamic>)['data']['token'];
      return _token!;
    } else if (response.statusCode.toString().startsWith('4')) {
      throw Exception(Strs.signInError);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [bool] isValid Token
  Future<bool> validate() async {
    if (_token == null) return false;

    final response = await http.post(
      Uri.parse('$_apiUrl/validate'),
      headers: {
        ..._headers,
        'authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  /// => [bool] isSignedOut
  Future<bool> signOut() async {
    if (_token == null) return false;

    final response = await http.post(
      Uri.parse('$_apiUrl/logout'),
      headers: {
        ..._headers,
        'authorization': 'Bearer $_token',
      },
    );

    _token = null;

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// => [UserModel] currentUserProfile
  Future<UserModel> getProfile() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/profile'),
      headers: {
        ..._headers,
        'authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(
          (jsonDecode(response.body) as Map<String, dynamic>)['data']);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [UserModel] updatedUser
  Future<UserModel> updateProfile(UserModel user) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/profile'),
      headers: {
        ..._headers,
        'authorization': 'Bearer $_token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(
          (jsonDecode(response.body) as Map<String, dynamic>)['data']);
    } else if (response.statusCode.toString().startsWith('4')) {
      throw Exception(Strs.signUpError);
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [BookModel] get all books
  Future<List<BookModel>> getBooks() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/books'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ((jsonDecode(response.body) as Map<String, dynamic>)['data']
              as List)
          .map<BookModel>((bookJson) => BookModel.fromJson(bookJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [CategoryModel] get all books
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/categories'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ((jsonDecode(response.body) as Map<String, dynamic>)['data']
              as List)
          .map<CategoryModel>(
              (categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }

  /// => [AuthorModel] get all books
  Future<List<AuthorModel>> getAuthors() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/authors'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ((jsonDecode(response.body) as Map<String, dynamic>)['data']
              as List)
          .map<AuthorModel>((authorJson) => AuthorModel.fromJson(authorJson))
          .toList();
    } else {
      throw Exception(Strs.serverError);
    }
  }
}
