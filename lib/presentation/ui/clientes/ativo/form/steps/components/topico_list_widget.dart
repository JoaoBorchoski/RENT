import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AtivoTopicoItemListWidget extends StatelessWidget {
  final AtivoTopicoItem topico;
  final Function(String) onDelete;
  final Function(String) editAtivoTopico;
  final bool isViewPage;

  const AtivoTopicoItemListWidget(
    this.onDelete,
    this.editAtivoTopico,
    this.topico,
    this.isViewPage, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      direction: isViewPage ? DismissDirection.none : DismissDirection.horizontal,
      endToStart: () => onDelete(topico.id),
      startToEnd: () => editAtivoTopico(topico.id),
      onDoubleTap: () {},
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 5,
            ),
            color: AppColors.lightGrey,
            elevation: 5,
            child: ListTile(
              leading: Icon(AppIcons.icones[topico.icone]),
              title: Text((topico.topico).toString(),
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
