import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/data/bioskop.dart';
import 'package:flutter_application_1/setting/client.dart';

class BioskopClient {
  static final String baseUrl = constantURL;
  static final String endpoint = '/api/bioskop';

  Future<List<Bioskop>> fetchBioskops() async {
    final response = await http.get(Uri.parse(protocol + baseUrl + endpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Bioskop.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch bioskops');
    }
  }

  Future<void> updateBioskopLocation(int id, String location) async {
    final response = await http.put(
      Uri.parse(protocol + baseUrl + endpoint + '/${id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'alamat': location}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update bioskop location');
    }
  }
}
