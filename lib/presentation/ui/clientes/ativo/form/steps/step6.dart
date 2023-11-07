import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/steps/components/carrossel_files_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class Step6 extends StatelessWidget {
  List<File> selectedImagens;
  List<AtivoImagens> ativoImagens;
  String ativoNome;
  String ativoValor;
  String ativoDescricao;
  String ativoStatus;
  String ativoCategoria;
  String ativoIdentificador;
  List<Map<String, String>> ativoOferece;
  List<Map<String, String>> ativoRegras;
  bool isViewPage;
  bool isEditPage;

  Step6({
    required this.selectedImagens,
    required this.ativoImagens,
    required this.ativoNome,
    required this.ativoValor,
    required this.ativoDescricao,
    required this.ativoOferece,
    required this.ativoRegras,
    required this.ativoStatus,
    required this.ativoCategoria,
    required this.ativoIdentificador,
    required this.isViewPage,
    required this.isEditPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return fieldsDetalhe(context);
  }

  SingleChildScrollView fieldsDetalhe(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarrosselFilesWidget(
            isViewPage: isViewPage,
            isEditPage: isEditPage,
            ativoImagensBd: ativoImagens,
            ativoImagens: selectedImagens,
            ativoNome: ativoNome,
            ativoValor: ativoValor,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCategoriaIdentificador,
                _buildLine,
                _buildDescricao,
                _buildLine,
                _buildLugarOferece,
                _buildLine,
                _buildRegrasLugar,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildStatusCategoriaIdentificador {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Status:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(ativoStatus, style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Categoria:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(ativoCategoria, style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Identificador:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Text(
              ativoIdentificador == "" ? 'Sem identificador pai' : ativoIdentificador,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget get _buildDescricao {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'Descrição',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12),
        Text(
          ativoDescricao,
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget get _buildLine {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          height: 1,
          color: Colors.grey[400],
        ),
        // SizedBox(height: 8),
      ],
    );
  }

  Widget get _buildLugarOferece {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'O que esse lugar oferece?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ativoOferece.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(AppIcons.icones[ativoOferece[index]['icone']]),
              title: Text(
                ativoOferece[index]['topico'].toString(),
                style: TextStyle(
                  color: AppColors.black,
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

  Widget get _buildRegrasLugar {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'Regras do lugar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: ativoRegras.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(AppIcons.icones[ativoRegras[index]['icone']]),
              title: Text(
                ativoRegras[index]['topico'].toString(),
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
}
