import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/modal_topico_form.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/topico_list_widget.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/shared/themes/app_colors.dart';

import '../../../../../components/app_form_button.dart';

class Step4 extends StatefulWidget {
  final GlobalKey<FormState> formKey3;

  final bool isViewPage;
  final Function() checkNextButtonIcon;
  final List<AtivoTopicoItem> ativoOfereceItems;

  const Step4({
    super.key,
    required this.isViewPage,
    required this.checkNextButtonIcon,
    required this.formKey3,
    required this.ativoOfereceItems,
  });

  @override
  State<Step4> createState() => _Step4State();
}

class _Step4State extends State<Step4> {
  bool isLastStep = false;
  int activeStep = 2;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  List<Widget> actionsScaffold = [];

  // Builder

  Widget get _listTopico {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            widget.isViewPage ? MediaQuery.of(context).size.height * 0.6 : MediaQuery.of(context).size.height * 0.5,
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: widget.ativoOfereceItems.isEmpty
                  ? AppNoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.ativoOfereceItems.length,
                      itemBuilder: (context, index) {
                        final AtivoTopicoItem card = widget.ativoOfereceItems[index];
                        return AtivoTopicoItemListWidget(
                            removeAtivoOfereceItem, editAtivoTopicoItem, card, widget.isViewPage);
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
                      submit: () => _openTransactionFormModal(context),
                      label: 'Adicionar novo item',
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

  void addAtivoOfereceItem(String ofereceTopico, String ofereceIcone) {
    final newAtivoOfereceItem = AtivoTopicoItem(
      id: Random().nextDouble().toString(),
      topico: ofereceTopico,
      icone: ofereceIcone,
    );

    setState(() {
      widget.ativoOfereceItems.add(newAtivoOfereceItem);
      widget.checkNextButtonIcon();
    });

    Navigator.of(context).pop();
  }

  void editAtivoOfereceItem(String id, String ofereceTopico, String ofereceIcone) {
    final selectedAtivoTopicoItemIndex = widget.ativoOfereceItems.indexWhere((item) => item.id == id);

    if (selectedAtivoTopicoItemIndex != -1) {
      final selectedAtivoTopicoItem = widget.ativoOfereceItems[selectedAtivoTopicoItemIndex];
      widget.ativoOfereceItems.removeAt(selectedAtivoTopicoItemIndex);
      widget.ativoOfereceItems.insert(
          selectedAtivoTopicoItemIndex,
          AtivoTopicoItem(
            id: selectedAtivoTopicoItem.id,
            topico: ofereceTopico,
            icone: ofereceIcone,
          ));

      setState(() {
        widget.checkNextButtonIcon();
      });

      Navigator.of(context).pop();
    }
  }

  void removeAtivoOfereceItem(String id) {
    setState(() {
      widget.ativoOfereceItems.removeWhere((tr) => tr.id == id);
      widget.checkNextButtonIcon();
    });
  }

  editAtivoTopicoItem(String id) {
    final selectedAtivoTopicoItemIndex = widget.ativoOfereceItems.indexWhere((item) => item.id == id);

    if (selectedAtivoTopicoItemIndex != -1) {
      final selectedAtivoTopicoItem = widget.ativoOfereceItems[selectedAtivoTopicoItemIndex];

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return ModalTopicoForm(
            addAtivoOfereceItem,
            "Editar item",
            onEditId: id,
            onEdit: editAtivoOfereceItem,
            ativoTopico: selectedAtivoTopicoItem,
            editMode: true,
          );
        },
      );
    }
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return ModalTopicoForm(addAtivoOfereceItem, "Adicionar novo item");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey3,
      child: Column(
        children: [
          Column(
            children: [
              _addButton,
              _listTopico,
            ],
          ),
        ],
      ),
    );
  }
}
