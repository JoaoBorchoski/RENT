import 'package:locacao/data/repositories/usuarios/listas_negras_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/usuarios/listas_negras.dart';
import 'package:provider/provider.dart';

class ListasNegrasListWidget extends StatelessWidget {
  final ListasNegras listasNegras;

  const ListasNegrasListWidget(
    this.listasNegras, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/lista-negra'),
      endToStart: () async {
        await Provider.of<ListasNegrasRepository>(context, listen: false).delete(listasNegras).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': listasNegras.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/lista-negra-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': listasNegras.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/lista-negra-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: AppColors.lightGrey,
            elevation: 5,
            child: ListTile(
              title: Text((listasNegras.usuariosNome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text((listasNegras.clienteNome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
