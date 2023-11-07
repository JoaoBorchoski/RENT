import 'dart:io';

import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/step1.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/step2.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/step3.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/step4.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/step5.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/step6.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/presentation/ui/clientes/ativo/utils/header_selector.dart';
import 'package:locacao/presentation/ui/clientes/ativo/utils/submit.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AtivoFormPage extends StatefulWidget {
  const AtivoFormPage({super.key});

  @override
  State<AtivoFormPage> createState() => _AtivoFormPageState();
}

class _AtivoFormPageState extends State<AtivoFormPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final bool _isLoading = false;

  int activeStep = 0;
  int upperBound = 4;

  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  bool isLastStep = false;
  bool _isEditing = false;

  String headerText = '';

  final List<File> _selectedImages = [];
  final List<AtivoImagens> _ativoImagens = [];
  final List<AtivoImagens> _ativoImagensDeletar = [];

  final List<AtivoTopicoItem> _ativoOfereceItems = [];
  final List<AtivoTopicoItem> _ativoRegrasItems = [];

  Icon nextButtonIcon = Icon(
    Icons.navigate_next_rounded,
    color: AppColors.background,
  );

  Ativo ativo = Ativo();

  final ativoNome = TextEditingController();
  final _controllers = AtivoController(
    id: TextEditingController(),
    clienteId: TextEditingController(),
    clienteNome: TextEditingController(),
    categoriaId: TextEditingController(),
    categoriasNome: TextEditingController(),
    identificador: TextEditingController(),
    nome: TextEditingController(),
    descricao: TextEditingController(),
    valor: TextEditingController(),
    limiteConvidados: TextEditingController(),
    limiteAntecedenciaLocar: TextEditingController(),
    limiteConvidadosExtra: TextEditingController(),
    statusId: TextEditingController(),
    statusNome: TextEditingController(),
    pagamentoDiaHoraNome: TextEditingController(),
    pagamentoDiaHoraValue: TextEditingController(),
    limiteDiasHorasSeguidas: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    headerText = HeaderSelector.headerTextSelection(activeStep);
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      loadData(
        context,
        ativo,
        _ativoOfereceItems,
        _ativoRegrasItems,
        _ativoImagens,
        _controllers,
        (ativoRet, ativoRegrasRet, ativoOfereceRet, ativoImagensRet) {
          setState(() {
            ativo = ativoRet;
            _ativoImagens.addAll(ativo.ativoImagens!);
            _ativoOfereceItems.addAll(ativoOfereceRet);
            _ativoRegrasItems.addAll(ativoRegrasRet);
          });
        },
      );
      _isViewPage = args['view'] ?? false;
      _isEditing = args['edit'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/ativos', (route) => false)
            : await showDialog(
                context: context,
                builder: (context) {
                  return AppPopAlertDialog(
                    message: 'Deseja mesmo sair sem salvar as alterações?',
                    title: 'Sair sem salvar?',
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
              ).then((value) =>
                value ? Navigator.of(context).pushNamedAndRemoveUntil('/ativos', (route) => false) : retorno = value);

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
              numbers: const [1, 2, 3, 4, 5, 6],
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
            if (validado && activeStep != 5) {
              setState(() {
                activeStep++;
                headerText = HeaderSelector.headerTextSelection(activeStep);
                checkNextButtonIcon();
              });
            } else if (activeStep == 5) {
              if (!_isViewPage) {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) {
                    return AppPopAlertDialog(
                      message: 'Deseja finalizar o ativo?',
                      title: 'Corfirmação',
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
                            onPressed: () {
                              submit(
                                context,
                                Ativo(
                                  id: _controllers.id!.text,
                                  clienteId: _controllers.clienteId!.text,
                                  clienteNome: _controllers.clienteNome!.text,
                                  categoriaId: _controllers.categoriaId!.text,
                                  categoriasNome: _controllers.categoriasNome!.text,
                                  identificador: _controllers.identificador!.text,
                                  nome: _controllers.nome!.text,
                                  descricao: _controllers.descricao!.text,
                                  valor: double.parse(_controllers.valor!.text),
                                  limiteConvidados: int.parse(_controllers.limiteConvidados!.text),
                                  limiteConvidadosExtra: int.parse(_controllers.limiteConvidadosExtra!.text),
                                  limiteAntecedenciaLocar: int.parse(_controllers.limiteAntecedenciaLocar!.text),
                                  statusId: _controllers.statusId!.text,
                                  statusNome: _controllers.statusNome!.text,
                                  ativoImagens: _ativoImagens,
                                  limiteDiasHorasSeguidas: _controllers.limiteDiasHorasSeguidas!.text != ""
                                      ? int.parse(_controllers.limiteDiasHorasSeguidas!.text)
                                      : 1,
                                  pagamentoDiaHoraValue: _controllers.pagamentoDiaHoraValue!.text,
                                  pagamentoDiaHoraNome: _controllers.pagamentoDiaHoraNome!.text,
                                ),
                                _ativoOfereceItems,
                                _ativoRegrasItems,
                                _selectedImages,
                                _controllers,
                                _isEditing,
                                _ativoImagensDeletar,
                              ).then((value) {
                                Navigator.of(context).pushNamedAndRemoveUntil('/ativos', (route) => false);
                              });
                            },
                            child: Text('Sim'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil('/ativos', (route) => false);
              }
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
    return Padding(
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
    );
  }

  Future<bool> _validateStep(bool isNextButton) async {
    switch (activeStep) {
      case 0:
        return _formKey1.currentState!.validate();
      case 1:
        return _formKey2.currentState!.validate();
      case 2:
        bool validado = false;
        if (_isViewPage) return true;
        if ((_selectedImages.isNotEmpty || _ativoImagens.isNotEmpty) && !_isViewPage) {
          validado = true;
          return validado;
        } else {
          return _selectedImages.isEmpty ? false : true;
        }
      case 3:
        return _ativoOfereceItems.isNotEmpty;
      case 4:
        return _ativoRegrasItems.isNotEmpty;
      case 5:
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
      if (activeStep == 5) {
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
        return Step1(
          ativoNome: ativoNome,
          controllerCategoriaId: _controllers.categoriaId!,
          controllerCategoriaNome: _controllers.categoriasNome!,
          controllerDescricao: _controllers.descricao!,
          controllerIdentificador: _controllers.identificador!,
          controllerNome: _controllers.nome!,
          controllerStatusId: _controllers.statusId!,
          controllerStatusNome: _controllers.statusNome!,
          controllerValor: _controllers.valor!,
          controllerPagamentoDiaHoraNome: _controllers.pagamentoDiaHoraNome!,
          controllerPagamentoDiaHoraValue: _controllers.pagamentoDiaHoraValue!,
          isViewPage: _isViewPage,
          checkNextButtonIcon: checkNextButtonIcon,
          ativo: ativo,
          formKey1: _formKey1,
        );

      case 1:
        return Step2(
          isViewPage: _isViewPage,
          controllerLimiteDiasHorasSeguidos: _controllers.limiteDiasHorasSeguidas!,
          controllerLimiteConvidados: _controllers.limiteConvidados!,
          controllerLimiteConvidadosExtra: _controllers.limiteConvidadosExtra!,
          controllerLimiteAntecedenciaLocar: _controllers.limiteAntecedenciaLocar!,
          controllerPagamentoDiaHora: _controllers.pagamentoDiaHoraValue!,
          checkNextButtonIcon: checkNextButtonIcon,
          formKey2: _formKey2,
          isEditPage: _isEditing,
        );

      case 2:
        return Step3(
          isViewPage: _isViewPage,
          ativoImagens: _ativoImagens,
          ativoImagensDeletar: _ativoImagensDeletar,
          checkNextButtonIcon: checkNextButtonIcon,
          selectedImages: _selectedImages,
          formKey2: _formKey2,
          isEditPage: _isEditing,
        );

      case 3:
        return Step4(
          isViewPage: _isViewPage,
          checkNextButtonIcon: checkNextButtonIcon,
          formKey3: _formKey3,
          ativoOfereceItems: _ativoOfereceItems,
        );

      case 4:
        return Step5(
          isViewPage: _isViewPage,
          checkNextButtonIcon: checkNextButtonIcon,
          ativoRegraItems: _ativoRegrasItems,
        );

      case 5:
        return Step6(
          ativoImagens: _ativoImagens,
          selectedImagens: _selectedImages,
          ativoNome: _controllers.nome!.text,
          ativoValor: _controllers.valor!.text,
          ativoDescricao: _controllers.descricao!.text,
          ativoStatus: _controllers.statusNome!.text,
          ativoCategoria: _controllers.categoriasNome!.text,
          ativoIdentificador: _controllers.identificador!.text,
          ativoOferece: _ativoOfereceItems.map((e) {
            return {
              'topico': e.topico,
              'icone': e.icone,
            };
          }).toList(),
          ativoRegras: _ativoRegrasItems.map((e) {
            return {
              'topico': e.topico,
              'icone': e.icone,
            };
          }).toList(),
          isViewPage: _isViewPage,
          isEditPage: _isEditing,
        );

      default:
        return Text('Erro no ativo');
    }
  }
}
