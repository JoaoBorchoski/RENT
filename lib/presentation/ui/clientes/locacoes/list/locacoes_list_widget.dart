import 'package:intl/intl.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/presentation/ui/usuarios/locar_list/list/recibo_modal.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

import '../utils/pagamentos.dart';

class LocacoesListWidget extends StatefulWidget {
  final AtivoUsuariosLocacao ativoUsuarioLocacao;

  const LocacoesListWidget(
    this.ativoUsuarioLocacao, {
    Key? key,
  }) : super(key: key);

  @override
  State<LocacoesListWidget> createState() => _LocacoesListWidgetState();
}

class _LocacoesListWidgetState extends State<LocacoesListWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showModalRecibo() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ReciboModal(locacao: widget.ativoUsuarioLocacao);
        },
      );
    }

    return AppDismissible(
      direction: DismissDirection.none,
      endToStart: () {},
      startToEnd: () {},
      onDoubleTap: () {
        Map data = {'id': widget.ativoUsuarioLocacao.id, 'view': true, 'isClienteView': true};
        Navigator.of(context).pushReplacementNamed('/locacao-detalhe', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: statusColorHex(pagamentos
                .firstWhere((element) => element['status'] == widget.ativoUsuarioLocacao.locacoesStatus)['color']),
            elevation: 5,
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
                color: AppColors.lightGrey,
                elevation: 0,
                child: ExpansionTile(
                  iconColor: AppColors.black,
                  collapsedIconColor: AppColors.black,
                  backgroundColor: AppColors.lightGrey,
                  expandedAlignment: Alignment.centerLeft,
                  childrenPadding: EdgeInsets.only(bottom: 16),
                  initiallyExpanded: _isExpanded,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  onExpansionChanged: (value) {
                    setState(() {
                      _isExpanded = value;
                    });
                  },
                  title: Text(
                    (widget.ativoUsuarioLocacao.ativoNome).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  subtitle: Text(
                    (widget.ativoUsuarioLocacao.usuariosNome).toString(),
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.wysiwyg,
                          color: Colors.black87,
                          size: 30,
                        ),
                        onPressed: () {
                          showModalRecibo();
                        },
                      ),
                      // Icon(
                      //   _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      //   color: Colors.black87,
                      //   size: 30,
                      // ),
                    ],
                  ),
                  children: [
                    Column(
                      children: [
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
                                        Text('Data da locação',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
                                        SizedBox(height: 5),
                                        Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(widget.ativoUsuarioLocacao.locacaoDataInicio!),
                                            style: TextStyle(color: AppColors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                    child: Column(
                                      children: [
                                        Text('Valor da locação',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
                                        SizedBox(height: 5),
                                        Text(
                                          'R\$ ${double.parse(widget.ativoUsuarioLocacao.locacaoValorTotal.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                                          style: TextStyle(color: AppColors.black),
                                        ),
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
                                        Text('Hora da locação',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
                                        SizedBox(height: 5),
                                        Text(widget.ativoUsuarioLocacao.locacaoHoraInicio!,
                                            style: TextStyle(color: AppColors.black)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Meio de pagamento',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
                                        SizedBox(height: 5),
                                        Text(
                                          widget.ativoUsuarioLocacao.meioPagamentoNome.toString(),
                                          style: TextStyle(color: AppColors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
