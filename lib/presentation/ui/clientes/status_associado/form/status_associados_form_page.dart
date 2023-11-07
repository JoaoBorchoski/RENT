import 'package:locacao/data/repositories/clientes/status_associados_repository.dart';
import 'package:locacao/domain/models/clientes/status_associados.dart';
import 'package:locacao/presentation/components/app_color_picker.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class StatusAssociadosFormPage extends StatefulWidget {
  const StatusAssociadosFormPage({super.key});

  @override
  State<StatusAssociadosFormPage> createState() => _StatusAssociadosFormPageState();
}

class _StatusAssociadosFormPageState extends State<StatusAssociadosFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  bool _isEditPage = false;
  // ignore: unused_field
  final statusAssociadoNome = TextEditingController();
  final _controllers = StatusAssociadosController(
    id: TextEditingController(),
    nome: TextEditingController(),
    cor: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _isEditPage = args['id'] != null && args['view'] == false ? true : false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/status-associado', (route) => false)
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
                ? Navigator.of(context).pushNamedAndRemoveUntil('/status-associado', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Status Associados Form'),
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
              _buildColorPicker,
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

  Widget get _buildColorPicker {
    if (_controllers.cor!.text == '' && (_isEditPage || _isViewPage)) return LoadWidget();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: AppColorPicker(color: _controllers.cor!.text, controller: _controllers),
    );
  }

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
    await Provider.of<StatusAssociadosRepository>(context, listen: false)
        .get(id)
        .then((statusAssociado) => _populateController(statusAssociado));
  }

  Future<void> _populateController(StatusAssociados statusAssociado) async {
    setState(() {
      _controllers.id!.text = statusAssociado.id ?? '';
      _controllers.nome!.text = statusAssociado.nome ?? '';
      _controllers.cor!.text = statusAssociado.cor ?? '';
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    try {
      _formKey.currentState?.save();

      final Map<String, dynamic> payload = {
        'id': _controllers.id!.text,
        'nome': _controllers.nome!.text,
        'cor': _controllers.cor!.text,
      };
      await Provider.of<StatusAssociadosRepository>(context, listen: false).save(payload).then(
        (validado) {
          if (validado == 200) {
            return showDialog(
              context: context,
              builder: (context) {
                return AppPopSuccessDialog(
                  message:
                      _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
                );
              },
            ).then((value) {
              Navigator.of(context).pushReplacementNamed('/status-associado');
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
        Navigator.of(context).pushReplacementNamed('/status-associado');
      }
    });
  }
}
