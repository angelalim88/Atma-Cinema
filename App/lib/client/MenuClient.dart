import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/data/fnb.dart';
import 'package:flutter_application_1/setting/client.dart';

class Menuclient {
  static final String baseUrl = constantURL;
  static final String endpoint = '/public/api/menus';

  Future<List<Fnb>> fetchMenus() async {
    final response = await http.get(Uri.parse(protocol + baseUrl + endpoint));

    if (response.statusCode == 200) {
      // Parsing langsung sebagai list karena API memberikan array JSON
      final List<dynamic> list = json.decode(response.body);
      return list.map((data) => Fnb.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }
}

