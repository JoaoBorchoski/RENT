import 'package:locacao/data/repositories/clientes/meios_pagamento_aceito_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/meios_pagamento_aceito.dart';
import 'package:provider/provider.dart';

class MeiosPagamentoAceitoListWidget extends StatelessWidget {
  final MeiosPagamentoAceito meiosPagamentoAceito;

  const MeiosPagamentoAceitoListWidget(
    this.meiosPagamentoAceito, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/meio-pagamento-aceito'),
      endToStart: () async {
        await Provider.of<MeiosPagamentoAceitoRepository>(context, listen: false)
            .delete(meiosPagamentoAceito)
            .then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': meiosPagamentoAceito.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/meio-pagamento-aceito-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': meiosPagamentoAceito.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/meio-pagamento-aceito-form', arguments: data);
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
              title: Text((meiosPagamentoAceito.meioPagamentoNome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle:
                  Text('Taxa: R\$ ${(meiosPagamentoAceito.meioPagamentoTaxa!.toStringAsFixed(2).replaceAll('.', ','))}',
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
