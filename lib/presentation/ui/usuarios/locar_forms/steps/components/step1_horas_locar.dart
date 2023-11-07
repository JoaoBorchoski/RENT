// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/cliente_preferencias_repository.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/app_date_picker.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_time_picker.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/horas_calendario_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/parse_to_date_time.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Step1HorasLocarWidget extends StatefulWidget {
  final TextEditingController controllerDataInicio;
  final TextEditingController controllerHoraInicio;
  final TextEditingController controllerHoraFim;
  final Locacoes locacao;
  final String ativoId;
  final Ativo ativo;
  final String limiteHorasSeguidas;

  final Function() checkNextButtonIcon;

  const Step1HorasLocarWidget({
    required this.controllerDataInicio,
    required this.controllerHoraInicio,
    required this.controllerHoraFim,
    required this.locacao,
    required this.checkNextButtonIcon,
    required this.ativoId,
    required this.ativo,
    required this.limiteHorasSeguidas,
    super.key,
  });

  @override
  State<Step1HorasLocarWidget> createState() => _Step1HorasLocarWidgetState();
}

class _Step1HorasLocarWidgetState extends State<Step1HorasLocarWidget> {
  final CalendarController _calendarController = CalendarController();

  final List<TimeRegion> regions = <TimeRegion>[];

  final List<Map<String, DateTime>> timeRegions = [];

  late bool _isLoading;

  String? _horaLimiteInicio;
  String? _horaLimiteFim;

  @override
  void initState() {
    _isLoading = true;
    if (widget.controllerDataInicio.text == "") {
      widget.controllerDataInicio.text = DateTime.now().toString().split(' ')[0].split('-').reversed.join('/');
      _getTimeRegions();
    }
    _fetchData(DateTime.now().toString());
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
            _horaLimiteInicio = value.horaInicio,
            _horaLimiteFim = value.horaFim,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (timeRegions.isEmpty) {
      if (_isLoading) {
        return Center(child: LoadWidget());
      }
    }
    return Column(
      children: [
        _textField,
        SizedBox(height: 20),
        _dataLocacaoPagamentoHora,
        _calendarBuild,
      ],
    );
  }

  Widget get _textField {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: const [
          Text(
            'Esse ativo é locado por hora',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selecione o dia e horário disponível para sua reserva',
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

  Widget get _dataLocacaoPagamentoHora {
    return DatePickerInput(
      label: 'Dia da locação',
      isRequired: true,
      controller: widget.controllerDataInicio,
      maxDate: DateTime.now().add(Duration(days: 30 * (widget.ativo.limiteAntecedenciaLocar ?? 30))),
      onSelected: (data) {
        _calendarController.displayDate = data;
        _fetchData(data.toString());
        _getTimeRegions();
        widget.locacao.dataInicio = data;
        widget.locacao.dataFim = data;
        widget.checkNextButtonIcon;
      },
    );
  }

  Widget get _calendarBuild {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        HorasCalendarioLocar(
          calendarController: _calendarController,
          getTimeRegions: _getTimeRegions(),
          horaInicioLimite: _horaLimiteInicio!,
          horaFimLimite: _horaLimiteFim!,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 50,
              child: ElevatedButton(
                onPressed: _showHorarioDialog,
                child: Text(
                  'Selecionar Horário',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void _showHorarioDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Selecione o horário',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final bool _hasError = verificaHoraLocacao();
                if (!_hasError) {
                  Navigator.pop(context);
                }
                // Navigator.pop(context);
              },
              child: Text('Confirmar'),
            ),
          ],
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  Text(
                    'Para ativo esse o limite é de ${widget.limiteHorasSeguidas} hora(s) seguidas',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  _horaInicioLocacao,
                  _horaFimLocacao,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _horaInicioLocacao {
    return TimePickerInput(
      label: 'Hora Início Locação',
      type: TextInputTypes.hour,
      isRequired: true,
      controller: widget.controllerHoraInicio,
      onSelected: (suggestion) {
        widget.controllerHoraInicio.text = suggestion.toString();
        widget.locacao.horaInicio = suggestion.toString();
        widget.checkNextButtonIcon;
      },
    );
  }

  Widget get _horaFimLocacao {
    return TimePickerInput(
      label: 'Hora Fim Locação',
      type: TextInputTypes.hour,
      isRequired: true,
      controller: widget.controllerHoraFim,
      onSelected: (suggestion) {
        widget.controllerHoraFim.text = suggestion.toString();
        widget.locacao.horaFim = suggestion.toString();
        widget.checkNextButtonIcon;
      },
    );
  }

  List<TimeRegion> _getTimeRegions() {
    regions.removeWhere((element) => element.text == 'indisponivel');
    if (timeRegions.isNotEmpty) {
      if (timeRegions[0]['inicio'] != null) {
        for (var timeRegion in timeRegions) {
          regions.add(
            TimeRegion(
              startTime: timeRegion['inicio']!,
              endTime: timeRegion['fim']!,
              enablePointerInteraction: false,
              color: Colors.red.withOpacity(0.5),
              timeZone: 'E. South America Standard Time',
              text: 'indisponivel',
            ),
          );
        }
      }
    }
    return regions;
  }

  Future<void> _fetchData(String dia) async {
    List<AtivoUsuariosLocacao> indisponiveisHoras = [];
    await Provider.of<LocacoesRepository>(context, listen: false).listByDia(dia, widget.ativoId).then(
      (value) {
        indisponiveisHoras = value;
        setState(() {
          timeRegions.clear();
          for (var indisponivel in indisponiveisHoras) {
            DateTime dataHoraInicio =
                parseToDateTime(indisponivel.locacaoDataInicio.toString(), indisponivel.locacaoHoraInicio.toString());
            DateTime dataHoraFinal =
                parseToDateTime(indisponivel.locacaoDataTermino.toString(), indisponivel.locacaoHoraTermino.toString());

            timeRegions.add({
              'inicio': dataHoraInicio,
              'fim': dataHoraFinal,
            });
          }
          if (widget.controllerHoraInicio.text != '' && widget.controllerHoraFim.text != '') {
            final dataInicioLocacao = parseToDateTime(
              widget.controllerDataInicio.text.split('/').reversed.join('-'),
              widget.controllerHoraInicio.text,
            );
            final dataFimLocacao = parseToDateTime(
              widget.controllerDataInicio.text.split('/').reversed.join('-'),
              widget.controllerHoraFim.text,
            );
            regions.add(
              TimeRegion(
                startTime: dataInicioLocacao,
                endTime: dataFimLocacao,
                enablePointerInteraction: false,
                color: AppColors.cardColor,
                timeZone: 'E. South America Standard Time',
                text: 'selecionado',
              ),
            );
          }
          _isLoading = false;
        });
      },
    );
  }

  bool verificaConflitoHorario() {
    final dataInicioNovaLocacao = parseToDateTime(
      widget.controllerDataInicio.text.split('/').reversed.join('-'),
      widget.controllerHoraInicio.text,
    );
    final dataFimNovaLocacao = parseToDateTime(
      widget.controllerDataInicio.text.split('/').reversed.join('-'),
      widget.controllerHoraFim.text,
    );

    final horaInicioLimite = parseToDateTime(
      widget.controllerDataInicio.text.split('/').reversed.join('-'),
      _horaLimiteInicio!,
    );
    final horaFimLimite = parseToDateTime(
      widget.controllerDataInicio.text.split('/').reversed.join('-'),
      _horaLimiteFim!,
    );

    if (!dataInicioNovaLocacao.isAfter(horaInicioLimite) || !dataFimNovaLocacao.isBefore(horaFimLimite)) {
      showError('Horário selecionado precisa está dentro do intervalo permitido');
      return true;
    }

    if (dataInicioNovaLocacao.isBefore(DateTime.now())) {
      showError('A hora de locação não pode ser anterior ao horário atual');
      return true;
    }

    for (var timeRegion in timeRegions) {
      final dataHoraInicio = timeRegion['inicio'];
      final dataHoraFim = timeRegion['fim'];

      if ((dataInicioNovaLocacao.isAfter(dataHoraInicio!) && dataInicioNovaLocacao.isBefore(dataHoraFim!)) ||
          (dataFimNovaLocacao.isAfter(dataHoraInicio) && dataFimNovaLocacao.isBefore(dataHoraFim!)) ||
          (dataInicioNovaLocacao.isBefore(dataHoraInicio) && dataFimNovaLocacao.isAfter(dataHoraFim!))) {
        showError('Conflito de horário com uma locação existente');
        return true;
      }
    }
    return false;
  }

  bool verificaHoraLocacao() {
    late bool _hasError = false;
    if (widget.controllerHoraInicio.text == '' || widget.controllerHoraFim.text == '') {
      showError('Preencha todos os campos');
      _hasError = true;
    }
    if (widget.controllerHoraInicio.text == widget.controllerHoraFim.text) {
      showError('A hora de início e fim não podem ser iguais');
      _hasError = true;
    }
    if (verificaConflitoHorario()) _hasError = true;
    setState(() {
      final dataInicio = widget.controllerDataInicio.text.split('/');
      final horaInicio = widget.controllerHoraInicio.text.split(':');
      final horaFim = widget.controllerHoraFim.text.split(':');
      DateTime dataHoraInicio = DateTime(int.parse(dataInicio[2]), int.parse(dataInicio[1]), int.parse(dataInicio[0]),
          int.parse(horaInicio[0]), int.parse(horaInicio[1]), 0);
      DateTime dataHoraFim = DateTime(int.parse(dataInicio[2]), int.parse(dataInicio[1]), int.parse(dataInicio[0]),
          int.parse(horaFim[0]), int.parse(horaFim[1]), 0);

      if (dataHoraFim.isBefore(dataHoraInicio)) {
        showError('A hora de início não pode ser depois que a hora de fim');
        _hasError = true;
      }

      if (dataHoraFim.difference(dataHoraInicio).inHours > int.parse(widget.limiteHorasSeguidas)) {
        showError('O limite de horas seguidas é de ${widget.limiteHorasSeguidas} hora(s)');
        _hasError = true;
      }

      if (!_hasError) {
        regions.clear();
        regions.add(
          TimeRegion(
            startTime: dataHoraInicio,
            endTime: dataHoraFim,
            enablePointerInteraction: false,
            color: AppColors.cardColor,
            timeZone: 'E. South America Standard Time',
            text: 'selecionado',
          ),
        );
      }
    });
    return _hasError;
  }

  Future showError(String message) {
    return showDialog(context: context, builder: (context) => AppPopErrorDialog(message: message));
  }
}
