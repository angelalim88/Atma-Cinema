import 'package:flutter_application_1/data/penayangan.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/setting/client.dart';

class PenayanganClient {
  static final String url = constantURL;
  static final String endpoint = '/public/api/searchPenayangan';
  static final String endpoint2 = '/public/api/penayanganbyid';
  static final String endpoint3 = '/public/api/penayangans';

  Future<Map<String, dynamic>> fetchPenayangan({
    required int id_film,
    required int id_sesi,
    required String tanggal_tayang,
    required int id_studio,
  }) async {
    try {
      final response = await http.post(
        Uri.http(url, '/public/api/searchPenayangan'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id_film': id_film,
          'id_sesi': id_sesi,
          'tanggal_tayang': tanggal_tayang,
          'id_studio': id_studio
        }),
      );

      print(
          "id film : $id_film , id_sesi : $id_sesi , tanggal tayang : $tanggal_tayang , id studio : $id_studio , response ${response.body} , status code : ${response.statusCode}");
      print("json decode : ${json.decode(response.body)}");

      var data = json.decode(response.body);
      print("data : $data");
      return data;
    } catch (error) {
      throw Exception('Failed to load penayangan: ${error}');
    }
  }

  Future<List<Penayangan>> fetchByFilm(id_film) async {
    try {
      final response =
          await http.get(Uri.parse(protocol + url + endpoint2 + '/${id_film}'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map((penayanganJson) => Penayangan.fromJsonFilm(penayanganJson))
            .toList();
      } else {
        throw Exception('Failed to load Penayangan');
      }
    } catch (e) {
      throw Exception('Error fetching Penayangan: $e');
    }
  }

  Future<Map<String, dynamic>> updatePenayangan({
    required int idPenayangan, // ID Penayangan yang akan diupdate
    int? idFilm,
    int? idSesi,
    int? idStudio,
    String? nomorKursiTerpakai,
    double? hargaTiket,
    String? status,
    String? tanggalTayang, // Format: yyyy-MM-dd
  }) async {
    try {
      // Data yang akan dikirim ke API
      final Map<String, dynamic> bodyData = {
        if (idFilm != null) "id_film": idFilm,
        if (idSesi != null) "id_sesi": idSesi,
        if (idStudio != null) "id_studio": idStudio,
        if (nomorKursiTerpakai != null)
          "nomor_kursi_terpakai": nomorKursiTerpakai,
        if (hargaTiket != null) "harga_tiket": hargaTiket,
        if (status != null) "status": status,
        if (tanggalTayang != null) "tanggal_tayang": tanggalTayang,
      };

      // Melakukan PUT request
      final response = await http.put(
        Uri.parse(protocol + url + endpoint3 + '/$idPenayangan'),
        headers: {
          "Content-Type": "application/json", // Header untuk JSON
          "Accept": "application/json", // Menerima response dalam JSON
        },
        body: jsonEncode(bodyData), // Encode body ke JSON
      );

      // Cek status response
      if (response.statusCode == 200) {
        return jsonDecode(
            response.body); // Mengembalikan hasil dalam bentuk Map
      } else {
        // Jika gagal, lemparkan error dengan status code
        throw Exception("Failed to update penayangan: ${response.statusCode}");
      }
    } catch (e) {
      // Menangkap error jaringan atau lainnya
      throw Exception("Error: $e");
    }
  }
}
