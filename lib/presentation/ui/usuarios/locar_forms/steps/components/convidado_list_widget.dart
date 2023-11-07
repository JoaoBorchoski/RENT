import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class ConvidadoItemListWidget extends StatelessWidget {
  final Convidados convidado;
  final Function(String) onDelete;
  final Function(String) editAtivoTopico;

  const ConvidadoItemListWidget(
    this.onDelete,
    this.editAtivoTopico,
    this.convidado, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppDismissible(
      direction: DismissDirection.horizontal,
      endToStart: () => onDelete(convidado.id!),
      startToEnd: () => editAtivoTopico(convidado.id!),
      onDoubleTap: () {},
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Card(
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (convidado.nome ?? '').toString(),
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
