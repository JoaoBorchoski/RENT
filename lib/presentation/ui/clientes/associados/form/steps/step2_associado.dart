import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/ui/clientes/associados/form/steps/components/modal_dependente_form.dart';
import 'package:locacao/presentation/ui/clientes/associados/form/steps/components/topico_list_widget.dart';
import 'package:locacao/presentation/ui/clientes/associados/models/dependente_topico_item.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class Step2Associado extends StatefulWidget {
  final GlobalKey<FormState> formKey2;

  final Function() checkNextButtonIcon;
  final bool isViewPage;
  final List<DependenteTopicoItem> dependentes;

  const Step2Associado({
    super.key,
    required this.checkNextButtonIcon,
    required this.formKey2,
    required this.dependentes,
    required this.isViewPage,
  });

  @override
  State<Step2Associado> createState() => _Step2Associado();
}

class _Step2Associado extends State<Step2Associado> {
  bool isLastStep = false;
  int activeStep = 1;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  List<Widget> actionsScaffold = [];

  @override
  void initState() {
    super.initState();
  }

  // Builder

  Widget get _listDependentes {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.isViewPage ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: widget.dependentes.isEmpty
                  ? AppNoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.dependentes.length,
                      itemBuilder: (context, index) {
                        final DependenteTopicoItem card = widget.dependentes[index];
                        return DependenteTopicoItemListWidget(removeDependenteItem, editDependenteItem, card, widget.isViewPage);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _addButton {
    return !widget.isViewPage
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppFormButton(
                      submit: () => _openDependenteFormModal(context),
                      label: 'Adicionar novo dependente',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          )
        : SizedBox.shrink();
  }

  // funcoes

  bool _verificaDependenteJaAdicionado(String email) {
    return widget.dependentes.where((element) => element.email == email).isNotEmpty;
  }

  // function to add dependente item

  void addDependenteItem(
    String dependenteNome,
    String dependenteEmail,
    String dependenteCpf,
    String dependenteCodigoSocio,
    int dependenteIdade,
    String dependenteTelefone,
  ) {
    final isInList = _verificaDependenteJaAdicionado(dependenteEmail);

    if (isInList) {
      showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(
            message: 'Dependente já adicionado.',
          );
        },
      );
    }

    if (!isInList) {
      final newDependenteItem = DependenteTopicoItem(
        id: Random().nextDouble().toString(),
        nome: dependenteNome,
        email: dependenteEmail,
        cpf: dependenteCpf,
        codigoSocio: dependenteCodigoSocio,
        idade: dependenteIdade,
        telefone: dependenteTelefone,
      );

      setState(() {
        widget.dependentes.add(newDependenteItem);
        widget.checkNextButtonIcon();
      });

      Navigator.of(context).pop();
    }
  }

  void removeDependenteItem(String id) {
    setState(() {
      widget.dependentes.removeWhere((tr) => tr.id == id);
      widget.checkNextButtonIcon();
    });
  }

  editDependenteItem(String id) {
    final selectedDependenteItem = widget.dependentes.firstWhere((tr) => tr.id == id);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ModalDependenteForm(
          addDependenteItem,
          "Editar item",
          onEdit: removeDependenteItem,
          dependente: selectedDependenteItem,
          editMode: true,
        );
      },
    ).then((value) => setState(() {
          widget.checkNextButtonIcon();
        }));
  }

  _openDependenteFormModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ModalDependenteForm(addDependenteItem, "Adicionar novo dependente");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey2,
      child: Column(
        children: [
          _addButton,
          _listDependentes,
        ],
      ),
    );
  }
}
