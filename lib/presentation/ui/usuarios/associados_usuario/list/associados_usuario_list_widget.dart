import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/associados.dart';

class AssociadosUsuarioListWidget extends StatelessWidget {
  final Associados associados;

  const AssociadosUsuarioListWidget(
    this.associados, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      endToStart: () {},
      startToEnd: () {},
      onDoubleTap: () {
        Navigator.of(context).pushNamed(
          '/dependente',
          arguments: {'id': associados.id},
        );
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: AppColors.cardGrey,
            elevation: 5,
            child: ListTile(
              title: Text((associados.clienteNome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text(('Status: ${associados.statusAssociadoNome ?? ""}').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                  )),
              trailing: IconButton(
                icon: Icon(Icons.people),
                iconSize: 35,
                color: AppColors.cardGreyText,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/dependente',
                    arguments: {'id': associados.id},
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
