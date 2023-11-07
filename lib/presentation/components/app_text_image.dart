import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppTextImage extends StatelessWidget {
  AppTextImage({
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Icon(
            icon,
            color: Colors.black38,
            size: 110,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
