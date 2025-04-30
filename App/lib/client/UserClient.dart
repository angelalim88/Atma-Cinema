import 'dart:developer';
import 'dart:io';

import 'package:flutter_application_1/data/user.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/setting/client.dart';

class UserClient {
  static final String url = constantURL;
  static final String endpoint = '/public/api/users';

  // static Future<List<User>> fetchAll() async {
  //   try {
  //     var response = await get(Uri.http(url, '$endpoint'));

  //     if (response.statusCode != 200) throw Exception(response.reasonPhrase);

  //     Iterable list = json.decode(response.body)['data'];

  //     return list.map((e) => User.fromJson(e)).toList();
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Mengirim data login
      var response = await http.post(
        Uri.http(url, '/public/api/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Invalid credentials');
      }

      var data = json.decode(response.body);

      String token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data['user']['username']);
      await prefs.setString('auth_token', token);

      return {
        'user': data["user"],
        'token': data['token'],
      };
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required String birthDate, // Added birthDate parameter
    required File profilePicture,
  }) async {
    try {
      var uri = Uri.http(url, '/public/api/register');

      var request = http.MultipartRequest('POST', uri)
        ..fields['username'] = username
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['nomor_telepon'] = phoneNumber
        ..fields['tanggal_lahir'] =
            birthDate; // Add birthDate to request fields

      // Adding profile picture if it exists
      var pic = await http.MultipartFile.fromPath(
          'profile_picture', profilePicture.path);
      request.files.add(pic);

      var response = await request.send();

      // Checking the status code of the response
      if (response.statusCode != 200) {
        var responseData = await response.stream.bytesToString();
        throw Exception(
            'Failed to register. Status code: ${response.statusCode}, body: $responseData');
      }

      // Decode response
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      // Store token and user data in shared preferences
      String token = data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data['user']['username']);
      await prefs.setString('auth_token', token);

      return {
        'user': data["user"],
        'token': token,
      };
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required int id_user,
    required String username,
    required String email,
    required String nomor_telepon,
    required File profilePicture, // Profile picture is optional
  }) async {
    try {
      var uri = Uri.http(url, '/public/api/users/' + id_user.toString());

      var request = http.MultipartRequest('POST', uri)
        ..fields['id'] = id_user.toString()
        ..fields['username'] = username
        ..fields['email'] = email
        ..fields['nomor_telepon'] = nomor_telepon;

      // Adding profile picture if it exists
      var pic = await http.MultipartFile.fromPath(
        'profile_picture',
        profilePicture.path,
      );
      request.files.add(pic);

      var response = await request.send();

      // Checking the status code of the response
      if (response.statusCode != 200) {
        var responseData = await response.stream.bytesToString();
        throw Exception(
            'Failed to update user. Status code: ${response.statusCode}, body: $responseData');
      }

      // Decode response
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      return {
        'user': data['user'],
      };
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> changePassword(
      {required int id_user,
      required String old_password,
      required String new_password,
      required String confirm_password}) async {
    if (new_password != confirm_password) {
      throw Exception('Konfirmasi password tidak cocok!');
    }

    // Send the request to update the password
    var response = await http.post(
      Uri.http(url, '/public/api/users/' + id_user.toString()),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'id_user': id_user,
        'password': new_password,
        'old_password': old_password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah password');
    }

    var data = json.decode(response.body);

    return {
      'message': 'Password berhasil diubah!',
      'user': data['user'],
    };
  }
}
