// ignore_for_file: avoid_print

import 'package:locacao/data/repositories/clientes/ativo_oferece_repository.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/models/clientes/ativo_oferece.dart';

class AtivoOferceFormPage extends StatefulWidget {
  const AtivoOferceFormPage({super.key});

  @override
  State<AtivoOferceFormPage> createState() => _AtivoOferceFormPageState();
}

class _AtivoOferceFormPageState extends State<AtivoOferceFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  final List<Widget> _ofereceFields = [];
  List<String> _topicoText = [];
  final Map<Key, TextEditingController> _topicoTextControllers = {};
  final Map<Key, int> _fieldIndexes = {};

  final _controllers = AtivoOfereceController(
    id: TextEditingController(),
    ativoId: TextEditingController(),
    ativoNome: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllers.ativoId!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/ativo-oferece-form', (route) => false)
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
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/ativos', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Adicione o que o lugar oferece'),
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
              _ativoTitleAddButton,
              ..._ofereceFields,
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.6,
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: _ofereceFields,
              //     ),
              //   ),
              // ),
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _ativoTitleAddButton {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textAtivoNome,
          _addOfereceField,
        ],
      ),
    );
  }

  Widget get _textAtivoNome {
    return Text(
      "O que o lugar oferece?",
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

  Widget get _addOfereceField {
    final fieldKey = UniqueKey();
    _fieldIndexes[fieldKey] = _ofereceFields.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(Icons.add),
        color: AppColors.white,
        onPressed: () {
          setState(() {
            _ofereceFields.add(_topicoField(fieldKey));
          });
        },
      ),
    );
  }

  Widget _topicoField(Key fieldKey) {
    TextEditingController controller = TextEditingController();

    _topicoTextControllers[fieldKey] = controller;

    return Row(
      children: [
        Expanded(
          child: FormTextInput(
            label: 'Item',
            controller: controller,
            isRequired: true,
            validator: (value) => value != '' ? null : 'Campo obrigatório!',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: IconButton(
            icon: Icon(Icons.remove),
            color: AppColors.delete,
            onPressed: () {
              setState(() {
                _removeOfereceField(fieldKey);
              });
            },
          ),
        ),
      ],
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

  void _removeOfereceField(Key fieldKey) {
    setState(() {
      final index = _fieldIndexes[fieldKey];
      _ofereceFields.removeAt(index!);
      _fieldIndexes.remove(fieldKey);

      _fieldIndexes.forEach((key, value) {
        if (value > index) {
          _fieldIndexes[key] = value - 1;
        }
      });

      try {
        // ignore: unused_local_variable
        final removedText = _topicoText.removeAt(index);
      } catch (e) {
        print(e);
      }

      final removedController = _topicoTextControllers.remove(fieldKey);

      removedController?.dispose();
    });
  }

  Future<void> _loadData(String id) async {
    await Provider.of<AtivoOfereceRepository>(context, listen: false).get(id).then((ativoOferce) => _populateController(ativoOferce));
  }

  Future<void> _populateController(AtivoOferece ativoOferce) async {
    setState(() {
      _controllers.id!.text = ativoOferce.id ?? '';
      _controllers.ativoId!.text = ativoOferce.ativoId ?? '';
      _controllers.ativoNome!.text = ativoOferce.ativoNome ?? '';
      // _controllers.topico!.text = ativoOferce.topico ?? '';
    });
  }

  Future<void> _submit() async {
    _topicoText = _topicoTextControllers.values.map((controller) => controller.text).toList();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      _formKey.currentState?.save();

      final Map<String, dynamic> payload = {
        'id': _controllers.id!.text,
        'ativoId': _controllers.ativoId!.text,
        'topicos': _topicoText,
      };

      await Provider.of<AtivoOfereceRepository>(context, listen: false).save(payload, false).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
              );
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/'));
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
        Navigator.of(context).pushReplacementNamed('/ativos');
      }
    });
  }
}
