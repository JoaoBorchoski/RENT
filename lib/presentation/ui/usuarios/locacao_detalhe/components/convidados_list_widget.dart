import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class ConvidadoListWidget extends StatelessWidget {
  Convidados convidado;
  String locacaoId;

  ConvidadoListWidget({
    required this.convidado,
    required this.locacaoId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      direction: DismissDirection.none,
      endToStart: () {},
      startToEnd: () {},
      onDoubleTap: locacaoId != ''
          ? () {
              Map data = {'id': convidado.id, 'view': true, 'idLocacao': locacaoId};
              Navigator.pushNamed(
                context,
                '/convidado-form',
                arguments: data,
              );
            }
          : () {},
      body: Column(
        children: <Widget>[
          Card(
            color: convidado.isAssociado! ? AppColors.success : AppColors.alert,
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                color: AppColors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    (convidado.nome ?? '').toString(),
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Idade: ${convidado.idade}',
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                  trailing: convidado.isPresente != null
                      ? Text(
                          (convidado.isPresente!) ? 'Compareceu' : 'Não Compareceu',
                          style: TextStyle(
                            color: AppColors.black,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
