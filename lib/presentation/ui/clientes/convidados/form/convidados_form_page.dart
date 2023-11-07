import 'package:locacao/data/repositories/clientes/convidados_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
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

class ConvidadosFormPage extends StatefulWidget {
  const ConvidadosFormPage({super.key});

  @override
  State<ConvidadosFormPage> createState() => _ConvidadosFormPageState();
}

class _ConvidadosFormPageState extends State<ConvidadosFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  String? _idLocacaoVoltar;
  late bool _isClienteView;

  final _controllers = ConvidadosController(
    id: TextEditingController(),
    locacaoId: TextEditingController(),
    locacoesDescricao: TextEditingController(),
    email: TextEditingController(),
    nome: TextEditingController(),
    telefone: TextEditingController(),
    codSocio: TextEditingController(),
    idade: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    Authentication auth = Provider.of(context, listen: false);
    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _idLocacaoVoltar = args['idLocacao'] ?? '';
      _isClienteView = auth.tipoUser!.toLowerCase() == 'cliente';

      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil(
                '/locacao-detalhe',
                arguments: {'id': _idLocacaoVoltar, 'isClienteView': _isClienteView},
                (route) => false)
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
                ? Navigator.of(context).pushNamedAndRemoveUntil('/convidado', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Convidado'),
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
              _emailField,
              _telefoneField,
              _idadeField,
              _codigoSocioField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _emailField {
    return FormTextInput(
      label: 'Email',
      isDisabled: _isViewPage,
      controller: _controllers.email!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _telefoneField {
    return FormTextInput(
      label: 'Telefone',
      isDisabled: _isViewPage,
      controller: _controllers.telefone!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _idadeField {
    return FormTextInput(
      label: 'Idade',
      isDisabled: _isViewPage,
      controller: _controllers.idade!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _codigoSocioField {
    return FormTextInput(
      label: 'Código Sócio',
      isDisabled: _isViewPage,
      controller: _controllers.codSocio!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
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
    await Provider.of<ConvidadosRepository>(context, listen: false)
        .get(id)
        .then((convidados) => _populateController(convidados));
  }

  Future<void> _populateController(Convidados convidados) async {
    setState(() {
      _controllers.id!.text = convidados.id ?? '';
      _controllers.locacaoId!.text = convidados.locacaoId ?? '';
      _controllers.locacoesDescricao!.text = convidados.locacoesDescricao ?? '';
      _controllers.email!.text = convidados.email ?? '';
      _controllers.nome!.text = convidados.nome ?? '';
      _controllers.telefone!.text = convidados.telefone ?? '';
      _controllers.codSocio!.text = convidados.codSocio ?? '';
      _controllers.idade!.text = convidados.idade.toString();
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
        'locacaoId': _controllers.locacaoId!.text,
        'email': _controllers.email!.text,
        'nome': _controllers.nome!.text,
      };

      await Provider.of<ConvidadosRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                  message: _controllers.id!.text == ''
                      ? 'Registro criado com sucesso!'
                      : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/convidado'));
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
        Navigator.of(context).pushReplacementNamed('/convidado');
      }
    });
  }
}
