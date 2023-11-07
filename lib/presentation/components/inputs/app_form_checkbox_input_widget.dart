import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class AppCheckbox extends StatefulWidget {
  AppCheckbox({
    super.key,
    this.isVisible,
    this.isDisabled,
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  bool controller;
  final bool? isDisabled;
  final bool? isVisible;
  final String label;
  void Function(bool value) onChanged;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  Color getColor(Set<MaterialState> states) {
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTileTheme(
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.all(0),
            child: CheckboxListTile(
              checkColor: AppColors.cardTextColor,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              enabled: widget.isDisabled != null ? !widget.isDisabled! : true,
              title:
                  Text(widget.label, style: TextStyle(color: widget.controller ? AppColors.primary : Colors.black87)),
              value: widget.controller,
              selected: widget.controller,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) => widget.onChanged(value ?? false),
            ),
          )
        ],
      ),
    );
  }
}
