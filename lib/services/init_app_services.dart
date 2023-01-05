import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/author_model.dart';
import '../models/book_model.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import 'api.dart';
import 'connection_service.dart';
import 'localization/localization_service.dart';
import 'localization/strs.dart';
import 'theme/theme_service.dart';
import 'local_api.dart';

Future<void> initAppServices() async {
  LocalAPI(
    await SharedPreferences.getInstance(),
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions:
          IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
    ),
  );
  Get.put(LocalizationService(LocalAPI().language));
  Get.put(ThemeService(ThemeMode.values.byName(LocalAPI().themeMode)));
}

Future<Map<String, dynamic>> setupServices() async {
  ConnectionService();
  API(await LocalAPI().getToken());

  final isSignIn = await API().validate();

  if (isSignIn) {
    await loadUserDataFromServer();
  }

  return {'isSignIn': isSignIn};
}

Future<void> loadUserDataFromServer() async {
  final results = await Future.wait([
    API().getProfile(),
    API().getBookmarks(),
    API().getCart(),
    loadHomeScreenDataFromServer(),
  ]);

  LocalAPI().currentUserProfile = results[0] as UserModel;
  LocalAPI().bookmarks = results[1] as List<BookModel>;
  LocalAPI().bookmarkIds = LocalAPI().bookmarks.map((e) => e.id!).toList();
  LocalAPI().cart = results[2] as CartModel;
  LocalAPI().cartItems = LocalAPI().cart.books ?? [];
}

Future<void> loadHomeScreenDataFromServer() async {
  final catagories = await API().getCategories();

  final results = await Future.wait([
    API().getUserBooks(),
    API().getAuthors(),
    API().getBooks(page: 4, limit: 8),
    API().getBooks(page: 3, limit: 8),
    ...catagories.map(
      (category) =>
          API().getBooks(page: catagories.indexOf(category) % 5, limit: 8),
    ),
  ]);
  for (var i = 4; i < results.length; i++) {
    catagories[i - 4].books = results[i] as List<BookModel>;
  }

  catagories.insertAll(0, [
    CategoryModel.create(
      name: Strs.recommended,
      books: results[2] as List<BookModel>,
    ),
    CategoryModel.create(
      name: Strs.specials,
      books: results[3] as List<BookModel>,
    ),
  ]);

  LocalAPI().categories = catagories;
  LocalAPI().currentUsersBooks = results[0] as List<BookModel>;
  LocalAPI().authors = results[1] as List<AuthorModel>;
}
