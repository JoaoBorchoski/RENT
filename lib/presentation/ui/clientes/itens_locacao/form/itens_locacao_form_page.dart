import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/data/repositories/clientes/itens_locacao_repository.dart';
import 'package:locacao/domain/models/clientes/itens_locacao.dart';
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

class ItensLocacaoFormPage extends StatefulWidget {
  const ItensLocacaoFormPage({super.key});

  @override
  State<ItensLocacaoFormPage> createState() => _ItensLocacaoFormPageState();
}

class _ItensLocacaoFormPageState extends State<ItensLocacaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = ItensLocacaoController(
    id: TextEditingController(),
    ativoId: TextEditingController(),
    ativoNome: TextEditingController(),
    locacaoId: TextEditingController(),
    locacoesDescricao: TextEditingController(),
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
            ? Navigator.of(context).pushNamedAndRemoveUntil('/item-locacao', (route) => false)
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
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/item-locacao', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('ItemLocacao Form'),
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
              _ativoIdField,
              _locacaoIdField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _ativoIdField {
    return FormSelectInput(
      label: 'Ativo',
      isDisabled: _isViewPage,
      controllerValue: _controllers.ativoId!,
      controllerLabel: _controllers.ativoNome!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<AtivoRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _locacaoIdField {
    return FormSelectInput(
      label: 'Locação',
      isDisabled: _isViewPage,
      controllerValue: _controllers.locacaoId!,
      controllerLabel: _controllers.locacoesDescricao!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<LocacoesRepository>(context, listen: false).select(pattern),
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
    await Provider.of<ItensLocacaoRepository>(context, listen: false).get(id).then((itensLocacao) => _populateController(itensLocacao));
  }

  Future<void> _populateController(ItensLocacao itensLocacao) async {
    setState(() {
      _controllers.id!.text = itensLocacao.id ?? '';
      _controllers.ativoId!.text = itensLocacao.ativoId ?? '';
      _controllers.ativoNome!.text = itensLocacao.ativoNome ?? '';
      _controllers.locacaoId!.text = itensLocacao.locacaoId ?? '';
      _controllers.locacoesDescricao!.text = itensLocacao.locacoesDescricao ?? '';
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
        'ativoId': _controllers.ativoId!.text,
        'locacaoId': _controllers.locacaoId!.text,
      };

      await Provider.of<ItensLocacaoRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/item-locacao'));
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
        Navigator.of(context).pushReplacementNamed('/item-locacao');
      }
    });
  }
}
