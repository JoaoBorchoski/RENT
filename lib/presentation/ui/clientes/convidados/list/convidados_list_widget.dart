import 'package:locacao/data/repositories/clientes/convidados_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:provider/provider.dart';

class ConvidadosListWidget extends StatelessWidget {
  final Convidados convidados;

  const ConvidadosListWidget(
    this.convidados, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/convidado'),
      endToStart: () async {
        await Provider.of<ConvidadosRepository>(context, listen: false).delete(convidados).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': convidados.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/convidado-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': convidados.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/convidado-form', arguments: data);
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
              title: Text((convidados.locacoesDescricao ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text((convidados.email ?? '').toString(),
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
