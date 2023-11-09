// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:locacao/data/repositories/clientes/categorias_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/shared/suggestion_categoria.dart';
import 'package:locacao/presentation/components/app_select_categoria.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/shared/utils/arguments.dart';
import 'package:provider/provider.dart';

class AtivoCategoriaSearchForm extends StatefulWidget {
  AtivoCategoriaSearchForm({
    super.key,
    required this.controllerNomeCategoria,
    required this.controllerIdCategoria,
    required this.view,
    // required this.onSelectedExtra,
    required this.ativo,
  });
  final TextEditingController controllerNomeCategoria;
  final TextEditingController controllerIdCategoria;
  final bool view;
  late bool hasTabPreco;
  final Ativo ativo;
  // final Function(bool) onSelectedExtra;

  @override
  State<AtivoCategoriaSearchForm> createState() => _AtivoCategoriaSearchFormState();
}

class _AtivoCategoriaSearchFormState extends State<AtivoCategoriaSearchForm> {
  @override
  Widget build(context) {
    Authentication authentication = Provider.of(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'Categoria',
              style: TextStyle(color: AppColors.cardColor, fontSize: 14),
            ),
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              SizedBox(
                height: 65,
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(24),
                        border: OutlineInputBorder(),
                        hintText: 'Selecione',
                        fillColor: widget.view ? AppColors.disabled : AppColors.background),
                    enabled: !widget.view,
                    controller: widget.controllerNomeCategoria,
                  ),
                  suggestionsCallback: (pattern) async {
                    if (widget.controllerNomeCategoria.text != '') {
                      widget.controllerNomeCategoria;
                    }
                    return Provider.of<CategoriasRepository>(context, listen: false)
                        .list(pattern, 20, 1, []).then((data) {
                      // widget.onSelectedExtra(false);
                      List<SuggestionModelCategoria> suggestions = [];
                      suggestions = List<SuggestionModelCategoria>.from(
                        data.map((model) => SuggestionModelCategoria.fromJson(model)),
                      );

                      return Future.value(suggestions
                          .map((e) => {
                                'value': e.value,
                                'label': e.label,
                                'nome': e.nome,
                                'icone': e.icone,
                              })
                          .toList());
                    });
                  },
                  itemBuilder: (context, Map<String, String> suggestion) {
                    return ListTile(
                      title: Text(suggestion['label']!),
                    );
                  },
                  onSuggestionSelected: (Map<String, String> suggestion) {
                    setState(() {
                      widget.controllerNomeCategoria.text = suggestion['label']!;
                      widget.controllerIdCategoria.text = suggestion['value']!;
                      widget.ativo.categoriaId = suggestion['value']!;
                      widget.ativo.categoriasNome = suggestion['value']!;
                    });
                  },
                  hideSuggestionsOnKeyboardHide: true,
                  noItemsFoundBuilder: (context) {
                    return authentication.isPermitted('/categoria', 'permitCreate')
                        ? GestureDetector(
                            onTap: () {
                              Map data = {'route': '/ativos-form'};
                              Navigator.of(context).pushNamed('/categoria-form', arguments: Arguments(data));
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.background,
                                      size: 25,
                                    ),
                                    Text(
                                      'Adicionar Nova Categoria',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.background,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
              ),
              widget.view
                  ? SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          widget.controllerNomeCategoria.text == ''
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectCategoriaDialog(
                                      cancelButton: true,
                                      message: 'Selecione um Categoria',
                                      confirma: (categoriaSel) {
                                        setState(() {
                                          widget.controllerNomeCategoria.text = categoriaSel.nome!;
                                          widget.controllerIdCategoria.text = categoriaSel.id!;
                                          widget.ativo.categoriaId = categoriaSel.id!;
                                          widget.ativo.categoriasNome = categoriaSel.nome!;
                                        });
                                      },
                                    );
                                  },
                                )
                              : setState(() {
                                  widget.controllerNomeCategoria.text = '';
                                  widget.controllerIdCategoria.text = '';
                                  widget.ativo.categoriaId = '';
                                  widget.ativo.categoriasNome = '';
                                  // widget.onSelectedExtra(false);
                                });
                        },
                        icon: widget.controllerNomeCategoria.text == ''
                            ? Icon(Icons.search)
                            : Icon(
                                Icons.close_rounded,
                                color: AppColors.delete,
                              ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
