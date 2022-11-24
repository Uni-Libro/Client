import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/author_model.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../utils/log.dart';

class LocalAPI {
  static late final LocalAPI _instance;

  LocalAPI._initialize(this._shPref, this._secStor)
      //   : _isFirstRun = false,
      //     _isShowAnimation = true,
      //     _themeMode = 'light',
      //     _language = 'english';
      : _isFirstRun = _shPref.getBool('isFirstRun') ?? true,
        _isShowAnimation = _shPref.getBool('isShowAnimation') ?? true,
        _themeMode = _shPref.getString('themeMode') ?? 'light',
        _language = _shPref.getString('language') ?? 'persian',
        _currentUserProfile = UserModel().obs,
        _currentUsersBooks = <BookModel>[].obs,
        _categories = <CategoryModel>[].obs,
        _authors = <AuthorModel>[].obs;

  factory LocalAPI([SharedPreferences? shPref, FlutterSecureStorage? secStor]) {
    if (shPref != null && secStor != null) {
      _instance = LocalAPI._initialize(shPref, secStor);
    }
    return _instance;
  }

  final SharedPreferences _shPref;
  final FlutterSecureStorage _secStor;

  Rx<UserModel> _currentUserProfile;
  RxList<BookModel> _currentUsersBooks;
  RxList<CategoryModel> _categories;
  RxList<AuthorModel> _authors;

  bool _isFirstRun;
  bool _isShowAnimation;
  String _themeMode;
  String _language;

  bool get isFirstRun => _isFirstRun;
  bool get isShowAnimation => _isShowAnimation;
  String get themeMode => _themeMode;
  String get language => _language;

  UserModel get currentUserProfile => _currentUserProfile.value;
  set currentUserProfile(UserModel user) => _currentUserProfile.value = user;

  List<BookModel> get currentUsersBooks => _currentUsersBooks;
  set currentUsersBooks(List<BookModel> books) =>
      _currentUsersBooks.value = books;

  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> categories) =>
      _categories.value = categories;

  List<AuthorModel> get authors => _authors;
  set authors(List<AuthorModel> authors) => _authors.value = authors;

  set isFirstRun(bool value) {
    _isFirstRun = value;
    _shPref.setBool('isFirstRun', _isFirstRun);

    logging('Local API -> isFirstRun => $_isFirstRun');
  }

  set isShowAnimation(bool value) {
    _isShowAnimation = value;
    _shPref.setBool('isShowAnimation', _isShowAnimation);

    logging('Local API -> isShowAnimation => $_isShowAnimation');
  }

  set themeMode(String value) {
    _themeMode = value;
    _shPref.setString('themeMode', _themeMode);

    logging('Local API -> themeMode => $_themeMode');
  }

  set language(String value) {
    _language = value;
    _shPref.setString('language', _language);

    logging('Local API -> language => $_language');
  }

  Future<void> setToken(String? newToken) async {
    await _secStor.write(key: 'token', value: newToken);

    logging('Local API -> save token to secure storage');
  }

  Future<String?> getToken() async {
    final token = await _secStor.read(key: 'token');

    logging('Local API -> read token to secure storage');

    return token;
  }

  Future<void> clear() async {
    await clearShPref();
    await clearSecStor();
  }

  Future<void> clearShPref() async {
    await _shPref.clear();

    logging('Local API -> clear ShPref');
  }

  Future<void> clearSecStor() async {
    await _secStor.deleteAll();

    logging('Local API -> clear SecStor');
  }
}
