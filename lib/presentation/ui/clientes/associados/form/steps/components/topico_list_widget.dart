import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/presentation/ui/clientes/associados/models/dependente_topico_item.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class DependenteTopicoItemListWidget extends StatelessWidget {
  final DependenteTopicoItem topico;
  final Function(String) onDelete;
  final Function(String) editDependenteTopico;
  final bool isViewPage;

  const DependenteTopicoItemListWidget(
    this.onDelete,
    this.editDependenteTopico,
    this.topico,
    this.isViewPage, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      direction: isViewPage ? DismissDirection.none : DismissDirection.horizontal,
      endToStart: () => onDelete(topico.id),
      startToEnd: () => editDependenteTopico(topico.id),
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
              title: Text((topico.nome).toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.cardGreyText,
                  )),
              subtitle: Text((topico.email).toString(),
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
