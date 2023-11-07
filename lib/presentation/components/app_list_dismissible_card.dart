// ignore_for_file: file_names

import 'package:locacao/domain/models/shared/menu_options.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AppDismissible extends StatelessWidget {
  final Widget body;
  final DismissDirection? direction;
  final void Function() endToStart;
  final void Function() startToEnd;
  final void Function() onDoubleTap;
  final List<MenuOptions>? longPressOptions;

  const AppDismissible({
    super.key,
    required this.body,
    this.direction,
    required this.endToStart,
    required this.startToEnd,
    required this.onDoubleTap,
    this.longPressOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: direction ?? DismissDirection.none,
      background: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: Colors.amber[900],
        alignment: AlignmentDirectional.centerStart,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) {
        String acao = '';
        switch (direction) {
          case DismissDirection.endToStart:
            acao = 'excluir';
            break;
          case DismissDirection.startToEnd:
            acao = 'editar';
            break;
          default:
            false;
        }
        return showDialog(
          context: context,
          builder: (context) {
            return AppPopAlertDialog(
              title: acao[0].toUpperCase() + acao.substring(1),
              message: 'Deseja realmente $acao esse registro?',
              botoes: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'Não',
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Sim',
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        switch (direction) {
          case DismissDirection.endToStart:
            endToStart();
            break;
          case DismissDirection.startToEnd:
            startToEnd();
            break;
          default:
        }
      },
      key: UniqueKey(),
      child: GestureDetector(
        onDoubleTap: () {
          onDoubleTap();
        },
        child: body,
      ),
    );
  }

  Future<dynamic>? longPress(context) {
    if (longPressOptions == null || longPressOptions!.isEmpty) return null;
    if (longPressOptions!.length == 1) return longPressOptions![0].action!();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            SizedBox(
              width: 250,
              height: longPressOptions!.length * 50,
              child: ListView.builder(
                itemCount: longPressOptions!.length,
                itemBuilder: ((context, index) {
                  return TextButton(
                    onPressed: () {
                      longPressOptions![index].action!();
                    },
                    child: Row(
                      children: [
                        longPressOptions![index].icon!,
                        Text(
                          ' ${longPressOptions![index].label}',
                          style: TextStyle(color: AppColors.primary),
                        )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        );
      },
    );
  }
}
