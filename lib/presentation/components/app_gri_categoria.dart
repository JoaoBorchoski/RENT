// ignore: file_names
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/categorias.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class CatGrid extends StatefulWidget {
  final List<Categorias> categorias;
  final Function(Categorias) onSelect;

  const CatGrid({
    Key? key,
    required this.categorias,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<CatGrid> createState() => _CatGridState();
}

class _CatGridState extends State<CatGrid> {
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
                          'Categoria',
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
                          'Icone',
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
                  child: widget.categorias.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.categorias.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = index;
                                  widget.onSelect(widget.categorias[index]);
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
                                        child: Text(widget.categorias[index].nome.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: textSizeGrid, color: AppColors.primary)),
                                      ),
                                      SizedBox(
                                        width: sizeWidth * .45,
                                        // child: Text(widget.categorias[index].icone.toString(),
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(fontSize: textSizeGrid, color: AppColors.primary)),
                                        child: Icon(AppIcons.icones[widget.categorias[index].icone]),
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
