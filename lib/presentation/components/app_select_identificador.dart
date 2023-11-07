import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/presentation/components/app_grid_identificador.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class SelectIdentificadorDialog extends StatefulWidget {
  const SelectIdentificadorDialog({
    Key? key,
    required this.message,
    required this.cancelButton,
    required this.confirma,
    this.popToRoute,
  }) : super(key: key);

  final String message;
  final bool cancelButton;
  final bool? popToRoute;
  final Function(Ativo) confirma;

  @override
  State<SelectIdentificadorDialog> createState() => _SelectIdentificadorDialogState();
}

class _SelectIdentificadorDialogState extends State<SelectIdentificadorDialog> {
  late Ativo identificador = Ativo();
  String filter = '';
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(10, 0, 10, 25),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Text(
                widget.message,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: AppSearchBar(
                onSearch: (search) {
                  setState(() {
                    filter = search;
                  });
                },
              ),
            ),
            FutureBuilder(
              future: Provider.of<AtivoRepository>(context, listen: false).list(filter, 20, 1, []),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Consumer<AtivoRepository>(builder: (ctx, ativos, child) {
                    return IdentificadorGrid(
                      ativos: ativos.items,
                      onSelect: (identificadorSel) {
                        identificador = identificadorSel;
                      },
                    );
                  });
                } else if (snapshot.hasError) {
                  Navigator.of(context).pop(true);
                  return SizedBox(
                    height: 450,
                    child: LoadWidget(),
                    // child: LoadWidget(invertColors: true),
                  );
                } else {
                  return SizedBox(
                    height: sizeWidth * 0.5,
                    child: LoadWidget(),
                    // child: LoadWidget(invertColors: true),
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        side: const BorderSide(color: AppColors.cardColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: AppColors.cardColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.confirma(identificador);
                        });
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Selecionar'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
