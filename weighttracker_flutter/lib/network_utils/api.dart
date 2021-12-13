import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class Network {
  final String _url = apiUrl;
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.getString('token') != null)
      token = jsonDecode(localStorage.getString('token'));
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
