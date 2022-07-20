import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiProvider extends ChangeNotifier {
  String? _baseUrl;
  String get baseUrl => _baseUrl ?? "";
  set baseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    notifyListeners();
  }

  Dio dio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 9000,
        receiveDataWhenStatusError: true,
        validateStatus: (status) {
          return (status ?? 0) < 500;
        },
      ),
    );
  }
}
