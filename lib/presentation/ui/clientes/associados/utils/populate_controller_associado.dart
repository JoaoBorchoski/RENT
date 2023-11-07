import 'dart:math';

import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:locacao/presentation/ui/clientes/associados/models/dependente_topico_item.dart';

Future<void> populateControllerAssociado(
  Associados associados,
  AssociadosController controllers,
  List<DependenteTopicoItem> dependentes,
) async {
  controllers.id!.text = associados.id ?? '';
  controllers.usuarioId!.text = associados.usuarioId ?? '';
  controllers.usuariosNome!.text = associados.usuariosNome ?? '';
  // controllers.usuarioEmail!.text = associados.usuarioEmail ?? '';
  controllers.usuarioCpf!.text = associados.usuarioCpf ?? '';
  controllers.codigoSocio!.text = associados.codigoSocio ?? '';
  controllers.statusAssociadoId!.text = associados.statusAssociadoId ?? '';
  controllers.statusAssociadoNome!.text = associados.statusAssociadoNome ?? '';
  controllers.statusAssociadoCor!.text = associados.statusAssociadoCor ?? '';
  dependentes.clear();
  dependentes.addAll(associados.dependentes!
      .expand((element) => [
            DependenteTopicoItem(
              id: Random().nextDouble().toString(),
              nome: element.nome!,
              email: element.email!,
              codigoSocio: element.codigoSocio!,
              cpf: element.cpf!,
              idade: element.idade!,
              telefone: element.telefone!,
            )
          ])
      .toList());
}
