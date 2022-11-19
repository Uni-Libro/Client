import 'dart:convert';

import 'package:http/http.dart' as http;

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
      return (jsonDecode(response.body) as Map<String, dynamic>)['data']
          ['token'];
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

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
