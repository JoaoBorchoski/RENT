import 'package:locacao/data/repositories/comum/meio_pagamento_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/comum/meio_pagamento.dart';
import 'package:provider/provider.dart';

class MeioPagamentoListWidget extends StatelessWidget {
  final MeioPagamento meioPagamento;

  const MeioPagamentoListWidget(
    this.meioPagamento, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/meios-pagamento'),
      endToStart: () async {
        await Provider.of<MeioPagamentoRepository>(context, listen: false).delete(meioPagamento).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': meioPagamento.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/meios-pagamento-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': meioPagamento.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/meios-pagamento-form', arguments: data);
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
              title: Text((meioPagamento.nome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                  )),
              subtitle: Text((meioPagamento.descricao ?? '').toString(),
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
