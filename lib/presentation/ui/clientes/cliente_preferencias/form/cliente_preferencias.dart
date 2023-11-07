import 'package:locacao/data/repositories/clientes/cliente_preferencias_repository.dart';
import 'package:locacao/domain/models/clientes/cliente_preferencias.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/app_time_picker.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_label_widget.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class ClientePreferenciasFormPage extends StatefulWidget {
  const ClientePreferenciasFormPage({super.key});

  @override
  State<ClientePreferenciasFormPage> createState() => _ClientePreferenciasFormPageState();
}

class _ClientePreferenciasFormPageState extends State<ClientePreferenciasFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;

  final _controllers = ClientePreferenciasController(
    id: TextEditingController(),
    valorConvidadoNaoSocio: TextEditingController(),
    limiteLocarAntecedenciaGeral: TextEditingController(),
    horaInicio: TextEditingController(),
    horaFim: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    if (!_dataIsLoaded) {
      _loadData();
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        await showDialog(
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
        ).then((value) =>
            value ? Navigator.of(context).pushNamedAndRemoveUntil('/menu-ativos', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Preferências'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _valorConvidadoNaoSocio,
              _limiteField,
              _horaInicioField,
              _horaFimFiled,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _valorConvidadoNaoSocio {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Valor para convidados não sócios',
        //   style: TextStyle(
        //     fontSize: 17,
        //     color: AppColors.primary,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
        // SizedBox(height: 15),
        FormTextInputLabel(
          label: 'Valor para convidados não sócios',
          keyboardType: TextInputType.number,
          type: TextInputTypes.number,
          isRequired: true,
          controller: _controllers.valorConvidadoNaoSocio!,
        ),
      ],
    );
  }

  Widget get _limiteField {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Limite geral para locar antecipadamente',
        //   style: TextStyle(
        //     fontSize: 17,
        //     color: AppColors.primary,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
        // SizedBox(height: 15),
        FormTextInputLabel(
          label: 'Limite geral para locar antecipadamente (meses)',
          keyboardType: TextInputType.number,
          type: TextInputTypes.number,
          isRequired: true,
          controller: _controllers.limiteLocarAntecedenciaGeral!,
        ),
      ],
    );
  }

  Widget get _horaInicioField {
    return TimePickerInput(
      label: 'Hora Início Permitido',
      type: TextInputTypes.hour,
      isRequired: true,
      controller: _controllers.horaInicio!,
      onSelected: (suggestion) {
        _controllers.horaInicio!.text = suggestion.toString();
      },
    );
  }

  Widget get _horaFimFiled {
    return TimePickerInput(
      label: 'Hora Final Permitido',
      type: TextInputTypes.hour,
      isRequired: true,
      controller: _controllers.horaFim!,
      onSelected: (suggestion) {
        _controllers.horaFim!.text = suggestion.toString();
      },
    );
  }

  Widget get _actionButtons {
    return Row(
      children: [
        Expanded(child: AppFormButton(submit: _cancel, label: 'Cancelar')),
        SizedBox(width: 10),
        Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
      ],
    );
  }

  // Functions

  Future<void> _loadData() async {
    await Provider.of<ClientePreferenciasRepository>(context, listen: false)
        .getByClienteId("")
        .then((cliente) => _populateController(cliente));
  }

  Future<void> _populateController(ClientePreferencias cliente) async {
    setState(() {
      _controllers.id!.text = cliente.id ?? '';
      _controllers.valorConvidadoNaoSocio!.text = (cliente.valorConvidadoNaoSocio ?? 0).toString();
      _controllers.limiteLocarAntecedenciaGeral!.text = (cliente.limiteLocarAntecedenciaGeral ?? 0).toString();
      _controllers.horaInicio!.text = cliente.horaInicio ?? '';
      _controllers.horaFim!.text = cliente.horaFim ?? '';
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
        'limiteAntecedenciaLocarGeral': _controllers.limiteLocarAntecedenciaGeral!.text,
        'valorAtivo': _controllers.valorConvidadoNaoSocio!.text,
        'horaInicio': _controllers.horaInicio!.text,
        'horaFim': _controllers.horaFim!.text,
      };

      await Provider.of<ClientePreferenciasRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(
                  message: _controllers.id!.text == ''
                      ? 'Registro criado com sucesso!'
                      : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/menu-ativos'));
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
        Navigator.of(context).pushReplacementNamed('/menu-ativos');
      }
    });
  }
}
