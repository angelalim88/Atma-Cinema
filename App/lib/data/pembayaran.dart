import 'dart:convert';

class Pembayaran {
  int? id_pembayaran;
  int? id_transaksi;
  String? nama_metode;
  String? jenis;
  String? gambar;

  Pembayaran(
      {this.id_pembayaran,
      this.id_transaksi,
      this.nama_metode,
      this.jenis,
      this.gambar});

  factory Pembayaran.fromRawJson(String str) =>
      Pembayaran.fromJson(json.decode(str));
  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
      id_pembayaran: json["id_pembayaran"],
      id_transaksi: json["id_transaksi"],
      nama_metode: json["nama_metode"],
      jenis: json["jenis"],
      gambar: json["gambar"]);

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_pembayaran": id_pembayaran,
        "id_transaksi": id_transaksi,
        "nama_metode": nama_metode,
        "jenis": jenis,
        "gambar": gambar,
      };
}
