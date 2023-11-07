import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class IconGrid extends StatefulWidget {
  final Function(String) onIconSelected;
  final String selectedIcon;
  final bool isViewPage;

  const IconGrid({
    Key? key,
    required this.isViewPage,
    required this.onIconSelected,
    required this.selectedIcon,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IconGridState createState() => _IconGridState();
}

class _IconGridState extends State<IconGrid> {
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      padding: EdgeInsets.all(12.0),
      children: AppIcons.icones.keys.map((String iconName) {
        return GestureDetector(
          onTap: () {
            if (!widget.isViewPage) {
              setState(() {
                _selectedIcon = iconName;
              });
              widget.onIconSelected(iconName);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedIcon == iconName ? AppColors.secondary : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              AppIcons.icones[iconName],
              size: 35,
            ),
          ),
        );
      }).toList(),
    );
  }
}
