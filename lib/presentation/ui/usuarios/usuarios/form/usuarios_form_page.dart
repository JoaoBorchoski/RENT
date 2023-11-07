import 'package:locacao/data/repositories/comum/estado_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:locacao/data/repositories/comum/cep_repository.dart';
import 'package:locacao/data/repositories/comum/cidade_repository.dart';
import 'package:locacao/data/repositories/usuarios/usuarios_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/usuarios/usuarios.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_checkbox_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class UsuariosFormPage extends StatefulWidget {
  final String email;

  const UsuariosFormPage({super.key, this.email = ''});

  @override
  State<UsuariosFormPage> createState() => _UsuariosFormPageState();
}

class _UsuariosFormPageState extends State<UsuariosFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  bool _isFirstLoginPage = false;
  String emailAtual = '';

  @override
  void initState() {
    super.initState();
    emailAtual = widget.email;
  }

  final _controllers = UsuariosController(
    id: TextEditingController(),
    nome: TextEditingController(),
    email: TextEditingController(),
    cpf: TextEditingController(),
    telefone: TextEditingController(),
    endereco: TextEditingController(),
    numero: TextEditingController(),
    bairro: TextEditingController(),
    complemento: TextEditingController(),
    estadoId: TextEditingController(),
    estadoUf: TextEditingController(),
    cidadeId: TextEditingController(),
    cidadeNomeCidade: TextEditingController(),
    cep: TextEditingController(),
    desabilitado: false,
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (emailAtual != '' && !_dataIsLoaded) {
      _loadDataEmail(emailAtual);
      _dataIsLoaded = true;
    }

    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _isFirstLoginPage = args['firstLogin'] ?? false;
      if (_isFirstLoginPage) {
        _populateControllerFirstLogin();
      }
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false)
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
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text(_isFirstLoginPage
            ? "Termine seu cadastro"
            : _isViewPage
                ? "Visualiza seu perfil"
                : "Edite seu Usuário"),
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
              _cpfField,
              _telefoneField,
              _cepField,
              _estadoIdField,
              _cidadeIdField,
              _enderecoField,
              _numeroField,
              _bairroField,
              _complementoField,
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
      isDisabled: true,
      controller: _controllers.nome!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _emailField {
    return FormTextInput(
      label: 'Email',
      isDisabled: true,
      controller: _controllers.email!,
      isRequired: true,
      validator: (value) {
        if (value == '') {
          return 'Campo obrigatório!';
        }
        final bool isValid = EmailValidator.validate(value);
        if (!isValid) {
          return 'E-Mail inválido!';
        }
        return null;
      },
    );
  }

  Widget get _cpfField {
    return FormTextInput(
      label: 'CPF',
      isDisabled: _isViewPage,
      controller: _controllers.cpf!,
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, TelefoneInputFormatter()],
      keyboardType: TextInputType.phone,
    );
  }

  Widget get _enderecoField {
    return FormTextInput(
      label: 'Endereço',
      isDisabled: _isViewPage,
      controller: _controllers.endereco!,
    );
  }

  Widget get _numeroField {
    return FormTextInput(
      label: 'Número',
      isDisabled: _isViewPage,
      controller: _controllers.numero!,
    );
  }

  Widget get _bairroField {
    return FormTextInput(
      label: 'Bairro',
      isDisabled: _isViewPage,
      controller: _controllers.bairro!,
    );
  }

  Widget get _complementoField {
    return FormTextInput(
      label: 'Complemento',
      isDisabled: _isViewPage,
      controller: _controllers.complemento!,
    );
  }

  Widget get _estadoIdField {
    return FormSelectInput(
      label: 'UF',
      isDisabled: _isViewPage,
      controllerValue: _controllers.estadoId!,
      controllerLabel: _controllers.estadoUf!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<EstadoRepository>(context, listen: false).select(pattern),
      onSaved: (suggestion) {
        setState(() {
          _controllers.estadoId!.text = suggestion['value']!;
          _controllers.estadoUf!.text = suggestion['label']!;
        });
      },
    );
  }

  Widget get _cidadeIdField {
    return FormSelectInput(
      label: 'Cidade',
      isDisabled: _isViewPage,
      controllerValue: _controllers.cidadeId!,
      controllerLabel: _controllers.cidadeNomeCidade!,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<CidadeRepository>(context, listen: false).select(pattern, _controllers.estadoId!.text),
    );
  }

  Widget get _cepField {
    return FormTextInput(
      isDisabled: _isViewPage,
      controller: _controllers.cep!,
      label: 'CEP',
      keyboardType: TextInputType.number,
      onChanged: (value) => cep(value),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CepInputFormatter()],
      validator: (value) {
        if (value.length != 10) {
          return 'CEP inválido!';
        }
      },
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
        : _isFirstLoginPage
            ? Row(
                children: [
                  Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
                ],
              )
            : Row(
                children: [
                  Expanded(child: AppFormButton(submit: _cancel, label: 'Cancelar')),
                  SizedBox(width: 10),
                  Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
                ],
              );
  }

  // Functions

  Future<void> cep(String userInputCep) async {
    if (userInputCep.length == 10) {
      final cep = await Provider.of<CepRepository>(context, listen: false).getByCep(userInputCep.replaceAll('-', '').replaceAll('.', ''));
      _controllers.endereco?.text = (cep.logradouro ?? '').toUpperCase();
      _controllers.estadoId?.text = cep.estadoId!;
      _controllers.estadoUf?.text = cep.estadoUf!;
      _controllers.cidadeId?.text = cep.cidadeId!;
      _controllers.bairro?.text = cep.bairro!;
      _controllers.cidadeNomeCidade?.text = cep.cidadeNomeCidade!.toUpperCase();
    }
    return;
  }

  Future<void> _loadDataEmail(String email) async {
    await Provider.of<UsuariosRepository>(context, listen: false).getByEmail(email).then((usuarios) => _populateController(usuarios));
  }

  Future<void> _loadData(String id) async {
    await Provider.of<UsuariosRepository>(context, listen: false).get(id).then((usuarios) => _populateController(usuarios));
  }

  Future<void> _populateController(Usuarios usuarios) async {
    setState(() {
      _controllers.id!.text = usuarios.id ?? '';
      _controllers.nome!.text = usuarios.nome ?? '';
      _controllers.email!.text = usuarios.email ?? '';
      _controllers.cpf!.text = usuarios.cpf ?? '';
      _controllers.telefone!.text = usuarios.telefone ?? '';
      _controllers.endereco!.text = usuarios.endereco ?? '';
      _controllers.numero!.text = usuarios.numero ?? '';
      _controllers.bairro!.text = usuarios.bairro ?? '';
      _controllers.complemento!.text = usuarios.complemento ?? '';
      _controllers.estadoId!.text = usuarios.estadoId ?? '';
      _controllers.estadoUf!.text = usuarios.estadoUf ?? '';
      _controllers.cidadeId!.text = usuarios.cidadeId ?? '';
      _controllers.cidadeNomeCidade!.text = usuarios.cidadeNomeCidade ?? '';
      _controllers.cep!.text = usuarios.cep ?? '';
      _controllers.desabilitado = usuarios.desabilitado ?? false;
    });
  }

  Future<void> _populateControllerFirstLogin() async {
    Authentication authentication = Provider.of(context, listen: false);

    setState(() {
      _controllers.nome!.text = authentication.nameField ?? '';
      _controllers.email!.text = authentication.loginField ?? '';
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
        'email': _controllers.email!.text,
        'cpf': _controllers.cpf!.text,
        'telefone': _controllers.telefone!.text,
        'endereco': _controllers.endereco!.text,
        'numero': _controllers.numero!.text,
        'bairro': _controllers.bairro!.text,
        'complemento': _controllers.complemento!.text,
        'estadoId': _controllers.estadoId!.text,
        'cidadeId': _controllers.cidadeId!.text,
        'cep': _controllers.cep!.text,
        'desabilitado': _controllers.desabilitado!,
      };

      await Provider.of<UsuariosRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
              );
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/home'));
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
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }
}
