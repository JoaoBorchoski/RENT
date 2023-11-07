import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/categorias_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/categorias.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

import 'icons_grid.dart';

class CategoriasFormPage extends StatefulWidget {
  const CategoriasFormPage({Key? key}) : super(key: key);

  @override
  State<CategoriasFormPage> createState() => _CategoriasFormPageState();
}

class _CategoriasFormPageState extends State<CategoriasFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  bool _isEditing = false;
  String iconeValue = "";
  final _controllers = CategoriasController(
    id: TextEditingController(),
    clienteId: TextEditingController(),
    nome: TextEditingController(),
    clienteNome: TextEditingController(),
    icone: "",
    desabilitado: false,
  );

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _isEditing = args['id'] != null;
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    if ((iconeValue == '') && (_isEditing || _isViewPage)) {
      return Center(
        child: LoadWidget(),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/categoria', (route) => false)
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
                ? Navigator.of(context).pushNamedAndRemoveUntil('/categoria', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Categoria Form'),
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
              _nomeField,
              _iconeField,
              // _desabilitadoField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _nomeField {
    return FormTextInput(
      label: 'Nome',
      isDisabled: _isViewPage,
      controller: _controllers.nome!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _iconeField {
    return SizedBox(
      height: _isViewPage ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      child: IconGrid(
        selectedIcon: iconeValue,
        isViewPage: _isViewPage,
        onIconSelected: (selectedIcon) {
          setState(() {
            iconeValue = selectedIcon;
          });
        },
      ),
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

  Future<void> _loadData(String id) async {
    await Provider.of<CategoriasRepository>(context, listen: false)
        .get(id)
        .then((categorias) => _populateController(categorias));
  }

  Future<void> _populateController(Categorias categorias) async {
    setState(() {
      _controllers.id!.text = categorias.id ?? '';
      _controllers.clienteId!.text = categorias.clienteId ?? '';
      _controllers.nome!.text = categorias.nome ?? '';
      _controllers.clienteNome!.text = categorias.clienteNome ?? '';
      _controllers.desabilitado = categorias.desabilitado ?? false;
      iconeValue = categorias.icone ?? '';
    });
  }

  Future<void> _submit() async {
    Authentication authentication = Provider.of(context, listen: false);

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      _formKey.currentState?.save();

      final Map<String, dynamic> payload = {
        'id': _controllers.id!.text,
        'clienteId': authentication.usuarioClienteId,
        'icone': iconeValue,
        'nome': _controllers.nome!.text,
        'desabilitado': _controllers.desabilitado!,
      };

      await Provider.of<CategoriasRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                  message: _controllers.id!.text == ''
                      ? 'Registro criado com sucesso!'
                      : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/categoria'));
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
        Navigator.of(context).pushReplacementNamed('/categoria');
      }
    });
  }
}
