import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/data/ticket.dart';
import 'package:flutter_application_1/setting/client.dart';

class TicketClient {
  static final String url = constantURL;
  static final String endpoint = '/api/tikets';

  Future<List<Ticket>> fetchOnlyUsers(id_user) async {
    try {
      final response =
          await http.get(Uri.parse(protocol + url + endpoint + '/${id_user}'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((ticketJson) => Ticket.fromJson(ticketJson)).toList();
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      throw Exception('Error fetching tickets: $e');
    }
  }

  // Fungsi untuk mengambil tiket berdasarkan userId
  Future<int?> fetchUserTicket(int id_user) async {
    try {
      final response = await http.get(Uri.parse('$url$endpoint/$id_user'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['id_tiket']; // Ambil ID tiket dari API
      } else {
        throw Exception("Failed to fetch ticket");
      }
    } catch (e) {
      throw Exception("Error fetching ticket: $e");
    }
  }

Future<Map<String, dynamic>> storeTiket({
  required int idUser,
  required int? idPenayangan,
  required String nomorKursi,
}) async {
  try {
    // Body data yang akan dikirim ke API
    final Map<String, dynamic> bodyData = {
      "id_user": idUser.toString(), // Pastikan data dikirim sebagai string
      "id_penayangan": idPenayangan.toString(),
      "nomor_kursi": nomorKursi, // Jika API mengharapkan string, gabungkan list
    };

    // Melakukan request POST
    final response = await http.post(
      Uri.http(url, endpoint),
      headers: {
        "Content-Type": "application/json", // Header untuk format JSON
        "Accept": "application/json", // Menerima response dalam format JSON
      },
      body: jsonEncode(bodyData), // Encode body ke JSON
    );

    // Cek status response
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Mengembalikan hasil dalam bentuk map
    } else {
      // Menangani error jika response bukan 200
      throw Exception("Failed to create tiket: ${response.statusCode}");
    }
  } catch (e) {
    // Menangani error jaringan atau lainnya
    throw Exception("Error: $e");
  }
}

}
