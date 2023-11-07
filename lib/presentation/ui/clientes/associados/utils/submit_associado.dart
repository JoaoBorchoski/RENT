import 'package:locacao/data/repositories/clientes/associados_repository.dart';
import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/ui/clientes/associados/models/dependente_topico_item.dart';
import 'package:locacao/presentation/ui/clientes/associados/utils/populate_controller_associado.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> submitAssociado(
  BuildContext context,
  Associados associado,
  List<DependenteTopicoItem> dependentes,
  AssociadosController controllers,
  bool isEditing,
) async {
  try {
    final Map<String, dynamic> payloadAssociado = {
      "id": associado.id,
      "usuarioId": associado.usuarioId,
      "statusId": associado.statusAssociadoId,
      "codigoSocio": associado.codigoSocio,
      "dependentes": dependentes
          .map((e) => {
                "nome": e.nome,
                "email": e.email,
                "cpf": e.cpf,
                "codigoSocio": e.codigoSocio,
                "idade": e.idade,
                "telefone": e.telefone,
              })
          .toList(),
    };

    await Provider.of<AssociadosRepository>(context, listen: false).save(payloadAssociado).then((validado) async {
      if (validado == 200) {
        return showDialog(
          context: context,
          builder: (context) {
            return AppPopSuccessDialog(
              message: controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!',
            );
          },
        );
      }
    });
  } on AuthException catch (error) {
    return showDialog(
      context: context,
      builder: (context) {
        return AppPopErrorDialog(message: error.toString());
      },
    );
  } catch (error) {
    if (error.toString().contains('409')) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: 'Usuário já associado!');
        },
      ).then((value) => Navigator.of(context).pushReplacementNamed('/associado'));
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AppPopErrorDialog(message: 'Ocorreu um erro inesperado!');
      },
    );
  }
}

Future<void> loadDataAssociados(
  BuildContext context,
  Associados associado,
  List<DependenteTopicoItem> dependentes,
  AssociadosController controllers,
  Function setStateLoad,
) async {
  await Provider.of<AssociadosRepository>(context, listen: false).get(controllers.id!.text).then((associadoRet) async {
    associado = associadoRet;
    populateControllerAssociado(associado, controllers, dependentes);
  });

  setStateLoad(associado, dependentes);
}
