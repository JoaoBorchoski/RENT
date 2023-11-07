import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:provider/provider.dart';

class AtivoListWidget extends StatelessWidget {
  final Ativo ativo;

  const AtivoListWidget(
    this.ativo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/ativos'),
      endToStart: () async {
        await Provider.of<AtivoRepository>(context, listen: false).delete(ativo).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': ativo.id, 'view': false, 'edit': true};
        Navigator.of(context).pushReplacementNamed('/ativos-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': ativo.id, 'view': true, 'edit': false};
        Navigator.of(context).pushReplacementNamed('/ativos-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: ativo.desabilitado! ? AppColors.delete : AppColors.success,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                color: AppColors.lightGrey,
                child: ListTile(
                  title: Text((ativo.nome ?? '').toString(),
                      style: TextStyle(
                        color: AppColors.cardGreyText,
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: Text((ativo.identificador == "" ? 'Sem identificador pai' : ativo.identificador).toString(),
                      style: TextStyle(
                        color: AppColors.cardGreyText,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
