// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:locacao/data/repositories/clientes/ativo_regras_repository.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/populate_controller_ativo_locar.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> submit(
  BuildContext context,
  Ativo ativo,
  Locacoes locacoes,
  LocacoesController controllers,
  List<Convidados> convidados,
  Function proximaEtapaFn,
) async {
  try {
    final Map<String, dynamic> payloadLocacao = {
      'id': locacoes.id,
      'valorTotal': locacoes.valorTotal,
      'valorTotalConvidados': locacoes.valorTotalConvidados,
      'valorOutrasTaxas': locacoes.valorOutrasTaxas,
      'valorAtivoInicial': locacoes.valorAtivoInicial,
      'meioPagamentoId': locacoes.meioPagamentoId,
      'dataInicio': locacoes.dataInicio!.toIso8601String(),
      'dataFim': locacoes.dataFim!.toIso8601String(),
      'horaInicio': locacoes.horaInicio,
      'horaFim': locacoes.horaFim,
      'observacoes': locacoes.observacoes,
      'status': locacoes.status,
      'ativoId': ativo.id,
      'convidados': convidados.map((e) {
        return {
          'nome': e.nome,
          'email': e.email,
          'idade': e.idade,
          'codigoSocio': e.codSocio,
          'telefone': e.telefone,
          'isAssociado': e.isAssociado,
        };
      }).toList(),
      // }).toList() ??
      // [],
    };

    await Provider.of<LocacoesRepository>(context, listen: false).save(payloadLocacao).then((id) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopSuccessDialog(message: '${ativo.nome} foi reservado para você!');
        },
      ).then((value) => proximaEtapaFn());
    });
  } on AuthException catch (error) {
    showDialog(
      context: context,
      builder: (context) {
        return AppPopErrorDialog(message: error.toString());
      },
    );
  } catch (error) {
    showDialog(
      context: context,
      builder: (context) {
        return AppPopErrorDialog(message: 'Ocorreu um erro inesperado!');
      },
    );
  }
}

Future<void> loadData(
  BuildContext context,
  Ativo ativo,
  AtivoController controllers,
  List<AtivoTopicoItem> ativoRegrasItems,
  List<AtivoImagens> ativoImagens,
  Function setStateLoad,
) async {
  await Provider.of<AtivoRepository>(context, listen: false).get(ativo.id!).then((ativoRet) async {
    ativo = ativoRet;
    populateControllerAtivoLocar(ativo, controllers);

    ativoImagens = ativo.ativoImagens ?? [];

    await Provider.of<AtivoRegraRepository>(context, listen: false).getByAtivoId(ativo.id!).then((ativoRegra) async {
      ativoRegrasItems.clear();
      ativoRegrasItems.addAll(ativoRegra[0].topico!.map((e) => AtivoTopicoItem(
            topico: e['topico'].toString(),
            id: Random().nextDouble().toString(),
            icone: e['icone'].toString(),
          )));
    });
  });

  setStateLoad(ativo, ativoRegrasItems, ativoImagens);
}
