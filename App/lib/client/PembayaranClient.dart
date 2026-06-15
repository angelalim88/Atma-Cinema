import 'dart:convert';
import 'package:flutter_application_1/data/pembayaran.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/setting/client.dart';

class Pembayaranclient {
  static final String url = constantURL;
  static final String endpoint = '/api/pembayarans';

  Future<List<Pembayaran>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(protocol + url + endpoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Pembayaran> pembayarans = data
            .map((jsonPembayaran) => Pembayaran.fromJson(jsonPembayaran))
            .toList();
        return pembayarans;
      } else {
        throw Exception('Failed to load pembayaran');
      }
    } catch (error) {
      throw Exception('Failed to load pembayaran: ${error}');
    }
  }

  Future<Map<String, dynamic>> fetchById(id_pembayaran) async {
    try {
      final response = await http.get(Uri.parse(protocol + url + endpoint + '/${id_pembayaran}'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load pembayaran');
      }
    } catch (error) {
      throw Exception('Failed to load pembayaran: ${error}');
    }
  }
}
