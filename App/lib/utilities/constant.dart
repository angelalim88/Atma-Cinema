import 'package:flutter/material.dart';

const SizedBox kSizeBox = SizedBox(
  height: 20,
  width: 5,
  child: Divider(
    color: Color.fromARGB(0, 22, 22, 22),
    thickness: 1.5,
  ),
);

const textStyle1 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 23,
  color: lightColor,
);

const textStyle2 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  color: lightColor,
);

const textStyle3 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 40,
  color: lightColor,
  fontWeight: FontWeight.bold,
);

const textStyle4 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  color: darkColor,
);

const textStyle5 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  color: lightColor,
);

const textStyle6 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  color: darkColor,
  fontWeight: FontWeight.bold,
);

const textStyle7 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  color: whiteColor,
  fontWeight: FontWeight.bold,
);

const darkColor = Color.fromARGB(255, 22, 22, 22);
const lightColor = Colors.amber;
const whiteColor = Colors.white;