import 'package:brasil_fields/brasil_fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/inputs/app_form_checkbox_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class ModalConvidadoForm extends StatefulWidget {
  const ModalConvidadoForm(
    this.onSubmit,
    this.title, {
    this.onEdit,
    this.convidado,
    this.editMode = false,
    super.key,
  });

  final Function(String, int, String, String, String) onSubmit;
  final Function(String)? onEdit;
  final Convidados? convidado;
  final bool editMode;
  final String title;

  @override
  State<ModalConvidadoForm> createState() => _ModalConvidadoFormState();
}

class _ModalConvidadoFormState extends State<ModalConvidadoForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();
  final _codSocioController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool _isSocio = false;

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _nomeController.text = widget.convidado!.nome!;
      _emailController.text = widget.convidado!.email!;
      _idadeController.text = widget.convidado!.idade!.toString();
      _codSocioController.text = widget.convidado!.codSocio!;
      _telefoneController.text = widget.convidado!.telefone!;
    }
  }

  _submitForm() {
    // if (nome.isEmpty && email.isEmpty) return;

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final nome = _nomeController.text;
    final email = _emailController.text;
    final idade = _idadeController.text;
    final codSocio = _codSocioController.text;
    final telefone = _telefoneController.text;

    if (widget.editMode) {
      widget.onEdit!(widget.convidado!.id!);
    }

    widget.onSubmit(
      nome,
      int.tryParse(idade) ?? 0,
      email,
      codSocio,
      telefone,
    );
  }

  Widget get _titleCardText {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget get _nomeField {
    return FormTextInput(
      label: 'Nome',
      controller: _nomeController,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _emailField {
    return FormTextInput(
      label: 'Email',
      controller: _emailController,
      isRequired: false,
      validator: (value) {
        if (value != '') {
          final bool isValid = EmailValidator.validate(value);
          if (!isValid) {
            return 'E-Mail inválido!';
          }
          return null;
        }
      },
    );
  }

  Widget get _codSocioField {
    return FormTextInput(
      label: 'Código de sócio',
      controller: _codSocioController,
      isRequired: false,
    );
  }

  Widget get _idadeField {
    return FormTextInput(
      label: 'Idade',
      controller: _idadeController,
      isRequired: true,
      keyboardType: TextInputType.number,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _telefoneField {
    return FormTextInput(
      label: 'Telefone',
      controller: _telefoneController,
      isRequired: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, TelefoneInputFormatter()],
      keyboardType: TextInputType.phone,
    );
  }

  Widget get _isSocioField {
    return AppCheckbox(
      label: 'Convidado é Sócio',
      controller: _isSocio,
      onChanged: (value) {
        setState(() {
          _isSocio = value;
        });
      },
    );
  }

  Widget get _submitButton {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppFormButton(
                submit: _submitForm,
                label: widget.editMode ? 'Editar' : 'Adicionar',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        color: AppColors.background,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _titleCardText,
                _nomeField,
                _idadeField,
                _telefoneField,
                _emailField,
                _isSocioField,
                _isSocio ? _codSocioField : SizedBox.shrink(),
                _submitButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
