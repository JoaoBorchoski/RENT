// ignore: file_names
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class IdentificadorGrid extends StatefulWidget {
  final List<Ativo> ativos;
  final Function(Ativo) onSelect;

  const IdentificadorGrid({
    Key? key,
    required this.ativos,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<IdentificadorGrid> createState() => _IdentificadorGridState();
}

class _IdentificadorGridState extends State<IdentificadorGrid> {
  double textSizeGrid = 16;
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                  color: AppColors.primary,
                  child: Row(
                    children: [
                      SizedBox(
                        width: sizeWidth * .45,
                        child: Text(
                          'Ativo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textSizeGrid,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth * .45,
                        child: Text(
                          'Categoria',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: textSizeGrid,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeWidth * .5,
                  width: sizeWidth * .9,
                  child: widget.ativos.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.ativos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = index;
                                  widget.onSelect(widget.ativos[index]);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected == index ? Colors.grey[300] : AppColors.background,
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.primary),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: sizeWidth * .45,
                                        child: Text(widget.ativos[index].nome.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: textSizeGrid, color: AppColors.primary)),
                                      ),
                                      SizedBox(
                                        width: sizeWidth * .45,
                                        child: Text(widget.ativos[index].categoriasNome.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: textSizeGrid, color: AppColors.primary)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Text('Nenhum item encontrado'),
                          ),
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
