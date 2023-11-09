import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/comum/cep_repository.dart';
import 'package:locacao/data/repositories/comum/cidade_repository.dart';
import 'package:locacao/data/repositories/comum/estado_repository.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/shared/themes/app_images.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterPageUser extends StatefulWidget {
  const RegisterPageUser({super.key});

  @override
  State<RegisterPageUser> createState() => _RegisterPageUserState();
}

class _RegisterPageUserState extends State<RegisterPageUser> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final idController = TextEditingController();
  final cepController = TextEditingController();
  final cidadeIdController = TextEditingController();
  final estadoUfController = TextEditingController();
  final estadoIdController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeNomeCidadeController = TextEditingController();
  final numeroController = TextEditingController();
  final enderecoController = TextEditingController();
  final complementoController = TextEditingController();

  Widget get _enderecoField {
    return FormTextInput(
      label: 'Endereço',
      controller: enderecoController,
    );
  }

  Widget get _numeroField {
    return FormTextInput(
      label: 'Número',
      controller: numeroController,
    );
  }

  Widget get _bairroField {
    return FormTextInput(
      label: 'Bairro',
      controller: bairroController,
    );
  }

  Widget get _complementoField {
    return FormTextInput(
      label: 'Complemento',
      controller: complementoController,
    );
  }

  Widget get _estadoIdField {
    return FormSelectInput(
      label: 'UF',
      controllerValue: estadoIdController,
      controllerLabel: estadoUfController,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<EstadoRepository>(context, listen: false).select(pattern),
      onSaved: (suggestion) {
        setState(() {
          estadoIdController.text = suggestion['value']!;
          estadoUfController.text = suggestion['label']!;
        });
      },
    );
  }

  Widget get _cidadeIdField {
    return FormSelectInput(
      label: 'Cidade',
      controllerValue: cidadeIdController,
      controllerLabel: cidadeNomeCidadeController,
      isRequired: true,
      itemsCallback: (pattern) async =>
          Provider.of<CidadeRepository>(context, listen: false).select(pattern, estadoIdController.text),
    );
  }

  Widget get _cepField {
    return FormTextInput(
      controller: cepController,
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

  Future<void> cep(String userInputCep) async {
    if (userInputCep.length == 10) {
      final cep = await Provider.of<CepRepository>(context, listen: false)
          .getByCep(userInputCep.replaceAll('-', '').replaceAll('.', ''));
      enderecoController.text = (cep.logradouro ?? '').toUpperCase();
      estadoIdController.text = cep.estadoId!;
      estadoUfController.text = cep.estadoUf!;
      cidadeIdController.text = cep.cidadeId!;
      bairroController.text = cep.bairro!;
      cidadeNomeCidadeController.text = cep.cidadeNomeCidade!.toUpperCase();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    void registerAccount() {
      Map<String, dynamic> data = {
        'nome': nameController.text,
        'email': emailController.text,
        'cpf': cpfController.text,
        'telefone': phoneController.text,
        'endereco': enderecoController.text,
        'numero': numeroController.text,
        'bairro': bairroController.text,
        'complemento': complementoController.text,
        'estadoId': estadoIdController.text,
        'cidadeId': cidadeIdController.text,
        'cep': cepController.text,
      };

      Navigator.of(context).pushReplacementNamed('/aceitar', arguments: data);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 60,
                  child: Image.asset(AppImages.signInLogo),
                ),
                Column(
                  children: [
                    FormTextInput(
                      isRequired: true,
                      label: "Nome",
                      controller: nameController,
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Informe um nome válido';
                        }
                        return null;
                      },
                    ),
                    FormTextInput(
                      label: "Email",
                      controller: emailController,
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
                    ),
                    FormTextInput(
                      label: "CPF",
                      controller: cpfController,
                      isRequired: true,
                      validator: (value) {
                        if (value == '') {
                          return 'Campo obrigatório!';
                        }
                        //final bool isValid = EmailValidator.validate(value);
                        if (!CPFValidator.isValid(value)) {
                          return 'CPF inválido!';
                        }
                        return null;
                      },
                    ),
                    FormTextInput(
                      label: 'Telefone',
                      controller: phoneController,
                      isRequired: true,
                      validator: (value) => value != '' ? null : 'Campo obrigatório!',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, TelefoneInputFormatter()],
                      keyboardType: TextInputType.phone,
                    ),
                    FormTextInput(
                      isRequired: true,
                      isObscureText: true,
                      label: "Senha",
                      controller: passwordController,
                      validator: (password) {
                        if (password.isEmpty) {
                          return 'Informe uma senha válida';
                        }
                        return null;
                      },
                    ),
                    FormTextInput(
                      isRequired: true,
                      isObscureText: true,
                      controller: confirmPasswordController,
                      label: "Confirme a senha",
                      validator: (confirmPassword) {
                        if (passwordController.text != confirmPassword) {
                          return 'Senhas diferentes!';
                        }
                        return null;
                      },
                    ),
                    _cepField,
                    _estadoIdField,
                    _cidadeIdField,
                    _enderecoField,
                    _numeroField,
                    _bairroField,
                    _complementoField,
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
                    foregroundColor: MaterialStateProperty.all<Color>(AppColors.background),
                  ),
                  onPressed: () => registerAccount(),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Cadastrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.all(20),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    onPressed: () => {Navigator.of(context).pushReplacementNamed('/')},
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Já tenho conta',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Opacity(
                    opacity: 0.2,
                    child: SizedBox(
                      width: 110,
                      child: Image.asset(AppImages.companyLogo),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
