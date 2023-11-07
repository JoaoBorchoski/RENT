import 'package:locacao/data/repositories/comum/meio_pagamento_repository.dart';
import 'package:locacao/domain/models/comum/meio_pagamento.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_checkbox_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class MeioPagamentoFormPage extends StatefulWidget {
  const MeioPagamentoFormPage({super.key});

  @override
  State<MeioPagamentoFormPage> createState() => _MeioPagamentoFormPageState();
}

class _MeioPagamentoFormPageState extends State<MeioPagamentoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = MeioPagamentoController(
    id: TextEditingController(),
    nome: TextEditingController(),
    descricao: TextEditingController(),
    taxa: TextEditingController(),
    desabilitado: false,
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
            ? Navigator.of(context).pushNamedAndRemoveUntil('/meios-pagamento', (route) => false)
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
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/meios-pagamento', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('MeiosPagamento Form'),
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
              _descricaoField,
              _taxaField,
              _desabilitadoField,
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

  Widget get _taxaField {
    return FormTextInput(
      label: 'Taxa',
      type: TextInputTypes.number,
      isDisabled: _isViewPage,
      controller: _controllers.taxa!,
    );
  }

  Widget get _desabilitadoField {
    return AppCheckbox(
      label: 'Desabilitado',
      controller: _controllers.desabilitado!,
      onChanged: (value) {
        setState(() {
          _controllers.desabilitado = value;
        });
      },
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
    await Provider.of<MeioPagamentoRepository>(context, listen: false).get(id).then((meioPagamento) => _populateController(meioPagamento));
  }

  Future<void> _populateController(MeioPagamento meioPagamento) async {
    setState(() {
      _controllers.id!.text = meioPagamento.id ?? '';
      _controllers.nome!.text = meioPagamento.nome ?? '';
      _controllers.descricao!.text = meioPagamento.descricao ?? '';
      _controllers.taxa!.text = (meioPagamento.taxa ?? '').toString();
      _controllers.desabilitado = meioPagamento.desabilitado ?? false;
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
        'descricao': _controllers.descricao!.text,
        'taxa': _controllers.taxa!.text,
        'desabilitado': _controllers.desabilitado!,
      };

      await Provider.of<MeioPagamentoRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
              );
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/meios-pagamento'));
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
        Navigator.of(context).pushReplacementNamed('/meios-pagamento');
      }
    });
  }
}
