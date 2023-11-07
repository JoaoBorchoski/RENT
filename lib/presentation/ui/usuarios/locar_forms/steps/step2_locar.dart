// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/associados_repository.dart';
import 'package:locacao/data/repositories/clientes/cliente_preferencias_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/convidado_list_widget.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/modal_convidado_form.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class Step2Locar extends StatefulWidget {
  final GlobalKey<FormState> formKey2;

  final Function() checkNextButtonIcon;
  final List<Convidados> locacaoConvidados;
  Locacoes locacao = Locacoes();
  Ativo ativo = Ativo();

  Step2Locar({
    super.key,
    required this.checkNextButtonIcon,
    required this.locacao,
    required this.ativo,
    required this.formKey2,
    required this.locacaoConvidados,
  });

  @override
  State<Step2Locar> createState() => _Step2LocarState();
}

class _Step2LocarState extends State<Step2Locar> {
  bool isLastStep = false;
  int activeStep = 1;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  List<Widget> actionsScaffold = [];

  double _valorConvidadoAtivo = 0;

  @override
  void initState() {
    super.initState();
    _verificaValorAtivoConvidado();
  }

  // functions

  Future<void> _verificaValorAtivoConvidado() async {
    await Provider.of<ClientePreferenciasRepository>(context, listen: false)
        .getByClienteId(widget.ativo.clienteId!)
        .then((value) {
      if (value.id != null) setState(() => _valorConvidadoAtivo = value.valorConvidadoNaoSocio ?? 0);
    });
  }

  // Builder

  Widget get _listConvidado {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: widget.locacaoConvidados.isEmpty
                  ? AppNoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.locacaoConvidados.length,
                      itemBuilder: (context, index) {
                        final Convidados card = widget.locacaoConvidados[index];
                        return ConvidadoItemListWidget(removeConvidadoItem, editConvidadoItem, card);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _addButton {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppFormButton(
                submit: () => _openConvidadoFormModal(context),
                label: 'Adicionar novo convidado',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget get _valorQuantidadeConvidados {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total de convidados:',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardColor, fontSize: 16),
            ),
            Text(
              widget.locacaoConvidados.length.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardColor, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Limite de convidados:',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              widget.ativo.limiteConvidados.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total de convidados não sócios:',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              widget.locacaoConvidados.where((element) => !element.isAssociado!).length.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total de convidados sócios:',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              widget.locacaoConvidados.where((element) => element.isAssociado!).length.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // function to add convidado item

  void addConvidadoItem(
    String convidadoNome,
    int convidadoIdade,
    String convidadoEmail,
    String convidadoCodSocio,
    String convidadoTelefone,
  ) {
    final newConvidadoItem = Convidados(
      id: Random().nextDouble().toString(),
      nome: convidadoNome,
      email: convidadoEmail,
      idade: convidadoIdade,
      telefone: convidadoTelefone,
      codSocio: convidadoCodSocio,
      isAssociado: true,
    );

    Provider.of<AssociadosRepository>(context, listen: false)
        .verificaAssociadoByCodigoSocio(widget.ativo.clienteId!, convidadoCodSocio)
        .then((associado) async {
      setState(() {
        newConvidadoItem.isAssociado = associado;
      });
    }).then((value) => {
              setState(() {
                widget.locacaoConvidados.add(newConvidadoItem);
                widget.checkNextButtonIcon();

                if (!newConvidadoItem.isAssociado!) {
                  widget.locacao.valorTotalConvidados = widget.locacao.valorTotalConvidados! + _valorConvidadoAtivo;
                  widget.locacao.valorTotal = widget.locacao.valorTotal! + _valorConvidadoAtivo;
                }
              }),
              Navigator.of(context).pop(),
            });
  }

  void removeConvidadoItem(String id) {
    setState(() {
      bool? itemRemover = widget.locacaoConvidados.where((e) => e.id == id).first.isAssociado;
      if (!itemRemover!) {
        widget.locacao.valorTotalConvidados = widget.locacao.valorTotalConvidados! - _valorConvidadoAtivo;
        widget.locacao.valorTotal = widget.locacao.valorTotal! - _valorConvidadoAtivo;
      }
      widget.locacaoConvidados.removeWhere((tr) => tr.id == id);
      widget.checkNextButtonIcon();
    });
  }

  editConvidadoItem(String id) {
    final selectedConvidadoItem = widget.locacaoConvidados.firstWhere((tr) => tr.id == id);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ModalConvidadoForm(
          addConvidadoItem,
          "Editar item",
          onEdit: removeConvidadoItem,
          convidado: selectedConvidadoItem,
          editMode: true,
        );
      },
    ).then((value) => setState(() {
          widget.checkNextButtonIcon();
        }));
  }

  _openConvidadoFormModal(BuildContext context) {
    if (widget.locacaoConvidados.length >= widget.ativo.limiteConvidados!) {
      return showDialog(context: context, builder: (_) => AppPopErrorDialog(message: 'Limite de convidados atingido!'));
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ModalConvidadoForm(addConvidadoItem, "Adicionar novo convidado");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey2,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            _valorQuantidadeConvidados,
            _addButton,
            _listConvidado,
          ],
        ),
      ),
    );
  }
}
