import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/data/studio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/setting/client.dart';

class Studioclient {
  static final String url = constantURL;
  static final String endpoint = '/public/api/studio';

  Future<Map<String, dynamic>> fetchById(int id) async {
    try {
      final response =
          await http.get(Uri.parse(protocol + url + endpoint + '/${id}'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load studio data');
      }
    } catch (error) {
      throw Exception('Failed to load studio data');
    }
  }

  Future<Map<String, dynamic>> searchStudio(int id_film, int id_bioskop) async {
    try {
      print('id_bioskop : $id_bioskop');
      final response = await http.post(
        Uri.http(url, '/api/searchStudio'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'id_film': id_film, 'id_bioskop': id_bioskop}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load studio data');
      }
    } catch (error) {
      throw Exception('Failed to load studio data: ${error}');
    }
  }
}
