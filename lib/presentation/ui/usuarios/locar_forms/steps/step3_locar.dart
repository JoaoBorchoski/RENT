import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locacao/data/repositories/comum/meio_pagamento_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/components/app_mouth_picker.dart';
import 'package:locacao/presentation/components/app_text_image.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/cartao.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Step3Locar extends StatefulWidget {
  final GlobalKey<FormState> formKey3;
  final TextEditingController selectedPaymentMethod;
  final TextEditingController numeroCartaoController;
  final TextEditingController dataValidadeController;
  final TextEditingController cvvController;
  final TextEditingController meioPagamentoIdController;
  final TextEditingController meioPagamentoNomeController;

  final Cartao cartao;
  final Locacoes locacao;
  final Ativo ativo;

  final Function() checkNextButtonIcon;
  bool showCardFields = false;

  Step3Locar({
    Key? key,
    required this.formKey3,
    required this.selectedPaymentMethod,
    required this.checkNextButtonIcon,
    required this.numeroCartaoController,
    required this.dataValidadeController,
    required this.cvvController,
    required this.meioPagamentoIdController,
    required this.meioPagamentoNomeController,
    required this.cartao,
    required this.locacao,
    required this.ativo,
  }) : super(key: key);

  @override
  State<Step3Locar> createState() => _Step3LocarState();
}

class _Step3LocarState extends State<Step3Locar> {
  @override
  void initState() {
    super.initState();
    widget.meioPagamentoNomeController.addListener(updateCardFieldsVisibility);
  }

  @override
  void dispose() {
    widget.meioPagamentoNomeController.removeListener(updateCardFieldsVisibility);
    super.dispose();
  }

  void updateCardFieldsVisibility() {
    setState(() {
      widget.showCardFields = widget.meioPagamentoNomeController.text.contains('Cartão');
    });
  }

  Widget get _buildValoresPagamento {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valor Total',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardColor, fontSize: 16),
                ),
                Text(
                  'R\$ ${double.parse(widget.locacao.valorTotal.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardColor, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valor de ${widget.ativo.nome}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
                Text(
                  'R\$ ${double.parse(widget.locacao.valorAtivoInicial.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valor de convidados',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
                Text(
                  'R\$ ${double.parse(widget.locacao.valorTotalConvidados.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Valor de outras taxas',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
                Text(
                  'R\$ 0',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  Widget get _selectMeioPagamenteo {
    return FormSelectInput(
      label: 'Método de pagamento',
      controllerValue: widget.meioPagamentoIdController,
      controllerLabel: widget.meioPagamentoNomeController,
      itemsCallback: (pattern) async => Provider.of<MeioPagamentoRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _cartaoInputs {
    return widget.showCardFields
        ? Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: FormTextInput(
                      controller: widget.numeroCartaoController,
                      keyboardType: TextInputType.number,
                      label: 'Número do cartão',
                      isRequired: true,
                      validator: (value) => value != '' ? null : 'Campo obrigatório!',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: MouthPickerInput(
                      controller: widget.dataValidadeController,
                      label: 'Data de validade',
                      isRequired: true,
                      onSelected: (DateTime? value) {
                        widget.cartao.dataValidade = DateFormat('MM/yyyy').format(value!).toString();
                        widget.checkNextButtonIcon;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FormTextInput(
                      controller: widget.cvvController,
                      label: 'CVV',
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      validator: (value) => value != '' ? null : 'Campo obrigatório!',
                    ),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meioPagamentoIdController.text != "") {
      widget.checkNextButtonIcon();
    } else {
      widget.checkNextButtonIcon();
    }

    return Form(
      key: widget.formKey3,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildValoresPagamento,
                  _selectMeioPagamenteo,
                ],
              ),
              widget.meioPagamentoNomeController.text != ""
                  ? widget.meioPagamentoNomeController.text.toUpperCase() == "PIX"
                      ? AppTextImage(
                          text: "Pix selecionado, avance para o próximo passo",
                          icon: Icons.qr_code,
                        )
                      : _cartaoInputs
                  : AppTextImage(
                      text: "Selecione um meio de pagamento",
                      icon: Icons.account_balance_wallet,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
