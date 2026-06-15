import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/data/review.dart';
import 'package:flutter_application_1/setting/client.dart';
import 'package:flutter_application_1/setting/client.dart';
import 'package:flutter_application_1/client/TicketClient.dart';

class ReviewClient {
  static final String url = constantURL;
  static final String endpoint = '/api/reviews';

  Future<List<Review>> fetchByFilmId(int filmId) async {
    try {
      final response = await http.get(
        Uri.parse('$protocol$url$endpoint/$filmId'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((reviewJson) => Review.fromJson(reviewJson)).toList();
      } else {
        throw Exception('Failed to load reviews for film ID: $filmId');
      }
    } catch (error) {
      throw Exception('Failed to load reviews: $error');
    }
  }

  Future<bool> postReview(int tiketId, double rating, String komentar) async {
    try {
      print("Tiket Id: ${tiketId}");
      final response = await http.post(
        Uri.parse('$protocol$url$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id_tiket": tiketId,
          "rating": rating,
          "komentar": komentar,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to post review');
      }
    } catch (e) {
      throw Exception('Failed to post review: $e');
    }
  }
}
