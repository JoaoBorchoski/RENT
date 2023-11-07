import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AppLegendaDesabilitado extends StatelessWidget {
  const AppLegendaDesabilitado({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Row(
                children: [
                  Card(
                    color: AppColors.success,
                    child: SizedBox(height: 15, width: 15),
                  ),
                  Text('Habilitado'),
                ],
              ),
              Row(
                children: [
                  Card(
                    color: AppColors.delete,
                    child: SizedBox(height: 15, width: 15),
                  ),
                  Text('Desabilitado'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
