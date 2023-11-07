import 'package:intl/intl.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class LocacoesFuncionarioListWidget extends StatefulWidget {
  final AtivoUsuariosLocacao ativoUsuarioLocacao;

  const LocacoesFuncionarioListWidget(
    this.ativoUsuarioLocacao, {
    Key? key,
  }) : super(key: key);

  @override
  State<LocacoesFuncionarioListWidget> createState() => _LocacoesFuncionarioListWidgetState();
}

class _LocacoesFuncionarioListWidgetState extends State<LocacoesFuncionarioListWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      direction: DismissDirection.startToEnd,
      endToStart: () {},
      startToEnd: () {
        Map data = {'id': widget.ativoUsuarioLocacao.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/locacao-funcionario-detalhe', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': widget.ativoUsuarioLocacao.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/locacao-funcionario-detalhe', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: AppColors.lightGrey,
            elevation: 5,
            child: ExpansionTile(
              iconColor: AppColors.black,
              collapsedIconColor: AppColors.black,
              trailing: SizedBox.shrink(),
              backgroundColor: AppColors.lightGrey,
              expandedAlignment: Alignment.centerLeft,
              childrenPadding: EdgeInsets.only(bottom: 16),
              initiallyExpanded: _isExpanded,
              onExpansionChanged: (value) {
                setState(() {
                  _isExpanded = value;
                });
              },
              title: Text(
                (widget.ativoUsuarioLocacao.ativoNome).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.cardGreyText,
                ),
              ),
              subtitle: Text(
                'Locado por: ${(widget.ativoUsuarioLocacao.usuariosCodigoSocio)} - ${(widget.ativoUsuarioLocacao.usuariosNome)}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.cardGreyText,
                ),
              ),
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Data de início',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardGreyText),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Data de término',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardGreyText),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Hora de início',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardGreyText),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Hora de término',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardGreyText),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Total de convidados',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardGreyText),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Total de convidados presentes',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cardGreyText),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(widget.ativoUsuarioLocacao.locacaoDataInicio!),
                                  style: TextStyle(color: AppColors.cardGreyText),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(widget.ativoUsuarioLocacao.locacaoDataTermino!),
                                  style: TextStyle(color: AppColors.cardGreyText),
                                ),
                                SizedBox(height: 5),
                                Text(widget.ativoUsuarioLocacao.locacaoHoraInicio!,
                                    style: TextStyle(color: AppColors.cardGreyText)),
                                SizedBox(height: 5),
                                Text(
                                  widget.ativoUsuarioLocacao.locacaoHoraTermino!,
                                  style: TextStyle(color: AppColors.cardGreyText),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  widget.ativoUsuarioLocacao.quantidadeConvidados.toString(),
                                  style: TextStyle(color: AppColors.cardGreyText),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  widget.ativoUsuarioLocacao.quantidadeConvidadosPresentes.toString(),
                                  style: TextStyle(color: AppColors.cardGreyText),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
