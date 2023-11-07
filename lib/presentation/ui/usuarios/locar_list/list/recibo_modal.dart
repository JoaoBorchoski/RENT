import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/ui/clientes/locacoes/utils/pagamentos.dart';

class ReciboModal extends StatelessWidget {
  const ReciboModal({required this.locacao, super.key});

  final AtivoUsuariosLocacao locacao;

  Widget get _buildTitle {
    return Column(
      children: const [
        Text(
          'Recibo',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget get _buildDescricao {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Descrição:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Locação de ${locacao.ativoNome}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildDataHoraInicio {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Data e Hora:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${DateFormat('dd/MM/yyyy').format(locacao.locacaoDataInicio!)} ${locacao.locacaoHoraInicio}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildDataHoraPagamento {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Data e Hora Pagamento:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              locacao.locacaoDataPagamento != null && locacao.locacaoDataPagamento != ""
                  ? '${DateFormat('dd/MM/yyyy').format(DateTime.parse(locacao.locacaoDataPagamento!))} ${locacao.locacaoHoraPagamento!}'
                  : 'Ainda não pago',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildValor {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Valor Total:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'R\$ ${double.parse(locacao.locacaoValorTotal.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildNumeroTotalConvidados {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Número total de convidados:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${locacao.quantidadeConvidados}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildNumeroConvidadosNaoSocios {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Número convidados não associados:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${locacao.quantidadeConvidadosNaoAssociados}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildNumeroConvidadosSocios {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Número convidados associados:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${locacao.quantidadeConvidados! - locacao.quantidadeConvidadosNaoAssociados!}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  Widget get _buildStatus {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              pagamentos.firstWhere((element) => element['status'] == locacao.locacoesStatus)['title']!,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ],
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
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTitle,
                _buildDescricao,
                _buildDataHoraInicio,
                _buildDataHoraPagamento,
                _buildValor,
                _buildNumeroTotalConvidados,
                _buildNumeroConvidadosNaoSocios,
                _buildNumeroConvidadosSocios,
                _buildStatus,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
