import 'package:flutter/cupertino.dart';

class MenuOptions {
  String? label;
  Icon? icon;
  Function()? action;

  MenuOptions({this.action, this.icon, this.label});
}
