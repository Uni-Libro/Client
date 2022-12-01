import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/author_model.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import 'api.dart';
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
    loadHomeScreenDataFromServer(),
  ]);

  LocalAPI().currentUserProfile = results[0] as UserModel;
}

Future<void> loadHomeScreenDataFromServer() async {
  final catagories = await API().getCategories();

  final results = await Future.wait([
    API().getBooks(),
    API().getAuthors(),
    API().getBooks(),
    API().getBooks(),
    ...catagories.map((category) => API().getBooks()),
  ]);
  for (var i = 4; i < results.length; i++) {
    catagories[i - 4].books = ((results[i] as List<BookModel>)..shuffle())
        .sublist(0, Random().nextInt(10) + 1);
  }

  catagories.insertAll(0, [
    CategoryModel.create(
        name: Strs.recommended,
        books: ((results[2] as List<BookModel>)..shuffle())
            .sublist(0, Random().nextInt(10) + 1)),
    CategoryModel.create(
        name: Strs.specials,
        books: ((results[3] as List<BookModel>)..shuffle())
            .sublist(0, Random().nextInt(10) + 1)),
  ]);

  LocalAPI().categories = catagories;
  LocalAPI().currentUsersBooks = ((results[0] as List<BookModel>)..shuffle())
      .sublist(0, Random().nextInt(10) + 1);
  LocalAPI().authors = results[1] as List<AuthorModel>;
}
