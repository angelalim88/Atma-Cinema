import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/ticket.dart';
import 'package:flutter_application_1/data/user.dart';
import 'package:flutter_application_1/data/penayangan.dart';

class Review {
  int? id_review;
  int? id_tiket;
  dynamic? rating;
  String? komentar;
  Ticket? ticket;
  User? user;
  Penayangan? penayangan;

  Review({
    this.id_review,
    this.id_tiket,
    this.rating,
    this.komentar,
    this.ticket,
    this.user,
    this.penayangan,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id_review: json["id_review"],
        id_tiket: json["id_tiket"],
        rating: json["rating"],
        komentar: json["komentar"],
        ticket: Ticket.fromJsonKecil(json["tiket"]),
        user: User.fromJson(json["tiket"]["user"]),
        penayangan: Penayangan.fromJsonReview(json["tiket"]["penayangan"]),
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_review": id_review,
        "id_tiket": id_tiket,
        "rating": rating,
        "komentar": komentar,
      };
}
