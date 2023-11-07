import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/modal_topico_form.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/topico_list_widget.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/shared/themes/app_colors.dart';

import '../../../../../components/app_form_button.dart';

class Step5 extends StatefulWidget {
  final bool isViewPage;
  final Function() checkNextButtonIcon;
  final List<AtivoTopicoItem> ativoRegraItems;

  const Step5({
    super.key,
    required this.isViewPage,
    required this.checkNextButtonIcon,
    required this.ativoRegraItems,
  });

  @override
  State<Step5> createState() => _Step5State();
}

class _Step5State extends State<Step5> {
  bool isLastStep = false;
  int activeStep = 3;
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
              child: widget.ativoRegraItems.isEmpty
                  ? AppNoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.ativoRegraItems.length,
                      itemBuilder: (context, index) {
                        final AtivoTopicoItem card = widget.ativoRegraItems[index];
                        return AtivoTopicoItemListWidget(
                            removeAtivoRegraItem, editAtivoTopicoItem, card, widget.isViewPage);
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
                      label: 'Adicionar nova Regra',
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

  void addAtivoRegraItem(String regraTopico, String regraIcone) {
    final newAtivoRegraItem = AtivoTopicoItem(
      id: Random().nextDouble().toString(),
      topico: regraTopico,
      icone: regraIcone,
    );

    setState(() {
      widget.ativoRegraItems.add(newAtivoRegraItem);
      widget.checkNextButtonIcon();
    });

    Navigator.of(context).pop();
  }

  void editAtivoRegraItem(String id, String regraTopico, String regraIcone) {
    final selectedAtivoTopicoItemIndex = widget.ativoRegraItems.indexWhere((item) => item.id == id);

    if (selectedAtivoTopicoItemIndex != -1) {
      final selectedAtivoTopicoItem = widget.ativoRegraItems[selectedAtivoTopicoItemIndex];
      widget.ativoRegraItems.removeAt(selectedAtivoTopicoItemIndex);
      widget.ativoRegraItems.insert(
          selectedAtivoTopicoItemIndex,
          AtivoTopicoItem(
            id: selectedAtivoTopicoItem.id,
            topico: regraTopico,
            icone: regraIcone,
          ));

      setState(() {
        widget.checkNextButtonIcon();
      });

      Navigator.of(context).pop();
    }
  }

  void removeAtivoRegraItem(String id) {
    setState(() {
      widget.ativoRegraItems.removeWhere((tr) => tr.id == id);
      widget.checkNextButtonIcon();
    });
  }

  editAtivoTopicoItem(String id) {
    final selectedAtivoTopicoItemIndex = widget.ativoRegraItems.indexWhere((item) => item.id == id);

    if (selectedAtivoTopicoItemIndex != -1) {
      final selectedAtivoTopicoItem = widget.ativoRegraItems[selectedAtivoTopicoItemIndex];

      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return ModalTopicoForm(
            addAtivoRegraItem,
            "Editar regra",
            onEditId: id,
            onEdit: editAtivoRegraItem,
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
        return ModalTopicoForm(addAtivoRegraItem, "Adicionar nova regra");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            _addButton,
            _listTopico,
          ],
        ),
      ],
    );
  }
}
