import 'package:locacao/data/repositories/clientes/ativo_imagens_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:provider/provider.dart';

class AtivoImagensListWidget extends StatelessWidget {
  final AtivoImagens ativoImagens;

  const AtivoImagensListWidget(
    this.ativoImagens, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/ativo-imagem'),
      endToStart: () async {
        await Provider.of<AtivoImagensRepository>(context, listen: false).delete(ativoImagens).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': ativoImagens.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/ativo-imagem-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': ativoImagens.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/ativo-imagem-form', arguments: data);
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
              title: Text((ativoImagens.ativoNome ?? '').toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.cardGreyText,
                  )),
              subtitle: Text((ativoImagens.imagemNome ?? '').toString(),
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
