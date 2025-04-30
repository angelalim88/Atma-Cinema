import 'dart:convert';
import 'dart:ui';

class Sesi {
  int? id_sesi;
  String? jam_mulai;
  String? jam_selesai;

  Sesi({this.id_sesi, this.jam_mulai, this.jam_selesai});

  factory Sesi.fromRawJson(String str) => Sesi.fromJson(json.decode(str));
  factory Sesi.fromJson(Map<String, dynamic> json) => Sesi(
      id_sesi: json["id_sesi"],
      jam_mulai: json["jam_mulai"],
      jam_selesai: json["jam_selesai"],
  );
  

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_sesi": id_sesi,
        "jam_mulai": jam_mulai,
        "jam_selesai": jam_selesai,
      };
}
