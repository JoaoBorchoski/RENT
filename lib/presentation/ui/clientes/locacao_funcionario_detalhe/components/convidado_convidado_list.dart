// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/ui/clientes/locacao_funcionario_detalhe/components/convidado_modal_extra.dart';
import 'package:locacao/presentation/ui/clientes/locacao_funcionario_detalhe/locacao_funcionario_detalhe_convidado_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class ConvidadoConvidadoList extends StatefulWidget {
  ConvidadoConvidadoList({required this.ativoUsuarioLocacao, super.key});

  AtivoUsuariosLocacao ativoUsuarioLocacao;

  @override
  State<ConvidadoConvidadoList> createState() => _ConvidadoConvidadoListState();
}

class _ConvidadoConvidadoListState extends State<ConvidadoConvidadoList> {
  void showModalConvidadoExtra() {
    if (widget.ativoUsuarioLocacao.ativoLimiteConvidadosExtra == widget.ativoUsuarioLocacao.quantidadeConvidadosExtra) {
      showDialog(
          context: context, builder: (context) => AppPopErrorDialog(message: 'Limite de convidados extra atingido!'));
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalConvidadoExtraForm(
          locacaoId: widget.ativoUsuarioLocacao.locacaoId!,
          usuarioLocacaoId: widget.ativoUsuarioLocacao.id!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildConvidados;
  }

  Widget get _buildConvidados {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        _buildTitle,
        _buildAddConvidadoButton,
        SizedBox(height: 16),
        _buildInfoConvidados,
        SizedBox(height: 16),
        Center(child: _buildList),
      ],
    );
  }

  Widget get _buildTitle {
    return Container(
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
        'Convidados',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget get _buildAddConvidadoButton {
    return AppFormButton(submit: showModalConvidadoExtra, label: 'Adicionar Convidado Extra');
  }

  Widget get _buildInfoConvidados {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Limite de convidados extra',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
            Text(
              widget.ativoUsuarioLocacao.ativoLimiteConvidadosExtra.toString(),
              style: TextStyle(fontSize: 16, color: AppColors.black),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total de convidados extras',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
            Text(
              widget.ativoUsuarioLocacao.quantidadeConvidadosExtra.toString(),
              style: TextStyle(fontSize: 16, color: AppColors.black),
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget get _buildList {
    return widget.ativoUsuarioLocacao.ativosConvidados!.isEmpty
        ? AppNoData()
        : Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView.builder(
              itemCount: widget.ativoUsuarioLocacao.ativosConvidados!.length,
              itemBuilder: (context, index) {
                final Convidados card = widget.ativoUsuarioLocacao.ativosConvidados![index];
                return LocacoesFuncionarioDetalheConvidadoWidget(card);
              },
            ),
          );
  }
}
