import 'package:locacao/domain/models/clientes/ativo.dart';

class Favorito {
  String? id;
  String? usuarioId;
  String? usuarioNome;
  Ativo? ativo;

  Favorito({
    this.id,
    this.usuarioId,
    this.usuarioNome,
    this.ativo,
  });
}
