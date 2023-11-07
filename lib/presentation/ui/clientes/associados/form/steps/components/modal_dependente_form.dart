import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/ui/clientes/associados/models/dependente_topico_item.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class ModalDependenteForm extends StatefulWidget {
  const ModalDependenteForm(
    this.onSubmit,
    this.title, {
    this.onEdit,
    this.dependente,
    this.editMode = false,
    super.key,
  });

  final Function(String, String, String, String, int, String) onSubmit;
  final Function(String)? onEdit;
  final DependenteTopicoItem? dependente;
  final bool editMode;
  final String title;

  @override
  State<ModalDependenteForm> createState() => _ModalDependenteFormState();
}

class _ModalDependenteFormState extends State<ModalDependenteForm> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();
  final _codigoSocioController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _nomeController.text = widget.dependente!.nome;
      _emailController.text = widget.dependente!.email;
      _codigoSocioController.text = widget.dependente!.codigoSocio;
      _cpfController.text = widget.dependente!.cpf;
      _idadeController.text = widget.dependente!.idade.toString();
      _telefoneController.text = widget.dependente!.telefone;
    }
  }

  _submitForm() {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final codigoSocio = _codigoSocioController.text;
    final cpf = _cpfController.text;
    final idade = int.tryParse(_idadeController.text);
    final telefone = _telefoneController.text;
    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || idade! < 0) return;

    if (widget.editMode) {
      widget.onEdit!(widget.dependente!.id);
    }

    widget.onSubmit(
      nome,
      email,
      cpf,
      codigoSocio,
      idade,
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
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _telefoneField {
    return FormTextInput(
      label: 'Telefone',
      controller: _telefoneController,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _idadeField {
    return FormTextInput(
      label: 'Idade',
      keyboardType: TextInputType.number,
      controller: _idadeController,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _cpfField {
    return FormTextInput(
      label: 'Cpf',
      keyboardType: TextInputType.number,
      controller: _cpfController,
      isRequired: false,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _codigoSocioField {
    return FormTextInput(
      label: 'Código Sócio',
      controller: _codigoSocioController,
      isRequired: false,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
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
          child: Column(
            children: [
              _titleCardText,
              _nomeField,
              _emailField,
              _idadeField,
              _telefoneField,
              _cpfField,
              _codigoSocioField,
              _submitButton,
            ],
          ),
        ),
      ),
    );
  }
}
