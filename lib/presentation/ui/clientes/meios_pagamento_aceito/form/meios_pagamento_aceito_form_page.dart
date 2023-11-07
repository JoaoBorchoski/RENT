import 'package:locacao/data/repositories/comum/meio_pagamento_repository.dart';
import 'package:locacao/data/repositories/clientes/meios_pagamento_aceito_repository.dart';
import 'package:locacao/domain/models/clientes/meios_pagamento_aceito.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class MeiosPagamentoAceitoFormPage extends StatefulWidget {
  const MeiosPagamentoAceitoFormPage({super.key});

  @override
  State<MeiosPagamentoAceitoFormPage> createState() => _MeiosPagamentoAceitoFormPageState();
}

class _MeiosPagamentoAceitoFormPageState extends State<MeiosPagamentoAceitoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = MeiosPagamentoAceitoController(
    id: TextEditingController(),
    meioPagamentoId: TextEditingController(),
    meioPagamentoNome: TextEditingController(),
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
            ? Navigator.of(context).pushNamedAndRemoveUntil('/meio-pagamento-aceito', (route) => false)
            : await showDialog(
                context: context,
                builder: (context) {
                  return AppPopAlertDialog(title: 'Sair sem salvar', message: 'Deseja mesmo sair sem salvar as alterações?', botoes: [
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
                  ]);
                },
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/meio-pagamento-aceito', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Meios de Pagamento Aceito'),
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
              _meioPagamentoIdField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

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
    await Provider.of<MeiosPagamentoAceitoRepository>(context, listen: false).get(id).then((meiosPagamentoAceito) => _populateController(meiosPagamentoAceito));
  }

  Future<void> _populateController(MeiosPagamentoAceito meiosPagamentoAceito) async {
    setState(() {
      _controllers.id!.text = meiosPagamentoAceito.id ?? '';
      _controllers.meioPagamentoId!.text = meiosPagamentoAceito.meioPagamentoId ?? '';
      _controllers.meioPagamentoNome!.text = meiosPagamentoAceito.meioPagamentoNome ?? '';
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
        'meioPagamentoId': _controllers.meioPagamentoId!.text,
      };

      await Provider.of<MeiosPagamentoAceitoRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/meio-pagamento-aceito'));
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
        Navigator.of(context).pushReplacementNamed('/meio-pagamento-aceito');
      }
    });
  }
}
