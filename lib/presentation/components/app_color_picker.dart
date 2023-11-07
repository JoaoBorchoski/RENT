// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';

class AppColorPicker extends StatelessWidget {
  const AppColorPicker({super.key, this.color = '#F44336', this.controller});

  final String color;
  final controller;

  @override
  Widget build(BuildContext context) {
    return BlockPicker(
      pickerColor: color != '' ? statusColorHex(color)! : Colors.red,
      itemBuilder: pickerItemBuilder,
      layoutBuilder: pickerLayoutBuilder,
      onColorChanged: (color) => {
        // ignore: avoid_print
        print('#${colorToHex(color).substring(2)}'),
        controller.cor.text = '#${colorToHex(color).substring(2)}',
      },
    );
  }

  Widget pickerLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    const List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.pinkAccent,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color,
        boxShadow: [BoxShadow(color: color.withOpacity(0.8), offset: const Offset(1, 2), blurRadius: 1)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(250),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: 24,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
