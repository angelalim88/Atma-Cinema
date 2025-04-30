import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constant.dart';

Padding inputForm(Function(String?) validasi,
    {required TextEditingController controller,
    required String hintTxt,
    required String helperTxt,
    required iconData,
    bool password = false}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 10),
    child: SizedBox(
      width: 350,
      child: TextFormField(
        validator: (value) => validasi(value),
        autofocus: true,
        controller: controller,
        obscureText: password,
        decoration: InputDecoration(
          prefixIconColor: lightColor,
          hintStyle: const TextStyle(color : Colors.grey),
          helperStyle: const TextStyle(color : Colors.grey),

          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey), // Warna border ketika tidak fokus
            borderRadius: BorderRadius.circular(10.0), // Radius border
          ),
          
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber, width: 2.0), // Warna border ketika fokus
            borderRadius: BorderRadius.circular(10.0),
          ),
          
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red), // Warna border ketika error
            borderRadius: BorderRadius.circular(10.0),
          ),
          
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0), // Warna border ketika fokus dan error
            borderRadius: BorderRadius.circular(10.0),
          ),

          hintText: hintTxt,
          border: const OutlineInputBorder(),
          helperText: helperTxt,
          prefixIcon: Icon(iconData)
        ),
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}