import 'package:locacao/data/repositories/clientes/itens_locacao_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/itens_locacao.dart';
import 'package:provider/provider.dart';

class ItensLocacaoListWidget extends StatelessWidget {
  final ItensLocacao itensLocacao;

  const ItensLocacaoListWidget(
    this.itensLocacao, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/item-locacao'),
      endToStart: () async {
        await Provider.of<ItensLocacaoRepository>(context, listen: false).delete(itensLocacao).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': itensLocacao.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/item-locacao-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': itensLocacao.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/item-locacao-form', arguments: data);
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
              title: Text((itensLocacao.ativoNome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text((itensLocacao.locacoesDescricao ?? '').toString(),
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
