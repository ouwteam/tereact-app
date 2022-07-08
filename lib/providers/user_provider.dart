import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/entities/user.dart';

class UserProvider extends ChangeNotifier {
  final loginUrl = "/user/login";
  final registerUrl = "/user/register";
  final dio = Dio(BaseOptions(
    connectTimeout: 9000,
    receiveDataWhenStatusError: true,
  ));

  late String _errorMessage;
  String get getErrorMessage => _errorMessage;
  set setErrorMessage(String text) {
    _errorMessage = text;
    notifyListeners();
  }

  User? _user;
  User? get getUserData => _user;
  set setUserData(User value) {
    _user = value;
    notifyListeners();
  }

  void clearUserData() {
    _user = null;
    notifyListeners();
  }

  Future<User?> handleLogin({
    required String username,
    required String password,
  }) async {
    try {
      String url = baseUrl + loginUrl;
      log(url);
      Response response = await dio.post(
        url,
        data: {
          "username": username,
          "password": password,
        },
      );

      log(response.data.toString());
      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to get list contacts";
      }

      var data = response.data;
      if (!data['ok']) {
        throw data['message'] ?? "Undefined error contacts";
      }

      User user = User.fromJson(data['data']['user']);
      setUserData = user;

      var prefs = await SharedPreferences.getInstance();
      prefs.setString("user_data", jsonEncode(user.toJson()));
      return user;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
      setErrorMessage = e.toString();
    }

    return null;
  }

  Future<User?> handleRegister(User user) async {
    try {
      String url = baseUrl + loginUrl;
      Response response = await dio.post(
        url,
        data: user.toJson(),
      );

      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Failed to get list contacts";
      }

      var data = response.data;
      if (!data['ok']) {
        throw data['message'] ?? "Undefined error contacts";
      }

      User userData = User.fromJson(data['data']['user']);
      setUserData = userData;

      var prefs = await SharedPreferences.getInstance();
      prefs.setString("user_data", jsonEncode(userData.toJson()));
      return userData;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
      setErrorMessage = e.toString();
    }

    return null;
  }

  Future<bool> handleLogout() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.remove("user_data");
      clearUserData();
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack: ${stack.toString()}");
      setErrorMessage = e.toString();

      return false;
    }

    return true;
  }
}
