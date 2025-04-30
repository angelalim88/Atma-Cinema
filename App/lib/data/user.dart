import 'dart:convert';

import 'package:flutter/rendering.dart';

class User {
  int? id_user;
  String? username;
  String? password;
  String? email;
  String? nomor_telepon;
  String? tanggal_lahir;
  String? profie_picture;

  User(
      {this.id_user,
      this.username,
      this.password,
      this.email,
      this.nomor_telepon,
      this.profie_picture,
      this.tanggal_lahir});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
      id_user: json["id"],
      username: json["username"],
      password: json["password"],
      email: json["email"],
      nomor_telepon: json["nomor_telepon"],
      tanggal_lahir: json["tanggal_lahir"],
      profie_picture: json["profile_picture"]);

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id_user,
        "username": username,
        "password": password,
        "email": email,
        "nomor_telepon": nomor_telepon,
        "tanggal_lahir": tanggal_lahir,
        "profile_picture": profie_picture,
      };
}
