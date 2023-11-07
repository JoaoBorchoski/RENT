import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/cliente_preferencias_repository.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class Step2 extends StatefulWidget {
  final GlobalKey<FormState> formKey2;
  final TextEditingController controllerLimiteConvidadosExtra;
  final TextEditingController controllerLimiteDiasHorasSeguidos;
  final TextEditingController controllerLimiteConvidados;
  final TextEditingController controllerLimiteAntecedenciaLocar;
  final TextEditingController controllerPagamentoDiaHora;

  final bool isViewPage;
  final bool isEditPage;
  final Function() checkNextButtonIcon;
  const Step2({
    super.key,
    required this.isViewPage,
    required this.checkNextButtonIcon,
    required this.formKey2,
    required this.isEditPage,
    required this.controllerLimiteConvidadosExtra,
    required this.controllerLimiteDiasHorasSeguidos,
    required this.controllerLimiteConvidados,
    required this.controllerLimiteAntecedenciaLocar,
    required this.controllerPagamentoDiaHora,
  });

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  bool isLastStep = false;
  int activeStep = 1;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  List<Widget> actionsScaffold = [];

  @override
  void initState() {
    super.initState();
    if (!widget.isEditPage && !widget.isViewPage) _buscaLimiteAntecedenciaGeral();
  }

  Future<void> _buscaLimiteAntecedenciaGeral() async {
    await Provider.of<ClientePreferenciasRepository>(context, listen: false).getByClienteId("").then((value) {
      if (value.id != null) {
        setState(
            () => widget.controllerLimiteAntecedenciaLocar.text = (value.limiteLocarAntecedenciaGeral ?? 0).toString());
      }
    });
  }

  // Builder

  Widget get _limiteLocarAntecedenciaField {
    return FormTextInput(
      label: 'Limite de Locar com Antecedência (meses)',
      keyboardType: TextInputType.number,
      type: TextInputTypes.number,
      isDisabled: widget.isViewPage,
      controller: widget.controllerLimiteAntecedenciaLocar,
      isRequired: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Campo obrigatório!';
        }
        if (value.contains('.') || value.contains(',')) {
          return 'Por favor, insira um número inteiro válido.';
        }
        if (int.parse(widget.controllerLimiteAntecedenciaLocar.text) <= 0) {
          return 'Por favor, insira um número maior que 0.';
        }
        return null;
      },
    );
  }

  Widget get _limiteConvidadosField {
    return FormTextInput(
      label: 'Limite de Convidados',
      keyboardType: TextInputType.number,
      type: TextInputTypes.number,
      isDisabled: widget.isViewPage,
      controller: widget.controllerLimiteConvidados,
      isRequired: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Campo obrigatório!';
        } else if (value.contains('.') || value.contains(',')) {
          return 'Por favor, insira um número inteiro válido.';
        }
        return null;
      },
    );
  }

  Widget get _limiteDiasHorasSeguidasField {
    return FormTextInput(
      label: 'Limite de Horas Seguidas',
      keyboardType: TextInputType.number,
      type: TextInputTypes.number,
      isDisabled: widget.isViewPage,
      controller: widget.controllerLimiteDiasHorasSeguidos,
      isRequired: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Campo obrigatório!';
        } else if (value.contains('.') || value.contains(',')) {
          return 'Por favor, insira um número inteiro válido.';
        }
        return null;
      },
    );
  }

  Widget get _limiteConvidadosExtraField {
    return FormTextInput(
      label: 'Limite de Convidados Extra',
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      type: TextInputTypes.number,
      isDisabled: widget.isViewPage,
      controller: widget.controllerLimiteConvidadosExtra,
      isRequired: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Campo obrigatório!';
        } else if (value.contains('.') || value.contains(',')) {
          return 'Por favor, insira um número inteiro válido.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey2,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            _limiteLocarAntecedenciaField,
            _limiteConvidadosField,
            _limiteConvidadosExtraField,
            widget.controllerPagamentoDiaHora.text == 'hora' ? _limiteDiasHorasSeguidasField : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
