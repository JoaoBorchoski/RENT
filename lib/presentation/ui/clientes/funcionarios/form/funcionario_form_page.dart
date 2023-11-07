import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locacao/data/repositories/clientes/funcionario_repository.dart';
import 'package:locacao/data/repositories/comum/estado_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:locacao/data/repositories/comum/cep_repository.dart';
import 'package:locacao/data/repositories/comum/cidade_repository.dart';
import 'package:locacao/domain/models/clientes/funcionario.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_checkbox_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class FuncionarioFormPage extends StatefulWidget {
  final String email;

  const FuncionarioFormPage({super.key, this.email = ''});

  @override
  State<FuncionarioFormPage> createState() => _FuncionarioFormPageState();
}

class _FuncionarioFormPageState extends State<FuncionarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  bool _isViewPage = false;
  // ignore: unused_field
  bool _isEditPage = false;
  bool _isEditingByFuncionario = false;
  String emailAtual = '';
  late File _selectedImageFile = File('');

  @override
  void initState() {
    super.initState();
    emailAtual = widget.email;
  }

  final _controllers = FuncionarioController(
    id: TextEditingController(),
    nome: TextEditingController(),
    matricula: TextEditingController(),
    cpf: TextEditingController(),
    avatar: TextEditingController(),
    email: TextEditingController(),
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
      _controllers.email!.text = emailAtual;
      _loadDataEmail(emailAtual);
      _isEditingByFuncionario = true;
      _dataIsLoaded = true;
    }

    if (args != null && !_dataIsLoaded) {
      _controllers.id!.text = args['id'] ?? '';
      _loadData(_controllers.id!.text);
      _isViewPage = args['view'] ?? false;
      _isEditPage = !args['view'];
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/funcionarios', (route) => false)
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
                ? Navigator.of(context)
                    .pushNamedAndRemoveUntil(_isEditingByFuncionario ? '/home' : '/funcionarios', (route) => false)
                : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text("Formulário de Funcionário"),
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
              _matriculaField,
              _nomeField,
              _emailField,
              _cpfField,
              _telefoneField,
              _cepField,
              _estadoIdField,
              _cidadeIdField,
              _bairroField,
              _enderecoField,
              _numeroField,
              _complementoField,
              // _isEditPage
              //     ? _imageEditList
              //     : _isViewPage
              //         ? _imageListView
              //         : _imageList,
              _isViewPage ? _imageListView : SizedBox.shrink(),
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _matriculaField {
    return FormTextInput(
      label: 'Matrícula',
      isDisabled: _isViewPage,
      controller: _controllers.matricula!,
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

  Widget get _cpfField {
    return FormTextInput(
      label: 'CPF',
      isDisabled: _isViewPage,
      controller: _controllers.cpf!,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _emailField {
    return FormTextInput(
      label: 'Email',
      isDisabled: _isViewPage || _isEditingByFuncionario,
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
      isRequired: false,
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
      isRequired: false,
      itemsCallback: (pattern) async =>
          Provider.of<CidadeRepository>(context, listen: false).select(pattern, _controllers.estadoId!.text),
    );
  }

  Widget get _cepField {
    return FormTextInput(
      isDisabled: _isViewPage,
      controller: _controllers.cep!,
      isRequired: false,
      label: 'CEP',
      keyboardType: TextInputType.number,
      onChanged: (value) => cep(value),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CepInputFormatter()],
    );
  }

  // ignore: unused_element
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

  // ignore: unused_element
  Widget get _imageEditList {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _selectImages();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: _selectedImageFile.path != ''
                    ? Image.file(
                        _selectedImageFile,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'Nenhuma imagem selecionada',
                              style: TextStyle(color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      )
                    : Image.network(
                        fit: BoxFit.cover,
                        _controllers.avatar!.text,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'Nenhuma imagem selecionada',
                              style: TextStyle(color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.44,
          child: AppFormButton(
            submit: _selectImages,
            label: 'Selecionar Avatar',
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget get _imageList {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _selectImages();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(
                  _selectedImageFile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        'Nenhuma imagem selecionada',
                        style: TextStyle(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.44,
          child: AppFormButton(
            submit: _selectImages,
            label: 'Selecionar Avatar',
          ),
        ),
      ],
    );
  }

  Widget get _imageListView {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            fit: BoxFit.cover,
            _controllers.avatar!.text,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Nenhuma imagem selecionada',
                  style: TextStyle(color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
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

  // Functions

  Future<void> cep(String userInputCep) async {
    if (userInputCep.length == 10) {
      final cep = await Provider.of<CepRepository>(context, listen: false)
          .getByCep(userInputCep.replaceAll('-', '').replaceAll('.', ''));
      _controllers.endereco?.text = (cep.logradouro ?? '').toUpperCase();
      _controllers.estadoId?.text = cep.estadoId!;
      _controllers.estadoUf?.text = cep.estadoUf!;
      _controllers.cidadeId?.text = cep.cidadeId!;
      _controllers.bairro?.text = cep.bairro!;
      _controllers.cidadeNomeCidade?.text = cep.cidadeNomeCidade!.toUpperCase();
    }
    return;
  }

  Future<void> _loadData(String id) async {
    await Provider.of<FuncionarioRepository>(context, listen: false)
        .get(id)
        .then((cliente) => _populateController(cliente));
  }

  Future<void> _loadDataEmail(String email) async {
    await Provider.of<FuncionarioRepository>(context, listen: false)
        .getByEmail(email)
        .then((cliente) => _populateController(cliente));
  }

  Future<void> _populateController(Funcionario cliente) async {
    setState(() {
      _controllers.id!.text = cliente.id ?? '';
      _controllers.nome!.text = cliente.nome ?? '';
      _controllers.email!.text = cliente.email ?? '';
      _controllers.matricula!.text = cliente.matricula ?? '';
      _controllers.cpf!.text = cliente.cpf ?? '';
      _controllers.avatar!.text = cliente.avatar ?? '';
      _controllers.telefone!.text = cliente.telefone ?? '';
      _controllers.endereco!.text = cliente.endereco ?? '';
      _controllers.numero!.text = cliente.numero ?? '';
      _controllers.bairro!.text = cliente.bairro ?? '';
      _controllers.complemento!.text = cliente.complemento ?? '';
      _controllers.estadoId!.text = cliente.estadoId ?? '';
      _controllers.estadoUf!.text = cliente.estadoUf ?? '';
      _controllers.cidadeId!.text = cliente.cidadeId ?? '';
      _controllers.cidadeNomeCidade!.text = cliente.cidadeNomeCidade ?? '';
      _controllers.cep!.text = cliente.cep ?? '';
      _controllers.desabilitado = cliente.desabilitado ?? false;
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
        'matricula': _controllers.matricula!.text,
        'cpf': _controllers.cpf!.text,
        'nome': _controllers.nome!.text,
        'email': _controllers.email!.text,
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

      await Provider.of<FuncionarioRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                message:
                    _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
              );
            },
          ).then((value) =>
              Navigator.of(context).pushReplacementNamed(_isEditingByFuncionario ? '/home' : '/funcionarios'));
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

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImageFile = File(pickedImage!.path);
    });
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
        Navigator.of(context).pushReplacementNamed(_isEditingByFuncionario ? '/home' : '/funcionarios');
      }
    });
  }
}
