import 'package:locacao/data/repositories/clientes/convidados_repository.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/ui/clientes/locacao_funcionario_detalhe/components/convidado_checkbox.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class LocacoesFuncionarioDetalheConvidadoWidget extends StatefulWidget {
  final Convidados convidado;

  const LocacoesFuncionarioDetalheConvidadoWidget(
    this.convidado, {
    Key? key,
  }) : super(key: key);

  @override
  State<LocacoesFuncionarioDetalheConvidadoWidget> createState() => _LocacoesFuncionarioDetalheConvidadoWidgetState();
}

class _LocacoesFuncionarioDetalheConvidadoWidgetState extends State<LocacoesFuncionarioDetalheConvidadoWidget> {
  bool _isChecked = false;

  @override
  void initState() {
    _isChecked = widget.convidado.isPresente!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _updatePresenteConvidado() async {
      await Provider.of<ConvidadosRepository>(context, listen: false).updatePresenca({
        'id': widget.convidado.id,
        'isPresente': !_isChecked,
      }).then((value) {
        if (value) {
          setState(() {
            _isChecked = !_isChecked;
          });
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar a presença do convidado!'),
            ),
          );
        }
      });
    }

    return AppDismissible(
      direction: DismissDirection.none,
      endToStart: () {},
      startToEnd: () {},
      onDoubleTap: () {},
      body: Column(
        children: <Widget>[
          Card(
            color: widget.convidado.isAssociado! ? AppColors.success : AppColors.alert,
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                color: AppColors.white,
                elevation: 0,
                child: ConvidadoCheckbox(
                  controller: _isChecked,
                  label: widget.convidado.nome!,
                  onChanged: (_) => _updatePresenteConvidado(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
