import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:provider/provider.dart';

class AssociadosUsuarioLoginListWidget extends StatelessWidget {
  final Associados associados;

  const AssociadosUsuarioLoginListWidget(
    this.associados, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      endToStart: () {},
      startToEnd: () {},
      onDoubleTap: () {
        authentication.usuarioAssociadoIdSelecionado = associados.clienteId;
        Navigator.of(context).pushNamed('/locar');
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
                child: ListTile(
                  trailing: Text('Cód Sócio: ${associados.codigoSocio}'),
                  title: Text(
                    (associados.clienteNome ?? '').toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.cardGreyText,
                    ),
                  ),
                  subtitle: Text(
                    ('Status: ${associados.statusAssociadoNome ?? "Erro"}').toString(),
                    style: TextStyle(
                      color: AppColors.cardGreyText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
