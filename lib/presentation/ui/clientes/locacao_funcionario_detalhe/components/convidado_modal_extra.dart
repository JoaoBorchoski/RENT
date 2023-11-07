import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/convidados_repository.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/inputs/app_form_checkbox_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class ModalConvidadoExtraForm extends StatefulWidget {
  const ModalConvidadoExtraForm({
    required this.locacaoId,
    required this.usuarioLocacaoId,
    super.key,
  });

  final String locacaoId;
  final String usuarioLocacaoId;

  @override
  State<ModalConvidadoExtraForm> createState() => _ModalConvidadoExtraFormState();
}

class _ModalConvidadoExtraFormState extends State<ModalConvidadoExtraForm> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _codSocioController = TextEditingController();

  bool _isSocio = false;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() {
    // if (nome.isEmpty && email.isEmpty) return;

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final nome = _nomeController.text;
    final idade = _idadeController.text;
    final codSocio = _codSocioController.text;

    _onSubmit(
      nome,
      int.tryParse(idade) ?? 0,
      codSocio,
    );
  }

  Future<void> _onSubmit(String nome, int idade, String codSocio) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      _formKey.currentState?.save();

      final Map<String, dynamic> payload = {
        'id': '',
        'locacaoId': widget.locacaoId,
        'convidados': [
          {
            'id': _idController.text,
            'nome': nome,
            'idade': idade,
            'codigoSocio': codSocio,
            'isAssociado': _isSocio,
            'isExtra': true,
            'isPresente': true,
          },
        ]
      };

      await Provider.of<ConvidadosRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                message: 'Convidado criado com sucesso!',
              );
            },
          ).then(
            (value) => Navigator.of(context)
                .pushReplacementNamed('/locacao-funcionario-detalhe', arguments: {'id': widget.usuarioLocacaoId}),
          );
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

  Widget get _titleCardText {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Cadastro de Convidado Extra',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: 10),
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

  Widget get _idadeField {
    return FormTextInput(
      label: 'Idade',
      controller: _idadeController,
      isRequired: true,
      keyboardType: TextInputType.number,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _codSocioField {
    return FormTextInput(
      label: 'Código de sócio',
      controller: _codSocioController,
      isRequired: false,
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
                label: 'Adicionar',
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
