import 'dart:convert';
import 'package:flutter/rendering.dart';

class Fnb {
  int? id;
  String? nama;
  String? jenis;
  double? harga;
  String? deskripsi;
  String? gambar;

  Fnb({
    this.id,
    this.nama,
    this.jenis,
    this.harga,
    this.deskripsi,
    this.gambar,
  });

  factory Fnb.fromRawJson(String str) => Fnb.fromJson(json.decode(str));
  factory Fnb.fromJson(Map<String, dynamic> json) => Fnb(
    id: json['id'],
    nama: json['nama'],
    jenis: json['jenis'],
    harga: json['harga'] != null ? double.tryParse(json['harga'].toString()) ?? 0.0 : 0.0,
    deskripsi: json['deskripsi'],
    gambar: json['gambar'],
  );


  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
      "id": id,
      "nama": nama,
      "jenis": jenis,
      "harga": harga,
      "deskripsi": deskripsi,
      "gambar": gambar,
  };
}

