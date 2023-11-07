import 'package:locacao/data/repositories/clientes/categorias_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/categorias.dart';
import 'package:provider/provider.dart';

class CategoriasListWidget extends StatelessWidget {
  final Categorias categorias;

  const CategoriasListWidget(
    this.categorias, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/categoria'),
      endToStart: () async {
        await Provider.of<CategoriasRepository>(context, listen: false).delete(categorias).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': categorias.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/categoria-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': categorias.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/categoria-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: categorias.desabilitado! ? AppColors.delete : AppColors.success,
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
                  leading: Icon(AppIcons.icones[categorias.icone]),
                  title: Text((categorias.nome ?? '').toString(),
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
