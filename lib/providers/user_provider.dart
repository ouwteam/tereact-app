import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tereact/common/constant.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/api_provider.dart';

class UserProvider extends ChangeNotifier {
  final loginUrl = "/login";
  final registerUrl = "/user";
  final userDetailUrl = "/user/get-data";

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

  Future<User?> handleLogin(
    BuildContext context, {
    required String username,
    required String password,
  }) async {
    try {
      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
      Response response = await api.dio().post(
        loginUrl,
        data: {
          "email": username,
          "password": password,
        },
      );

      log("response.statusCode: ${response.statusCode}");
      log(response.data.toString());
      if (response.statusCode == 400) {
        throw response.data['message'] ?? "Login failed";
      }

      if (response.statusCode != 200) {
        throw "Login failed (${response.statusCode})";
      }

      var data = response.data;
      if (!data['status']) {
        throw data['message'] ?? "Undefined error contacts";
      }

      String token = data['data']['token'] as String;
      User user = User.fromJson(data['data']['user']);
      user.token = token;
      setUserData = user;

      var prefs = await SharedPreferences.getInstance();
      prefs.setString(spKeyUserData, jsonEncode(user.toJson()));
      return user;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
      setErrorMessage = e.toString();

      throw e.toString();
    }
  }

  Future<User?> handleRegister(
    BuildContext context, {
    required User user,
  }) async {
    try {
      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
      Response response = await api.dio().post(
            registerUrl,
            data: user.toJson(),
          );

      log("response.statusCode: ${response.statusCode}");
      log(response.data.toString());
      if (response.statusCode == 400) {
        throw response.data['message'] ?? "Login failed";
      }

      if (response.statusCode != 200) {
        throw "Login failed (${response.statusCode})";
      }

      var data = response.data;
      if (!data['status']) {
        throw data['message'] ?? "Undefined error contacts";
      }

      String token = data['data']['token'] as String;
      User userData = User.fromJson(data['data']['user']);
      userData.token = token;
      setUserData = userData;

      var prefs = await SharedPreferences.getInstance();
      prefs.setString(spKeyUserData, jsonEncode(userData.toJson()));
      return userData;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack:");
      log(stack.toString());
      setErrorMessage = e.toString();
      throw getErrorMessage;
    }
  }

  Future<bool> handleLogout() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.remove(spKeyUserData);
      clearUserData();
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack: ${stack.toString()}");
      setErrorMessage = e.toString();

      return false;
    }

    return true;
  }

  Future<User> handleGetUserDetail(
    BuildContext context, {
    required User user,
  }) async {
    try {
      ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
      final response = await api.dio().get(
            userDetailUrl,
            options: Options(
              headers: {"Authorization": "Bearer ${user.token}"},
            ),
          );

      log(response.data.toString());
      if (response.statusCode != 200) {
        throw response.statusMessage ?? "Unknow error";
      }

      final userData = User.fromJson(response.data['data']['user']);
      return userData;
    } catch (e, stack) {
      log(e.toString());
      log("Here is the stack: $stack");
      throw e.toString();
    }
  }
}
