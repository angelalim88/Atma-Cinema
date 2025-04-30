import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/data/sesi.dart';
import 'package:flutter_application_1/setting/client.dart';

class Sesiclient {
  static final String url = constantURL;
  static final String endpoint = '/public/api/sesis';

  Future<List<Sesi>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(protocol + url + endpoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Sesi> sesis =
            data.map((jsonSesi) => Sesi.fromJson(jsonSesi)).toList();
        return sesis;
      } else {
        throw Exception('Failed to load sesis');
      }
    } catch (error) {
      throw Exception('Failed to load sesis: $error');
    }
  }

  Future<List<Sesi>> fetchById(id_sesi) async {
    try {
      final response =
          await http.get(Uri.parse(protocol + url + endpoint + '/${id_sesi}'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
        ;
      } else {
        throw Exception('Failed to load sesi');
      }
    } catch (error) {
      throw Exception('Failed to load sesi: $error');
    }
  }
}
