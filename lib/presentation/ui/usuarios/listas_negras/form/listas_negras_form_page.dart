import 'package:locacao/data/repositories/usuarios/usuarios_repository.dart';
import 'package:locacao/data/repositories/clientes/cliente_repository.dart';
import 'package:locacao/data/repositories/usuarios/listas_negras_repository.dart';
import 'package:locacao/domain/models/usuarios/listas_negras.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class ListasNegrasFormPage extends StatefulWidget {
  const ListasNegrasFormPage({super.key});

  @override
  State<ListasNegrasFormPage> createState() => _ListasNegrasFormPageState();
}

class _ListasNegrasFormPageState extends State<ListasNegrasFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = ListasNegrasController(
    id: TextEditingController(),
    usuarioId: TextEditingController(),
    usuariosNome: TextEditingController(),
    clienteId: TextEditingController(),
    clienteNome: TextEditingController(),
    motivo: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/lista-negra', (route) => false)
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
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/lista-negra', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('ListaNegra Form'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _usuarioIdField,
              _clienteIdField,
              _motivoField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _usuarioIdField {
    return FormSelectInput(
      label: 'Usuário',
      isDisabled: _isViewPage,
      controllerValue: _controllers.usuarioId!,
      controllerLabel: _controllers.usuariosNome!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<UsuariosRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _clienteIdField {
    return FormSelectInput(
      label: 'Cliente',
      isDisabled: _isViewPage,
      controllerValue: _controllers.clienteId!,
      controllerLabel: _controllers.clienteNome!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<ClienteRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _motivoField {
    return FormTextInput(
      label: 'Motivo',
      isDisabled: _isViewPage,
      controller: _controllers.motivo!,
    );
  }

  Widget get _actionButtons {
    return _isViewPage
        ? SizedBox.shrink()
        : Row(
            children: [
              Expanded(child: AppFormButton(submit: _cancel, label: 'Cancelar')),
              SizedBox(width: 10),
              Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
            ],
          );
  }

  // Functions

  Future<void> _loadData(String id) async {
    await Provider.of<ListasNegrasRepository>(context, listen: false).get(id).then((listasNegras) => _populateController(listasNegras));
  }

  Future<void> _populateController(ListasNegras listasNegras) async {
    setState(() {
      _controllers.id!.text = listasNegras.id ?? '';
      _controllers.usuarioId!.text = listasNegras.usuarioId ?? '';
      _controllers.usuariosNome!.text = listasNegras.usuariosNome ?? '';
      _controllers.clienteId!.text = listasNegras.clienteId ?? '';
      _controllers.clienteNome!.text = listasNegras.clienteNome ?? '';
      _controllers.motivo!.text = listasNegras.motivo ?? '';
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
        'usuarioId': _controllers.usuarioId!.text,
        'clienteId': _controllers.clienteId!.text,
        'motivo': _controllers.motivo!.text,
      };

      await Provider.of<ListasNegrasRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
              );
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/lista-negra'));
        }
      });
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
        Navigator.of(context).pushReplacementNamed('/lista-negra');
      }
    });
  }
}
