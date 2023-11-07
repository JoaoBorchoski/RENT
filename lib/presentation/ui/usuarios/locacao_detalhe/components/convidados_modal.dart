import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:locacao/presentation/ui/usuarios/locacao_detalhe/components/convidados_list_widget.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/steps/components/legenda_socio_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class ConvidadosModal extends StatefulWidget {
  ConvidadosModal({
    required this.listConvidados,
    required this.ativoNome,
    required this.locacaoId,
    super.key,
  });

  List<Convidados> listConvidados;
  String ativoNome;
  String locacaoId;

  @override
  State<ConvidadosModal> createState() => _ConvidadosModalState();
}

class _ConvidadosModalState extends State<ConvidadosModal> {
  Widget get _titleCardText {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Seus convidados para ${widget.ativoNome}",
            textAlign: TextAlign.center,
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

  Widget get _listTopico {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.43,
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: widget.listConvidados.isEmpty
                  ? AppNoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.listConvidados.length,
                      itemBuilder: (context, index) {
                        final Convidados card = widget.listConvidados[index];
                        return ConvidadoListWidget(convidado: card, locacaoId: widget.locacaoId);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              _titleCardText,
              _listTopico,
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: LegendaSocioWidget(widthSize: 0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
