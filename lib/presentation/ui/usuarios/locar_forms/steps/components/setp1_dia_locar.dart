import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/cliente_preferencias_repository.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/date_picker_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/parse_to_date_time.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Step1DiaLocarWidget extends StatefulWidget {
  final TextEditingController controllerDataInicio;
  final TextEditingController controllerDataFim;
  final TextEditingController controllerHoraInicio;
  final TextEditingController controllerHoraFim;
  final DateRangePickerController datePickerController;

  final Locacoes locacao;
  final Ativo ativo;
  final String ativoId;

  final Function() checkNextButtonIcon;

  const Step1DiaLocarWidget({
    required this.controllerDataInicio,
    required this.controllerDataFim,
    required this.controllerHoraInicio,
    required this.controllerHoraFim,
    required this.datePickerController,
    required this.locacao,
    required this.ativo,
    required this.checkNextButtonIcon,
    required this.ativoId,
    super.key,
  });

  @override
  State<Step1DiaLocarWidget> createState() => _Step1DiaLocarWidgetState();
}

class _Step1DiaLocarWidgetState extends State<Step1DiaLocarWidget> {
  final List<DateTime> blackoutDates = [];
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    _fetchData();
    _verificaHoraFinalInicial();
    super.initState();
  }

  Future<void> _verificaHoraFinalInicial() async {
    await Provider.of<ClientePreferenciasRepository>(context, listen: false)
        .getByClienteId(widget.ativo.clienteId!)
        .then((value) {
      if (value.id != null) {
        setState(
          () => {
            widget.locacao.horaInicio = value.horaInicio,
            widget.locacao.horaFim = value.horaFim,
            widget.controllerHoraInicio.text = value.horaInicio!,
            widget.controllerHoraFim.text = value.horaFim!,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (blackoutDates.isEmpty) {
      if (_isLoading) {
        return Center(child: LoadWidget());
      }
    }
    return Column(
      children: [
        _textField,
        _datePickerBuild,
      ],
    );
  }

  Widget get _textField {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: const [
          Text(
            'Esse ativo é locado por dia',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selecione um dia disponível para sua reserva',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _datePickerBuild {
    return DatePickerLocar(
      onSelectionChanged: (date) {
        widget.locacao.dataInicio = date.value;
        widget.locacao.dataFim = date.value;
        widget.locacao.horaFim = '00:00:00';
        widget.locacao.horaInicio = '00:00:00';
        widget.checkNextButtonIcon;
      },
      limiteAntecedenciaLocar: widget.ativo.limiteAntecedenciaLocar ?? 30,
      datePickerController: widget.datePickerController,
      blackoutDates: blackoutDates,
      specialDates: const [],
    );
  }

  // Widget get _dataInicioLocacao {
  //   return DatePickerInput(
  //     label: 'Data Início Locação',
  //     isRequired: true,
  //     controller: widget.controllerDataInicio,
  //     onSelected: (data) {
  //       widget.locacao.dataInicio = data;
  //       widget.checkNextButtonIcon;
  //     },
  //   );
  // }

  // Widget get _dataFimLocacao {
  //   return DatePickerInput(
  //     label: 'Data Fim Locação',
  //     isRequired: true,
  //     controller: widget.controllerDataFim,
  //     onSelected: (data) {
  //       widget.locacao.dataFim = data;
  //       widget.checkNextButtonIcon;
  //     },
  //   );
  // }

  Future<void> _fetchData() async {
    List<AtivoUsuariosLocacao> indisponiveisHoras = [];
    final agora = parseToDateTime(DateTime.now().toString(), '00:00');
    await Provider.of<LocacoesRepository>(context, listen: false)
        .listByPeriodo(agora.toString(), '2023-11-14', widget.ativoId)
        .then(
      (value) {
        indisponiveisHoras = value;
        setState(() {
          blackoutDates.clear();
          for (var indisponivel in indisponiveisHoras) {
            DateTime dataHoraInicio =
                parseToDateTime(indisponivel.locacaoDataInicio.toString(), indisponivel.locacaoHoraInicio.toString());
            DateTime dataHoraFinal =
                parseToDateTime(indisponivel.locacaoDataTermino.toString(), indisponivel.locacaoHoraTermino.toString());

            blackoutDates.add(dataHoraInicio);

            DateTime currentDate = dataHoraInicio;

            while (currentDate.isBefore(dataHoraFinal) && (currentDate.day != dataHoraFinal.day)) {
              currentDate = currentDate.add(Duration(days: 1));
              blackoutDates.add(currentDate);
            }
          }
          _isLoading = false;
        });
      },
    );
  }
}
