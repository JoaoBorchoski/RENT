import 'package:locacao/data/repositories/clientes/status_ativo_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/status_ativo.dart';
import 'package:provider/provider.dart';

class StatusAtivoListWidget extends StatelessWidget {
  final StatusAtivo statusAtivo;

  const StatusAtivoListWidget(
    this.statusAtivo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/status-ativos'),
      endToStart: () async {
        await Provider.of<StatusAtivoRepository>(context, listen: false).delete(statusAtivo).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': statusAtivo.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/status-ativos-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': statusAtivo.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/status-ativos-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: statusAtivo.desabilitado! ? AppColors.delete : AppColors.success,
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
                  title: Text((statusAtivo.nome ?? '').toString(),
                      style: TextStyle(
                        color: AppColors.cardGreyText,
                        fontWeight: FontWeight.w500,
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
