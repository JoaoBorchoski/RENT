import 'package:locacao/data/repositories/clientes/cliente_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/cliente.dart';
import 'package:provider/provider.dart';

class ClienteListWidget extends StatelessWidget {
  final Cliente cliente;

  const ClienteListWidget(
    this.cliente, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/clientes'),
      endToStart: () async {
        await Provider.of<ClienteRepository>(context, listen: false).delete(cliente).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': cliente.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/clientes-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': cliente.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/clientes-form', arguments: data);
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
              title: Text((cliente.cnpj ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text((cliente.nome ?? '').toString(),
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
