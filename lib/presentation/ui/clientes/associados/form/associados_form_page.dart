// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/ui/clientes/associados/form/steps/step1_associado.dart';
import 'package:locacao/presentation/ui/clientes/associados/form/steps/step2_associado.dart';
import 'package:locacao/presentation/ui/clientes/associados/models/dependente_topico_item.dart';
import 'package:locacao/presentation/ui/clientes/associados/utils/header_selector_associados.dart';
import 'package:locacao/presentation/ui/clientes/associados/utils/submit_associado.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AssociadosFormPage extends StatefulWidget {
  const AssociadosFormPage({super.key});

  @override
  State<AssociadosFormPage> createState() => _AssociadosFormPageState();
}

class _AssociadosFormPageState extends State<AssociadosFormPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final bool _isLoading = false;

  int activeStep = 0;
  int upperBound = 2;

  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  bool isLastStep = false;

  String headerText = '';

  Icon nextButtonIcon = Icon(
    Icons.navigate_next_rounded,
    color: AppColors.background,
  );

  Associados associados = Associados(
    id: '',
    usuarioId: '',
    usuariosNome: '',
    usuarioEmail: '',
    statusAssociadoId: '',
    statusAssociadoCor: '',
    statusAssociadoNome: '',
  );

  List<DependenteTopicoItem> dependentes = [];

  final _controllers = AssociadosController(
    id: TextEditingController(),
    usuarioId: TextEditingController(),
    usuariosNome: TextEditingController(),
    usuarioCpf: TextEditingController(),
    statusAssociadoId: TextEditingController(),
    statusAssociadoNome: TextEditingController(),
    statusAssociadoCor: TextEditingController(),
    codigoSocio: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    headerText = HeaderSelectorAssociados.headerTextSelection(activeStep);
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      loadDataAssociados(
        context,
        associados,
        dependentes,
        _controllers,
        (associadoRet, dependentesRet) {
          setState(() {
            associados = associadoRet;
            dependentes.addAll(dependentesRet);
          });
        },
      );
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/associado', (route) => false)
            : await showDialog(
                context: context,
                builder: (context) {
                  return AppPopAlertDialog(
                    title: 'Sair sem salvar?',
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
                ? Navigator.of(context).pushNamedAndRemoveUntil('/associado', (route) => false)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              previousButton(),
              nextButton(),
            ],
          ),
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
            if (validado && activeStep != 1) {
              setState(() {
                activeStep++;
                headerText = HeaderSelectorAssociados.headerTextSelection(activeStep);
                checkNextButtonIcon();
              });
            } else if (activeStep == 1 && validado) {
              _isViewPage
                  ? Navigator.of(context).pushNamedAndRemoveUntil('/associado', (route) => false)
                  : showDialog(
                      context: context,
                      builder: (context) {
                        return AppPopAlertDialog(
                          message: 'Deseja finalizar a associação?',
                          title: 'Confirmação',
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
                                  submitAssociado(
                                    context,
                                    Associados(
                                      id: _controllers.id!.text,
                                      usuarioId: _controllers.usuarioId!.text,
                                      usuariosNome: _controllers.usuariosNome!.text,
                                      usuarioCpf: _controllers.usuarioCpf!.text,
                                      codigoSocio: _controllers.codigoSocio!.text,
                                      statusAssociadoId: _controllers.statusAssociadoId!.text,
                                    ),
                                    dependentes,
                                    _controllers,
                                    _isViewPage,
                                  ).then((value) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('/associado', (route) => false);
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
        return _isViewPage ? true : _formKey1.currentState!.validate();
      case 1:
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
      if (activeStep == 1 && validado) {
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
        return Step1Associados(
          checkNextButtonIcon: checkNextButtonIcon,
          formKey1: _formKey1,
          controllerStatusAssociadoId: _controllers.statusAssociadoId!,
          controllerStatusAssociadoNome: _controllers.statusAssociadoNome!,
          controllerUsuarioCpf: _controllers.usuarioCpf!,
          controllerUsuarioId: _controllers.usuarioId!,
          controllerCodigoSocio: _controllers.codigoSocio!,
          isViewPage: _isViewPage,
          isEditPage: _controllers.id!.text != '' ? true : false,
        );

      case 1:
        return Step2Associado(
          dependentes: dependentes,
          isViewPage: _isViewPage,
          checkNextButtonIcon: checkNextButtonIcon,
          formKey2: _formKey2,
        );

      default:
        return Text('Erro no associado');
    }
  }
}
