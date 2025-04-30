import 'dart:convert';

class Bioskop {
  int? idBioskop;
  String? namaBioskop;
  String? alamat;

  Bioskop({
    this.idBioskop,
    this.namaBioskop,
    this.alamat,
  });

  factory Bioskop.fromRawJson(String str) => Bioskop.fromJson(json.decode(str));
  factory Bioskop.fromJson(Map<String, dynamic> json) {
    return Bioskop(
      idBioskop: json['id_bioskop'],
      namaBioskop: json['nama_bioskop'],
      alamat: json['alamat'],
    );
  }

  factory Bioskop.fromPenayanganJson(Map<String, dynamic> json) {
    return Bioskop(
      idBioskop: json['id_bioskop'],
      namaBioskop: json['nama_bioskop'],
    );
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() {
    return {
      'id_bioskop': idBioskop,
      'nama_bioskop': namaBioskop,
      'alamat': alamat,
    };
  }
}
