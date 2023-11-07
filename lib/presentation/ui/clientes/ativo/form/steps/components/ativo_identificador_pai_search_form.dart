// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/shared/suggestion_identificador.dart';
import 'package:locacao/presentation/components/app_select_identificador.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class AtivoIdentificadorPaiSearchForm extends StatefulWidget {
  AtivoIdentificadorPaiSearchForm({
    super.key,
    required this.controllerValueIdentificador,
    required this.controllerNomeIdentificador,
    required this.ativo,
    required this.view,
    // required this.onSelectedExtra,
  });
  final TextEditingController controllerValueIdentificador;
  final TextEditingController controllerNomeIdentificador;
  final bool view;
  late bool hasTabPreco;
  final Ativo ativo;
  // final Function(bool) onSelectedExtra;

  @override
  State<AtivoIdentificadorPaiSearchForm> createState() => _AtivoIdentificadorPaiSearchFormState();
}

class _AtivoIdentificadorPaiSearchFormState extends State<AtivoIdentificadorPaiSearchForm> {
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'Identificador Pai',
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
                    controller: widget.controllerNomeIdentificador,
                  ),
                  suggestionsCallback: (pattern) async {
                    if (widget.controllerNomeIdentificador.text != '') {
                      widget.controllerNomeIdentificador;
                    }
                    return Provider.of<AtivoRepository>(context, listen: false).list(pattern, 20, 1, []).then((data) {
                      // widget.onSelectedExtra(false);
                      List<SuggestionModelIdentificador> suggestions = [];
                      suggestions = List<SuggestionModelIdentificador>.from(
                        data.map((model) => SuggestionModelIdentificador.fromJson(model)),
                      );
                      return Future.value(suggestions
                          .map((e) => {
                                'value': e.value,
                                'label': e.label,
                                'nome': e.nome,
                                'categoria': e.categoria,
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
                      widget.controllerNomeIdentificador.text = suggestion['label']!;
                      widget.ativo.identificador = suggestion['value']!;
                      widget.ativo.identificador = suggestion['value']!;
                    });
                  },
                  hideSuggestionsOnKeyboardHide: true,
                  noItemsFoundBuilder: (context) {
                    return Text("Sem outros ativos para cadastrar identificador");
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
                          widget.controllerNomeIdentificador.text == ''
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectIdentificadorDialog(
                                      cancelButton: true,
                                      message: 'Selecione um Ativo como identificador',
                                      confirma: (ativoSel) {
                                        setState(() {
                                          widget.controllerNomeIdentificador.text = ativoSel.nome!;
                                          widget.ativo.identificador = ativoSel.id!;
                                          widget.ativo.identificador = ativoSel.nome!;
                                        });
                                      },
                                    );
                                  },
                                )
                              : setState(() {
                                  widget.controllerNomeIdentificador.text = '';
                                  widget.ativo.identificador = '';
                                  widget.ativo.identificador = '';
                                  // widget.onSelectedExtra(false);
                                });
                        },
                        icon: widget.controllerNomeIdentificador.text == ''
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
