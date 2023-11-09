// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:locacao/data/repositories/clientes/ativo_imagens_repository.dart';
import 'package:locacao/data/repositories/clientes/ativo_oferece_repository.dart';
import 'package:locacao/data/repositories/clientes/ativo_regras_repository.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/ui/clientes/ativo/models/ativo_topico_item.dart';
import 'package:locacao/presentation/ui/clientes/ativo/utils/populate_controller_ativo.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> submit(
  BuildContext context,
  Ativo ativo,
  List<AtivoTopicoItem> ativoOferece,
  List<AtivoTopicoItem> ativoRegras,
  List<File> images,
  AtivoController controllers,
  bool isEditing,
  List<AtivoImagens> ativoImagensDeletar,
) async {
  try {
    final Map<String, dynamic> payloadAtivo = {
      "id": ativo.id,
      "identificador": ativo.identificador,
      "nome": ativo.nome,
      "descricao": ativo.descricao,
      "valor": ativo.valor,
      "limiteConvidados": ativo.limiteConvidados,
      "limiteConvidadosExtra": ativo.limiteConvidadosExtra,
      "statusId": ativo.statusId,
      "limiteDiasHorasSeguidas": ativo.pagamentoDiaHoraValue == 'hora' ? ativo.limiteDiasHorasSeguidas : 1,
      "pagamentoHoraDia": ativo.pagamentoDiaHoraValue,
      "categoriaId": ativo.categoriaId,
      "limiteAntecedenciaLocar": ativo.limiteAntecedenciaLocar,
      "regrasTopicos": ativoRegras.map((e) {
        return {"topico": e.topico, "icone": e.icone};
      }).toList(),
      "ofereceTopicos": ativoOferece.map((e) {
        return {"topico": e.topico, "icone": e.icone};
      }).toList(),
    };

    await Provider.of<AtivoRepository>(context, listen: false).save(payloadAtivo).then((id) async {
      if (id != '') {
        ativo.id = id;
        controllers.id!.text = id;

        if (images.isNotEmpty) {
          await Provider.of<AtivoImagensRepository>(context, listen: false).saveImages(images, ativo.id!);
        }

        if (ativoImagensDeletar.isNotEmpty) {
          for (var e in ativoImagensDeletar) {
            await Provider.of<AtivoImagensRepository>(context, listen: false).delete(e);
          }
        }
      }
    });
  } on AuthException catch (error) {
    print(error);
    return showDialog(
      context: context,
      builder: (context) {
        return AppPopErrorDialog(message: error.toString());
      },
    );
  } catch (error) {
    print(error);
    return showDialog(
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
  List<AtivoTopicoItem> ativoOfereceItems,
  List<AtivoTopicoItem> ativoRegrasItems,
  List<AtivoImagens> ativoImagens,
  AtivoController controllers,
  Function setStateLoad,
) async {
  await Provider.of<AtivoRepository>(context, listen: false).get(controllers.id!.text).then((ativoRet) async {
    ativo = ativoRet;
    populateController(ativo, controllers);

    ativoImagens = ativo.ativoImagens ?? [];

    await Provider.of<AtivoOfereceRepository>(context, listen: false)
        .getByAtivoId(controllers.id!.text)
        .then((ativoOferece) async {
      ativoOfereceItems.clear();
      ativoOfereceItems.addAll(ativoOferece[0].topico!.map((e) => AtivoTopicoItem(
            topico: e['topico'].toString(),
            id: Random().nextDouble().toString(),
            icone: e['icone'].toString(),
          )));
    });

    await Provider.of<AtivoRegraRepository>(context, listen: false)
        .getByAtivoId(controllers.id!.text)
        .then((ativoRegra) async {
      ativoRegrasItems.clear();
      ativoRegrasItems.addAll(ativoRegra[0].topico!.map((e) => AtivoTopicoItem(
            topico: e['topico'].toString(),
            id: Random().nextDouble().toString(),
            icone: e['icone'].toString(),
          )));
    });
  });

  setStateLoad(ativo, ativoRegrasItems, ativoOfereceItems, ativoImagens);
}
