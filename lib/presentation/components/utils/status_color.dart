import 'package:flutter/material.dart';

Color? statusColorHex(String? status) {
  return Color(int.parse('0xFF${status!.split('#')[1]}'));
}

List<Widget> statusColor(List<dynamic> data) {
  List<Widget> items = [];
  items.add(SizedBox(width: 10));
  for (var cor in data) {
    items.add(
      Row(
        children: [
          SizedBox(width: 5),
          Card(
            color: Color(int.parse('0xFF${cor['color'].split('#')[1]}')),
            child: SizedBox(height: 15, width: 15),
          ),
          Text(cor['title']),
          SizedBox(width: 5),
        ],
      ),
    );
  }
  items.add(SizedBox(width: 10));
  return items;
}
