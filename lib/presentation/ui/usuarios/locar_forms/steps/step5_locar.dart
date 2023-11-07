import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class Step5Locar extends StatefulWidget {
  final Locacoes locacao;
  final Ativo ativo;

  final Function() checkNextButtonIcon;

  const Step5Locar({
    super.key,
    required this.locacao,
    required this.ativo,
    required this.checkNextButtonIcon,
  });

  @override
  State<Step5Locar> createState() => _Step5LocarState();
}

class _Step5LocarState extends State<Step5Locar> {
  bool isLastStep = false;
  int activeStep = 0;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);

  // Builder

  Widget get _buildTitle {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        'Pagamento da Locação ${widget.ativo.nome}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }

  Widget get _buildCodigoPagamento {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            'Código de Pagamento',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.cardColor),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            '123456789',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.cardColor),
          ),
        ),
      ],
    );
  }

  Widget get _buildQRCode {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Image.asset(
        'assets/images/qrcode.png',
        height: 250,
        width: 250,
      ),
    );
  }

  Widget get _buildValor {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Text(
        'Valor: R\$ ${widget.locacao.valorTotal!.toStringAsFixed(2).replaceAll('.', ',')}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.cardTextColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _buildTitle,
          _buildCodigoPagamento,
          _buildQRCode,
          _buildValor,
        ],
      ),
    );
  }
}
