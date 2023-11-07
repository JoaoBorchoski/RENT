import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/presentation/ui/clientes/categorias/form/icons_grid.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class ModalTopicoForm extends StatefulWidget {
  const ModalTopicoForm(
    this.onSubmit,
    this.title, {
    this.onEdit,
    this.onEditId,
    this.ativoTopico,
    this.editMode = false,
    super.key,
  });

  final Function(String, String) onSubmit;
  final Function(String, String, String)? onEdit;
  final String? onEditId;
  final AtivoTopicoItem? ativoTopico;
  final bool editMode;
  final String title;

  @override
  State<ModalTopicoForm> createState() => _ModalTopicoFormState();
}

class _ModalTopicoFormState extends State<ModalTopicoForm> {
  final _topicoController = TextEditingController();
  String iconeValue = "";

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _topicoController.text = widget.ativoTopico!.topico;
      iconeValue = widget.ativoTopico!.icone;
    }
  }

  _submitForm() {
    final topico = _topicoController.text;
    final icone = iconeValue;
    if (topico.isEmpty || icone == '') return;

    if (widget.editMode) {
      widget.onEdit!(widget.onEditId!, topico, icone);
    } else {
      widget.onSubmit(topico, icone);
    }
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

  Widget get _topicoField {
    return FormTextInput(
      label: 'Item',
      controller: _topicoController,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _iconeField {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: IconGrid(
        selectedIcon: iconeValue,
        isViewPage: false,
        onIconSelected: (selectedIcon) {
          setState(() {
            iconeValue = selectedIcon;
          });
        },
      ),
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
              _topicoField,
              _iconeField,
              _submitButton,
            ],
          ),
        ),
      ),
    );
  }
}
