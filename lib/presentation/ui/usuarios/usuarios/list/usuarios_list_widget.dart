import 'package:locacao/data/repositories/usuarios/usuarios_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/usuarios/usuarios.dart';
import 'package:provider/provider.dart';

class UsuariosListWidget extends StatelessWidget {
  final Usuarios usuarios;

  const UsuariosListWidget(
    this.usuarios, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/usuario'),
      endToStart: () async {
        await Provider.of<UsuariosRepository>(context, listen: false).delete(usuarios).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': usuarios.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/usuario-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': usuarios.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/usuario-form', arguments: data);
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
              title: Text((usuarios.nome ?? '').toString(),
                  style: TextStyle(
                    color: AppColors.cardGreyText,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text((usuarios.email ?? '').toString(),
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
