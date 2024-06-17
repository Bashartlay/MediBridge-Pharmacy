import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://192.168.104.40:8000/api';
  // 192.168.1.2 is my IP, change with your IP address

  auth(data, apiURL) async {
    var fullUrl = _url + apiURL;

    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeadersWithToken(),
    );
  }

  postData(data, apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeadersWithToken(),
    );
  }

  _setHeaders() => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  _setHeadersWithToken() => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${MyApp.token}',
      };
}
