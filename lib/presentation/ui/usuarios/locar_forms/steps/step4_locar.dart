import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/components/app_carrossel_list_widget.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/presentation/ui/usuarios/locacao_detalhe/components/convidados_modal.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/cartao.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class Step4Locar extends StatefulWidget {
  final Cartao cartao;
  final Locacoes locacao;
  final Ativo ativo;
  List<Convidados>? convidados;
  List<AtivoTopicoItem> ativoRegrasItems = [];
  TextEditingController meioPagamentoNomeController;

  final Function() checkNextButtonIcon;
  bool showCardFields = false;

  Step4Locar({
    Key? key,
    required this.checkNextButtonIcon,
    required this.locacao,
    required this.ativo,
    required this.cartao,
    required this.convidados,
    required this.meioPagamentoNomeController,
    required this.ativoRegrasItems,
  }) : super(key: key);

  @override
  State<Step4Locar> createState() => _Step4LocarState();
}

class _Step4LocarState extends State<Step4Locar> {
  int convidadosAssociados = 0;
  int convidadosNaoAssociados = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: fieldsDetalhe(context),
    );
  }

  @override
  void initState() {
    super.initState();
    convidadosAssociados = widget.convidados!.where((convidado) => convidado.isAssociado!).toList().length;
    convidadosNaoAssociados = widget.convidados!.where((convidado) => !convidado.isAssociado!).toList().length;
  }

  SingleChildScrollView fieldsDetalhe(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCarrosselListWidget(
            isFavorite: false,
            isInList: false,
            isHistoricoPage: false,
            ativo: Ativo(
              id: widget.ativo.id,
              nome: widget.ativo.nome,
              clienteNome: widget.ativo.clienteNome,
              ativoImagens: widget.ativo.ativoImagens,
            ),
            heightCard: 200,
            marginHorizontalCard: 0,
            marginVerticalCard: 0,
            borderRadius: 0,
            onTapUpFuncion: (_) {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataHora,
                _buildPagemento,
                _buildRegrasDoLugar,
                _buildConvidados,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildDataHora {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Data e hora da locação',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Data de início',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(DateFormat('dd/MM/yyyy').format(widget.locacao.dataInicio!),
                            style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Data de término',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(DateFormat('dd/MM/yyyy').format(widget.locacao.dataFim!),
                            style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Hora de início',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(widget.locacao.horaInicio!, style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Hora de término',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(widget.locacao.horaFim!, style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildPagemento {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Informações de pagamento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meio de pagamento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(widget.meioPagamentoNomeController.text, style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor do ativo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text('R\$ ${double.parse(widget.locacao.valorAtivoInicial.toString()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor convidados não sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text('R\$ ${double.parse(widget.locacao.valorTotalConvidados.toString()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Outras taxas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text('R\$ ${double.parse(widget.locacao.valorOutrasTaxas.toString()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor total',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                    'R\$ ${double.parse(widget.locacao.valorTotal.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildConvidados {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Seus convidados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total de convidados',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(widget.convidados!.length.toString(), style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados não sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(convidadosNaoAssociados.toString(), style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(convidadosAssociados.toString(), style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: showModalConvidados,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    color: AppColors.primary,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                "Ver todos os convidados",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget get _buildRegrasDoLugar {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Lembre-se das regras do lugar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.ativoRegrasItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(AppIcons.icones[widget.ativoRegrasItems[index].icone]),
              title: Text(
                widget.ativoRegrasItems[index].topico,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              horizontalTitleGap: 0,
              dense: true,
            );
          },
        ),
      ],
    );
  }

  void showModalConvidados() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConvidadosModal(
          locacaoId: '',
          listConvidados: widget.convidados!,
          ativoNome: widget.ativo.nome!,
        );
      },
    );
  }
}
