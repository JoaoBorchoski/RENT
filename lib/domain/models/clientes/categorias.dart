import 'package:flutter/cupertino.dart';

class Categorias {
  String? id;
  String? clienteId;
  String? clienteNome;
  String? nome;
  String? icone;
  bool? desabilitado;

  Categorias({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.nome,
    this.icone,
    this.desabilitado,
  });
}

class CategoriasController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? nome;
  String? icone;
  bool? desabilitado;

  CategoriasController({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.nome,
    this.icone,
    this.desabilitado,
  });
}
