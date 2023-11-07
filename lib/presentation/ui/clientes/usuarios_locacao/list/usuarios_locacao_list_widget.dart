import 'package:locacao/data/repositories/clientes/usuarios_locacao_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/usuarios_locacao.dart';
import 'package:provider/provider.dart';

class UsuariosLocacaoListWidget extends StatelessWidget {
  final UsuariosLocacao usuariosLocacao;

  const UsuariosLocacaoListWidget(
    this.usuariosLocacao, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/usuario-locacao'),
      endToStart: () async {
        await Provider.of<UsuariosLocacaoRepository>(context, listen: false).delete(usuariosLocacao).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': usuariosLocacao.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/usuario-locacao-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': usuariosLocacao.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/usuario-locacao-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: AppColors.cardGreyText,
            elevation: 5,
            child: ListTile(
              title: Text((usuariosLocacao.locacoesDescricao ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text((usuariosLocacao.usuariosNome ?? '').toString(),
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
