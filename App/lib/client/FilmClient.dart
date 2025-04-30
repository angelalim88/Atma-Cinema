import 'package:flutter_application_1/data/film.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/setting/client.dart';

class FilmClient {
  static final String url = constantURL;
  static final String endpoint = '/public/api/films';

  Future<List<Film>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(protocol + url + endpoint));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body)['films'];
        return list.map((e) => Film.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load films');
      }
    } catch (error) {
      throw Exception('Failed to load films: $error');
    }
  }
}
