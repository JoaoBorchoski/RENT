import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class LegendaSocioWidget extends StatelessWidget {
  const LegendaSocioWidget({super.key, this.widthSize = 1});

  final double widthSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * widthSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Row(
                children: [
                  Card(
                    color: AppColors.success,
                    child: SizedBox(height: 15, width: 15),
                  ),
                  Text('Associado'),
                ],
              ),
              Row(
                children: [
                  Card(
                    color: AppColors.alert,
                    child: SizedBox(height: 15, width: 15),
                  ),
                  Text('Não associado'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
