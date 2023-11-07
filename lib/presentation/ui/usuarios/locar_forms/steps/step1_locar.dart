// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/setp1_dia_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/step1_horas_locar.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Step1Locar extends StatefulWidget {
  final TextEditingController controllerDataInicio;
  final TextEditingController controllerDataFim;
  final TextEditingController controllerHoraInicio;
  final TextEditingController controllerHoraFim;
  final TextEditingController controllerPagamentoHoraDiaValue;
  final TextEditingController controllerPagamentoDiaHoraNome;
  final DateRangePickerController datePickerController;

  final AtivoController controllerAtivo;
  final GlobalKey<FormState> formKey1;
  final Locacoes locacao;
  final Ativo ativo;

  final Function() checkNextButtonIcon;

  const Step1Locar({
    super.key,
    required this.locacao,
    required this.ativo,
    required this.controllerDataInicio,
    required this.controllerDataFim,
    required this.controllerHoraInicio,
    required this.controllerHoraFim,
    required this.controllerPagamentoHoraDiaValue,
    required this.controllerPagamentoDiaHoraNome,
    required this.checkNextButtonIcon,
    required this.controllerAtivo,
    required this.formKey1,
    required this.datePickerController,
  });

  @override
  State<Step1Locar> createState() => _Step1LocarState();
}

class _Step1LocarState extends State<Step1Locar> {
  bool isLastStep = false;
  int activeStep = 0;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  String tipoAtivoLocacao = '';

  @override
  void initState() {
    super.initState();
    tipoAtivoLocacao = widget.controllerAtivo.pagamentoDiaHoraValue!.text;
  }

  // Builder

  Widget get _erroBuscarTipoPagamento {
    return Text(
      'Erro ao buscar tipo de locação, tente novamente mais tarde',
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey1,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            tipoAtivoLocacao == 'hora'
                ? Step1HorasLocarWidget(
                    checkNextButtonIcon: widget.checkNextButtonIcon,
                    controllerDataInicio: widget.controllerDataInicio,
                    controllerHoraFim: widget.controllerHoraFim,
                    controllerHoraInicio: widget.controllerHoraInicio,
                    locacao: widget.locacao,
                    ativoId: widget.ativo.id!,
                    ativo: widget.ativo,
                    limiteHorasSeguidas: widget.controllerAtivo.limiteDiasHorasSeguidas!.text,
                  )
                : tipoAtivoLocacao == 'dia'
                    ? Step1DiaLocarWidget(
                        controllerDataInicio: widget.controllerDataInicio,
                        controllerDataFim: widget.controllerDataFim,
                        controllerHoraInicio: widget.controllerHoraInicio,
                        controllerHoraFim: widget.controllerHoraFim,
                        datePickerController: widget.datePickerController,
                        locacao: widget.locacao,
                        ativo: widget.ativo,
                        checkNextButtonIcon: widget.checkNextButtonIcon,
                        ativoId: widget.ativo.id!,
                      )
                    : _erroBuscarTipoPagamento,
          ],
        ),
      ),
    );
  }
}
