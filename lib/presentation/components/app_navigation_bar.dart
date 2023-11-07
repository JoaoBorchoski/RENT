import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings),
          label: 'Configuração',
        ),
      ],
      unselectedItemColor: AppColors.primary,
      selectedItemColor: AppColors.primary,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int value) {}
}
