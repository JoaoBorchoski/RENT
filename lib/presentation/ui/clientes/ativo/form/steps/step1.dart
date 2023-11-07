import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/status_ativo_repository.dart';
// import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/categorias.dart';
import 'package:locacao/domain/models/clientes/status_ativo.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/inputs/app_form_multiline_text_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/ativo_categoria_search_form.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/ativo_identificador_pai_search_form.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class Step1 extends StatefulWidget {
  final TextEditingController controllerCategoriaId;
  final TextEditingController controllerCategoriaNome;
  final TextEditingController controllerIdentificador;
  final TextEditingController controllerNome;
  final TextEditingController controllerDescricao;
  final TextEditingController controllerValor;
  final TextEditingController controllerPagamentoDiaHoraValue;
  final TextEditingController controllerPagamentoDiaHoraNome;
  final TextEditingController controllerStatusId;
  final TextEditingController controllerStatusNome;
  final TextEditingController ativoNome;
  final Ativo ativo;
  final GlobalKey<FormState> formKey1;

  final bool isViewPage;
  final Function() checkNextButtonIcon;
  const Step1({
    super.key,
    required this.controllerCategoriaId,
    required this.controllerCategoriaNome,
    required this.controllerIdentificador,
    required this.controllerNome,
    required this.controllerDescricao,
    required this.controllerValor,
    required this.controllerPagamentoDiaHoraValue,
    required this.controllerPagamentoDiaHoraNome,
    required this.controllerStatusId,
    required this.controllerStatusNome,
    required this.ativoNome,
    required this.isViewPage,
    required this.checkNextButtonIcon,
    required this.ativo,
    required this.formKey1,
  });

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  bool isLastStep = false;
  int activeStep = 0;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  List<Categorias> categorias = [];
  List<StatusAtivo> statusAtivo = [];
  List<Widget> actionsScaffold = [];
  String pagamentoDiaHora = '';

  // Builder

  Widget get _categoriaIdField {
    // Authentication authentication = Provider.of(context, listen: false);

    // return FormSelectInput(
    //   label: 'Categoria',
    //   isDisabled: widget.isViewPage,
    //   controllerValue: widget.controllerCategoriaId,
    //   controllerLabel: widget.controllerCategoriaNome,
    //   isRequired: true,
    //   itemsCallback: (pattern) async =>
    //       Provider.of<CategoriasRepository>(context, listen: false).select(pattern, authentication.usuarioClienteId!),
    // );

    return AtivoCategoriaSearchForm(
      controllerNomeCategoria: widget.controllerCategoriaNome,
      controllerIdCategoria: widget.controllerCategoriaId,
      view: widget.isViewPage,
      ativo: widget.ativo,
    );
  }

  Widget get _identificadorField {
    // return FormSelectInput(
    //   clear: true,
    //   label: 'Identificador Pai',
    //   isDisabled: widget.isViewPage,
    //   controllerValue: widget.controllerIdentificador,
    //   controllerLabel: widget.ativoNome,
    //   itemsCallback: (pattern) async => Provider.of<AtivoRepository>(context, listen: false).select(pattern),
    // );
    return AtivoIdentificadorPaiSearchForm(
      controllerNomeIdentificador: widget.ativoNome,
      controllerValueIdentificador: widget.controllerIdentificador,
      view: widget.isViewPage,
      ativo: widget.ativo,
    );
  }

  Widget get _nomeField {
    return FormTextInput(
      label: 'Nome',
      isDisabled: widget.isViewPage,
      controller: widget.controllerNome,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _descricaoField {
    return FormMultilineTextInput(
      label: 'Descrição',
      isDisabled: widget.isViewPage,
      keyboardType: TextInputType.multiline,
      controller: widget.controllerDescricao,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _pagamentoDiaHora {
    return FormSelectInput(
      label: 'Locado por dia ou hora',
      isDisabled: widget.isViewPage,
      controllerValue: widget.controllerPagamentoDiaHoraValue,
      controllerLabel: widget.controllerPagamentoDiaHoraNome,
      isRequired: true,
      validator: (value) {
        if (value == 'dia' || value == 'hora' || value == 'Dia' || value == 'Hora') {
          return null;
        }
        return 'Selecione uma opção válida: "Dia" ou "Hora".';
      },
      itemsCallback: (_) async => [
        {'value': 'dia', 'label': 'Dia'},
        {'value': 'hora', 'label': 'Hora'}
      ],
    );
  }

  Widget get _valorField {
    return FormTextInput(
      label: 'Valor',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      type: TextInputTypes.number,
      isDisabled: widget.isViewPage,
      controller: widget.controllerValor,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _statusField {
    return FormSelectInput(
      label: 'Status',
      isDisabled: widget.isViewPage,
      controllerValue: widget.controllerStatusId,
      controllerLabel: widget.controllerStatusNome,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<StatusAtivoRepository>(context, listen: false).select(pattern),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey1,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            _categoriaIdField,
            _identificadorField,
            _nomeField,
            _valorField,
            _pagamentoDiaHora,
            _statusField,
            _descricaoField,
          ],
        ),
      ),
    );
  }
}
