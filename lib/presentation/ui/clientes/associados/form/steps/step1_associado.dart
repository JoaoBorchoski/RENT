import 'package:locacao/data/repositories/clientes/status_associados_repository.dart';
import 'package:locacao/data/repositories/usuarios/usuarios_repository.dart';
import 'package:locacao/presentation/components/app_form_text_button.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Step1Associados extends StatefulWidget {
  const Step1Associados({
    super.key,
    required this.controllerStatusAssociadoId,
    required this.controllerStatusAssociadoNome,
    required this.controllerUsuarioId,
    required this.controllerUsuarioCpf,
    required this.controllerCodigoSocio,
    required this.formKey1,
    required this.isViewPage,
    required this.isEditPage,
    required this.checkNextButtonIcon,
  });

  final TextEditingController controllerStatusAssociadoId;
  final TextEditingController controllerStatusAssociadoNome;
  final TextEditingController controllerCodigoSocio;
  final TextEditingController controllerUsuarioId;
  final TextEditingController controllerUsuarioCpf;
  final GlobalKey<FormState> formKey1;

  final bool isViewPage;
  final bool isEditPage;
  final Function() checkNextButtonIcon;

  @override
  State<Step1Associados> createState() => _Step1AssociadosState();
}

class _Step1AssociadosState extends State<Step1Associados> {
  // Builder

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey1,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _usuarioIdField,
                _statusField,
                _codigoSocioField,
                !widget.isViewPage && !widget.isEditPage ? _naoEncontrouUsuario : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _usuarioIdField {
    return FormSelectInput(
      label: 'Usuário',
      isDisabled: widget.isViewPage,
      controllerValue: widget.controllerUsuarioId,
      controllerLabel: widget.controllerUsuarioCpf,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<UsuariosRepository>(context, listen: false).selectByCpf(pattern),
    );
  }

  Widget get _statusField {
    return FormSelectInput(
      label: 'Status',
      isDisabled: widget.isViewPage,
      controllerValue: widget.controllerStatusAssociadoId,
      controllerLabel: widget.controllerStatusAssociadoNome,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<StatusAssociadosRepository>(context, listen: false).select(pattern),
    );
  }

  Widget get _codigoSocioField {
    return FormTextInput(
      label: 'Código Sócio',
      isDisabled: widget.isViewPage,
      controller: widget.controllerCodigoSocio,
      isRequired: true,
    );
  }

  Widget get _naoEncontrouUsuario {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 10),
          Divider(thickness: 1.3),
          SizedBox(height: 10),
          Text('Não encontrou o usuário?', style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 15),
          AppFormTextButton(submit: () {}, label: 'Enviar convite'),
        ],
      ),
    );
  }
}
