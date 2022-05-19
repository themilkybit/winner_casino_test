import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MobileApi {
  MobileApi._privateConstructor();
  static final MobileApi _instance = MobileApi._privateConstructor();
  static MobileApi get instance => _instance;

  Future<http.Response> get({
    @required Map<String, String>? queryParameters,
  }) async {
    return await http.get(
      Uri.https(
        'test-micros1.play-online.com',
        '/missions/tournaments/list',
        queryParameters,
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: '*',
      },
    );
  }
}