import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constant.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
  });

  final IconData icon;
  final String text;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed as void Function()?, 
      child: Card(
        color: lightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: darkColor,
              ),
              kSizeBox,
              Text(
                text,
                style: const TextStyle(
                  color: darkColor,
                  fontFamily: 'Source Sans Pro',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}