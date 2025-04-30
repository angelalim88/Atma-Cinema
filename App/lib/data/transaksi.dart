import 'dart:convert';

class Transaksi {
  int? id_transaksi;
  int? id_tiket;
  String? metode_pembayaran;
  double? nominal_pembayaran;

  Transaksi(
      {this.id_transaksi,
      this.id_tiket,
      this.metode_pembayaran,
      this.nominal_pembayaran});

  factory Transaksi.fromRawJson(String str) =>
      Transaksi.fromJson(json.decode(str));
  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        id_transaksi: json["id_transaksi"],
        id_tiket: json["id_tiket"],
        metode_pembayaran: json["metode_pembayaran"],
        nominal_pembayaran: json["nominal_pembayaran"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_transaksi": id_transaksi,
        "id_tiket": id_tiket,
        "metode_pembayaran": metode_pembayaran,
        "nominal_pembayaran": nominal_pembayaran,
      };
}
