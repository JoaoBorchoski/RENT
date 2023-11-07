import 'package:locacao/data/repositories/clientes/status_ativo_repository.dart';
import 'package:locacao/domain/models/clientes/status_ativo.dart';
// import 'package:locacao/presentation/components/app_color_picker.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
// import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class StatusAtivoFormPage extends StatefulWidget {
  const StatusAtivoFormPage({super.key});

  @override
  State<StatusAtivoFormPage> createState() => _StatusAtivoFormPageState();
}

class _StatusAtivoFormPageState extends State<StatusAtivoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  // ignore: unused_field
  final statusAtivoNome = TextEditingController();
  final _controllers = StatusAtivoController(
      id: TextEditingController(), nome: TextEditingController(), descricao: TextEditingController());

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      if (args['ativo'] != null) {
        _populateController(args['ativo']);
      }
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    // if (!_dataIsLoaded) {
    //   return Center(child: LoadWidget());
    // }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/status-ativos', (route) => false)
            : await showDialog(
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
                ? Navigator.of(context).pushNamedAndRemoveUntil('/status-ativos', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Status Ativos Form'),
        showDrawer: false,
        body: formFields(context),
      ),
    );
  }

  Form formFields(context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _nomeField,
              _descricaoField,
              // _buildColorPicker,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _nomeField {
    return FormTextInput(
      label: 'Nome',
      isDisabled: _isViewPage,
      controller: _controllers.nome!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _descricaoField {
    return FormTextInput(
      label: 'Descrição',
      isDisabled: _isViewPage,
      controller: _controllers.descricao!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  // ignore: unused_element
  // Widget get _buildColorPicker {
  //   return AppColorPicker();
  // }

  Widget get _actionButtons {
    return _isViewPage
        ? SizedBox.shrink()
        : Column(
            children: [
              Row(
                children: [
                  Expanded(child: AppFormButton(submit: _cancel, label: 'Cancelar')),
                  SizedBox(width: 10),
                  Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
                ],
              ),
            ],
          );
  }

  // Functions

  Future<void> _loadData(String id) async {
    await Provider.of<StatusAtivoRepository>(context, listen: false)
        .get(id)
        .then((statusAtivo) => _populateController(statusAtivo));
  }

  Future<void> _populateController(StatusAtivo statusAtivo) async {
    setState(() {
      _controllers.id!.text = statusAtivo.id ?? '';
      _controllers.nome!.text = statusAtivo.nome ?? '';
      _controllers.descricao!.text = statusAtivo.descricao ?? '';
      _dataIsLoaded = true;
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    // ignore: prefer_typing_uninitialized_variables, unused_local_variable
    var idStatusAtivo;
    if (!isValid) {
      return;
    }
    try {
      _formKey.currentState?.save();

      final Map<String, dynamic> payload = {
        'id': _controllers.id!.text,
        'nome': _controllers.nome!.text,
        'descricao': _controllers.descricao!.text,
        'cor': '#111111',
      };
      await Provider.of<StatusAtivoRepository>(context, listen: false).save(payload).then(
        (validado) {
          if (validado != '') {
            idStatusAtivo = validado;
            return showDialog(
              context: context,
              builder: (context) {
                return AppPopSuccessDialog(
                  message:
                      _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
                );
              },
            ).then((value) {
              Navigator.of(context).pushReplacementNamed('/status-ativos');
            });
          }
        },
      );
    } on AuthException catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: error.toString());
        },
      );
    } catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: 'Ocorreu um erro inesperado!');
        },
      );
    }
  }

  Future<void> _cancel() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AppPopAlertDialog(
          title: 'Sair sem salvar',
          message: 'Tem certeza que deseja sair?',
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
    ).then((value) {
      if (value) {
        Navigator.of(context).pushReplacementNamed('/status-ativos');
      }
    });
  }
}
