import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/data/bioskop.dart';

class Studio {
  int? id_studio;
  int? id_bioskop;
  String? nama_studio;
  int? kapasitas;
  String? nomor_kursi_tersedia;

  Studio(
      {this.id_studio,
      this.id_bioskop,
      this.nama_studio,
      this.kapasitas,
      this.nomor_kursi_tersedia});

  factory Studio.fromRawJson(String str) => Studio.fromJson(json.decode(str));
  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
        id_studio: json["id_studio"],
        id_bioskop: json["id_bioskop"],
        nama_studio: json["nama_studio"],
        kapasitas: json["kapasitas"],
        nomor_kursi_tersedia: json["nomor_kursi_tersedia"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_studio": id_studio,
        "id_bioskop": id_bioskop,
        "nama_studio": nama_studio,
        "kapasitas": kapasitas
      };
}
