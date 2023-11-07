import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/legenda_socio_widget.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/step1_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/step2_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/step3_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/step4_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/step5_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/cartao.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/header_selector_locar.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/submit_locar.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LocarFormPage extends StatefulWidget {
  const LocarFormPage({super.key});

  @override
  State<LocarFormPage> createState() => _LocarFormPageState();
}

class _LocarFormPageState extends State<LocarFormPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final bool _isLoading = false;

  int activeStep = 0;
  int upperBound = 4;

  bool _dataIsLoaded = false;
  bool isLastStep = false;

  String headerText = '';

  Icon nextButtonIcon = Icon(
    Icons.navigate_next_rounded,
    color: AppColors.background,
  );

  Locacoes locacao = Locacoes(
    valorAtivoInicial: 0,
    valorOutrasTaxas: 0,
    valorTotal: 0,
    valorTotalConvidados: 0,
  );
  Cartao cartaoPagamento = Cartao();

  String idAtivoVoltarPage = '';

  List<Convidados> locacaoConvidados = [];
  TextEditingController selectedPaymentMethod = TextEditingController();

  final _controllers = LocacoesController(
    id: TextEditingController(),
    valorTotal: TextEditingController(),
    valorTotalConvidados: TextEditingController(),
    valorOutrasTaxas: TextEditingController(),
    valorAtivoInicial: TextEditingController(),
    meioPagamentoId: TextEditingController(),
    meioPagamentoNome: TextEditingController(),
    dataInicio: TextEditingController(),
    dataFim: TextEditingController(),
    dataPagamento: TextEditingController(),
    dataLimitePagamento: TextEditingController(),
    horaInicio: TextEditingController(),
    horaFim: TextEditingController(),
    horaPagamento: TextEditingController(),
    horaLimitePagamento: TextEditingController(),
    observacoes: TextEditingController(),
    status: TextEditingController(),
  );

  DateRangePickerController datePickerController = DateRangePickerController();

  Ativo ativo = Ativo();
  final List<AtivoImagens> _ativoImagens = [];
  final List<AtivoTopicoItem> _ativoRegrasItems = [];

  final _ativoControllers = AtivoController(
    id: TextEditingController(),
    clienteId: TextEditingController(),
    clienteNome: TextEditingController(),
    categoriaId: TextEditingController(),
    categoriasNome: TextEditingController(),
    identificador: TextEditingController(),
    nome: TextEditingController(),
    descricao: TextEditingController(),
    valor: TextEditingController(),
    statusId: TextEditingController(),
    statusNome: TextEditingController(),
    limiteConvidados: TextEditingController(),
    limiteConvidadosExtra: TextEditingController(),
    pagamentoDiaHoraValue: TextEditingController(),
    limiteDiasHorasSeguidas: TextEditingController(),
    pagamentoDiaHoraNome: TextEditingController(),
  );

  final _cartaoController = CartaoController(
    numeroCartao: TextEditingController(),
    dataValidade: TextEditingController(),
    cvv: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    headerText = HeaderSelector.headerTextSelection(activeStep);
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      idAtivoVoltarPage = args['idAtivo'] ?? '';
      ativo.id = idAtivoVoltarPage;
      ativo = args['ativo'];
      _ativoControllers.pagamentoDiaHoraValue!.text = ativo.pagamentoDiaHoraValue!;
      _ativoControllers.limiteDiasHorasSeguidas!.text = ativo.limiteDiasHorasSeguidas.toString();
      loadData(
        context,
        ativo,
        _ativoControllers,
        _ativoRegrasItems,
        _ativoImagens,
        (ativoRet, ativoRegrasRet, ativoImagensRet) {
          setState(() {
            ativo = ativoRet;
            locacao.valorAtivoInicial = ativo.valor;
            locacao.valorTotal = ativo.valor;
            _ativoImagens.addAll(ativo.ativoImagens!);
            _ativoRegrasItems.addAll(ativoRegrasRet);
          });
        },
      );
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        await showDialog(
          context: context,
          builder: (context) {
            return AppPopAlertDialog(
              title: 'Sair sem salvar',
              message: 'Deseja mesmo sair sem salvar as alterações?',
              botoes: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'Não',
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Sim',
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
              ],
            );
          },
        ).then((value) => value
            ? Navigator.of(context).pushNamed('/ativos-detalhe', arguments: {'id': idAtivoVoltarPage})
            : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text(headerText),
        showDrawer: false,
        body: _isLoading ? LoadWidget() : Padding(padding: EdgeInsets.all(10), child: _formFields),
      ),
    );
  }

  Widget get _formFields {
    return Form(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: formData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data as Widget;
                  }
                  return LoadWidget();
                },
              ),
            ),
          ),
          activeStep == 1 ? LegendaSocioWidget() : SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              previousButton(),
              nextButton(),
            ],
          ),
          Theme(
            data: Theme.of(context).copyWith(
              primaryColor: AppColors.primary,
              hintColor: AppColors.secondary,
            ),
            child: NumberStepper(
              lineColor: AppColors.grey,
              lineLength: 8,
              stepRadius: 20,
              activeStep: activeStep,
              activeStepColor: AppColors.secondary,
              activeStepBorderColor: AppColors.primary,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              stepReachedAnimationEffect: Curves.ease,
              numbers: const [1, 2, 3, 4, 5],
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  // Functions
  Widget nextButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.cardColor,
        child: IconButton(
          onPressed: () async {
            bool validado = await _validateStep(true);
            if (validado && activeStep != 3 && activeStep != 4) {
              setState(() {
                activeStep++;
                headerText = HeaderSelector.headerTextSelection(activeStep);
                checkNextButtonIcon();
              });
            } else if (activeStep == 3) {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (context) {
                  return AppPopAlertDialog(
                    title: 'Confirmar',
                    message: 'Deseja finalizar a locação?',
                    botoes: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Não'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await submit(
                              context,
                              ativo,
                              Locacoes(
                                id: _controllers.id!.text,
                                valorTotal: locacao.valorTotal,
                                valorTotalConvidados: locacao.valorTotalConvidados,
                                valorOutrasTaxas: locacao.valorOutrasTaxas,
                                valorAtivoInicial: locacao.valorAtivoInicial,
                                meioPagamentoId: _controllers.meioPagamentoId!.text,
                                dataInicio: locacao.dataInicio,
                                dataFim: locacao.dataFim,
                                dataPagamento: locacao.dataPagamento,
                                dataLimitePagamento: locacao.dataLimitePagamento,
                                horaInicio: locacao.horaInicio,
                                horaFim: locacao.horaFim,
                                horaPagamento: locacao.horaPagamento,
                                horaLimitePagamento: locacao.horaLimitePagamento,
                                observacoes: _controllers.observacoes!.text,
                                status: 'pendente',
                              ),
                              _controllers,
                              locacaoConvidados,
                              () {
                                setState(() {
                                  activeStep++;
                                  headerText = HeaderSelector.headerTextSelection(activeStep);
                                  checkNextButtonIcon();
                                });
                              },
                            );
                          },
                          child: Text('Sim'),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (activeStep == 4) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamed('/historico-locacoes');
            } else {
              setState(() {
                nextButtonIcon = Icon(Icons.close_rounded, color: AppColors.background);
              });
            }
          },
          iconSize: 40,
          icon: nextButtonIcon,
        ),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return activeStep != 4
        ? Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.cardColor,
              child: IconButton(
                iconSize: 40,
                onPressed: () {
                  if (activeStep > 0) {
                    setState(() {
                      activeStep--;
                      nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
                    });
                  }
                },
                icon: Icon(Icons.navigate_before_rounded, color: AppColors.background),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Future<bool> _validateStep(bool isNextButton) async {
    switch (activeStep) {
      case 0:
        return locacao.dataInicio != null && locacao.horaInicio != null;
      case 1:
        // return locacaoConvidados.isNotEmpty;
        return true;
      case 2:
        return _controllers.meioPagamentoNome!.text.isNotEmpty
            ? _controllers.meioPagamentoNome!.text.contains('Cartão')
                ? _formKey3.currentState!.validate()
                : true
            : false;
      case 3:
        return true;
      case 4:
        return true;
      default:
        return false;
    }
  }

  Future<void> checkNextButtonIcon() async {
    bool validado = await _validateStep(false);
    setState(() {
      nextButtonIcon = validado
          ? Icon(
              Icons.navigate_next_rounded,
              color: AppColors.background,
            )
          : Icon(
              Icons.close_rounded,
              color: AppColors.background,
            );
      if (activeStep == 4 || activeStep == 3) {
        nextButtonIcon = Icon(
          Icons.check_rounded,
          color: AppColors.background,
        );
      }
    });
  }

  Future<Widget> formData() async {
    switch (activeStep) {
      case 0:
        return Step1Locar(
          datePickerController: datePickerController,
          locacao: locacao,
          ativo: ativo,
          controllerDataInicio: _controllers.dataInicio!,
          controllerDataFim: _controllers.dataFim!,
          controllerHoraInicio: _controllers.horaInicio!,
          controllerHoraFim: _controllers.horaFim!,
          checkNextButtonIcon: checkNextButtonIcon,
          controllerPagamentoHoraDiaValue: _ativoControllers.pagamentoDiaHoraValue!,
          controllerPagamentoDiaHoraNome: _ativoControllers.pagamentoDiaHoraNome!,
          controllerAtivo: _ativoControllers,
          formKey1: _formKey1,
        );

      case 1:
        return Step2Locar(
          locacaoConvidados: locacaoConvidados,
          locacao: locacao,
          ativo: ativo,
          checkNextButtonIcon: checkNextButtonIcon,
          formKey2: _formKey2,
        );

      case 2:
        return Step3Locar(
          checkNextButtonIcon: checkNextButtonIcon,
          formKey3: _formKey3,
          selectedPaymentMethod: selectedPaymentMethod,
          meioPagamentoIdController: _controllers.meioPagamentoId!,
          meioPagamentoNomeController: _controllers.meioPagamentoNome!,
          numeroCartaoController: _cartaoController.numeroCartao!,
          dataValidadeController: _cartaoController.dataValidade!,
          cvvController: _cartaoController.cvv!,
          cartao: cartaoPagamento,
          locacao: locacao,
          ativo: ativo,
        );

      case 3:
        return Step4Locar(
          checkNextButtonIcon: checkNextButtonIcon,
          locacao: locacao,
          ativo: ativo,
          cartao: cartaoPagamento,
          convidados: locacaoConvidados,
          meioPagamentoNomeController: _controllers.meioPagamentoNome!,
          ativoRegrasItems: _ativoRegrasItems,
        );

      case 4:
        return Step5Locar(
          checkNextButtonIcon: checkNextButtonIcon,
          ativo: ativo,
          locacao: locacao,
        );

      default:
        return Text('Erro no ativo');
    }
  }
}
