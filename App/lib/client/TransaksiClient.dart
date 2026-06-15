import 'package:flutter_application_1/data/transaksi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/setting/client.dart';

class Transaksiclient {
  static final String url = constantURL;
  static final String endPoint = '/api/transaksis';

  Future<List<Transaksi>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(protocol + url + endPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Transaksi> transaksis = data
            .map((jsonTransaksi) => Transaksi.fromJson(jsonTransaksi))
            .toList();
        return transaksis;
      } else {
        throw Exception('Failed to load transaksis');
      }
    } catch (error) {
      throw Exception('Failed to load transaksis: ${error}');
    }
  }

  Future<Map<String, dynamic>> fetchById(id) async {
    try {
      final response = await http.get(Uri.parse(protocol + url + endPoint + '/${id}'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load transaksis');
      }
    } catch (error) {
      throw Exception('Failed to load transaksis: ${error}');
    }
  }

  Future<Map<String, dynamic>> storeTransaksi({
    required int idTiket,
    required String? metodePembayaran,
    required double nominalPembayaran,
  }) async {
    try {
      // Data yang akan dikirim ke API
      final Map<String, dynamic> bodyData = {
        "id_tiket": idTiket.toString(), // Konversi ID menjadi string jika perlu
        "metode_pembayaran": metodePembayaran,
        "nominal_pembayaran": nominalPembayaran, // Nominal dalam bentuk angka (double)
      };

      // Lakukan POST request ke API
      final response = await http.post(
        Uri.parse(protocol + url + endPoint),
        headers: {
          "Content-Type": "application/json", // Format body sebagai JSON
          "Accept": "application/json", // Response yang diharapkan dalam format JSON
        },
        body: jsonEncode(bodyData), // Encode body ke JSON
      );

      // Cek status response
      if (response.statusCode == 200) {
        // Berhasil membuat transaksi, kembalikan data
        return jsonDecode(response.body);
      } else {
        // Jika gagal, lempar error dengan status code
        throw Exception("Failed to create transaksi: ${response.statusCode}");
      }
    } catch (e) {
      // Menangani error koneksi atau lainnya
      throw Exception("Error: $e");
    }
  }
  
}
