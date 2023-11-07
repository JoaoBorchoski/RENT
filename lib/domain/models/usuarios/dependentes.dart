import 'package:flutter/cupertino.dart';

class Dependentes {
  String? id;
  String? usuarioId;
  String? usuariosNome;
  String? nome;
  String? email;
  String? telefone;
  int? idade;
  String? cpf;
  String? codigoSocio;
  bool? desabilitado;

  Dependentes({
    this.id,
    this.usuarioId,
    this.usuariosNome,
    this.nome,
    this.email,
    this.telefone,
    this.idade,
    this.cpf,
    this.codigoSocio,
    this.desabilitado,
  });
}

class DependentesController {
  TextEditingController? id;
  TextEditingController? usuarioId;
  TextEditingController? usuariosNome;
  TextEditingController? nome;
  TextEditingController? email;
  TextEditingController? telefone;
  TextEditingController? idade;
  TextEditingController? cpf;
  TextEditingController? codigoSocio;
  bool? desabilitado;

  DependentesController({
    this.id,
    this.usuarioId,
    this.usuariosNome,
    this.nome,
    this.email,
    this.telefone,
    this.idade,
    this.cpf,
    this.codigoSocio,
    this.desabilitado,
  });
}
