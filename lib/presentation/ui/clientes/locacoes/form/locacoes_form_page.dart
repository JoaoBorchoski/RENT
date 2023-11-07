import 'package:locacao/data/repositories/comum/meio_pagamento_repository.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
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

class LocacoesFormPage extends StatefulWidget {
  const LocacoesFormPage({super.key});

  @override
  State<LocacoesFormPage> createState() => _LocacoesFormPageState();
}

class _LocacoesFormPageState extends State<LocacoesFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = LocacoesController(
    id: TextEditingController(),
    valorTotal: TextEditingController(),
    meioPagamentoId: TextEditingController(),
    meioPagamentoNome: TextEditingController(),
    observacoes: TextEditingController(),
    status: TextEditingController(),
    dataInicio: TextEditingController(),
    dataFim: TextEditingController(),
    dataLimitePagamento: TextEditingController(),
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
            ? Navigator.of(context).pushNamedAndRemoveUntil('/locacao', (route) => false)
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
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/locacao', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Locacao Form'),
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
              _precoField,
              _meioPagamentoIdField,
              _observacoesField,
              _descricaoField,
              _dataInicioField,
              _dataTerminoField,
              _dataLimitePagamantoField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _precoField {
    return FormTextInput(
      label: 'Preco',
      type: TextInputTypes.number,
      isDisabled: _isViewPage,
      controller: _controllers.valorTotal!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _dataInicioField {
    return FormTextInput(
      label: 'Data de início',
      type: TextInputTypes.date,
      isDisabled: _isViewPage,
      controller: _controllers.dataInicio!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _dataTerminoField {
    return FormTextInput(
      label: 'Data de Término',
      type: TextInputTypes.date,
      isDisabled: _isViewPage,
      controller: _controllers.dataFim!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _dataLimitePagamantoField {
    return FormTextInput(
      label: 'Data Limite do Pagamento',
      type: TextInputTypes.date,
      isDisabled: _isViewPage,
      controller: _controllers.dataLimitePagamento!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _meioPagamentoIdField {
    return FormSelectInput(
      label: 'Meio de Pagamento',
      isDisabled: _isViewPage,
      controllerValue: _controllers.meioPagamentoId!,
      controllerLabel: _controllers.meioPagamentoNome!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<MeioPagamentoRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _observacoesField {
    return FormTextInput(
      label: 'Observação',
      isDisabled: _isViewPage,
      controller: _controllers.observacoes!,
    );
  }

  Widget get _descricaoField {
    return FormTextInput(
      label: 'Descrição',
      isDisabled: _isViewPage,
      controller: _controllers.status!,
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
    await Provider.of<LocacoesRepository>(context, listen: false).get(id).then((locacoes) => _populateController(locacoes));
  }

  Future<void> _populateController(Locacoes locacoes) async {
    setState(() {
      _controllers.id!.text = locacoes.id ?? '';
      _controllers.valorTotal!.text = (locacoes.valorTotal ?? '').toString();
      _controllers.meioPagamentoId!.text = locacoes.meioPagamentoId ?? '';
      _controllers.meioPagamentoNome!.text = locacoes.meioPagamentoNome ?? '';
      _controllers.observacoes!.text = locacoes.observacoes ?? '';
      _controllers.status!.text = locacoes.status ?? '';
      _controllers.dataInicio!.text = (locacoes.dataInicio ?? '').toString();
      _controllers.dataFim!.text = (locacoes.dataFim ?? '').toString();
      _controllers.dataLimitePagamento!.text = (locacoes.dataLimitePagamento ?? '').toString();
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
        'preco': double.parse(_controllers.valorTotal!.text),
        'meioPagamentoId': _controllers.meioPagamentoId!.text,
        'observacoes': _controllers.observacoes!.text,
        'descricao': _controllers.status!.text,
        'dateInicio': _controllers.dataInicio!.text,
        'dataFim': _controllers.dataFim!.text,
        'dataLimitePagamento': _controllers.dataLimitePagamento!.text,
      };

      await Provider.of<LocacoesRepository>(context, listen: false).save(payload).then((id) {
        if (id != '') {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/locacao'));
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
        Navigator.of(context).pushReplacementNamed('/locacao');
      }
    });
  }
}
