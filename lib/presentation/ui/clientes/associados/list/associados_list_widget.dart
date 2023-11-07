import 'package:locacao/data/repositories/clientes/associados_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:provider/provider.dart';

class AssociadosListWidget extends StatelessWidget {
  final Associados associados;

  const AssociadosListWidget(
    this.associados, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.tipoUser == 'Cliente'
          ? authentication.permitUpdateDelete('/associado')
          : DismissDirection.none,
      endToStart: () async {
        await Provider.of<AssociadosRepository>(context, listen: false).delete(associados).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': associados.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/associado-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': associados.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/associado-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: associados.statusAssociadoCor != null ? statusColorHex(associados.statusAssociadoCor) : Colors.black,
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
                elevation: 0,
                child: ListTile(
                  title: Text((associados.usuariosNome ?? '').toString(),
                      style: TextStyle(
                        color: AppColors.cardGreyText,
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: Text('Cód. sócio: ${(associados.codigoSocio ?? '').toString()}',
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
