import 'package:flutter/cupertino.dart';

class Usuarios {
  String? id;
  String? nome;
  String? email;
  String? cpf;
  String? telefone;
  String? endereco;
  String? numero;
  String? bairro;
  String? complemento;
  String? estadoId;
  String? estadoUf;
  String? cidadeId;
  String? cidadeNomeCidade;
  String? cep;
  bool? desabilitado;

  Usuarios({
    this.id,
    this.nome,
    this.email,
    this.cpf,
    this.telefone,
    this.endereco,
    this.numero,
    this.bairro,
    this.complemento,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNomeCidade,
    this.cep,
    this.desabilitado,
  });
}

class UsuariosController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? email;
  TextEditingController? cpf;
  TextEditingController? telefone;
  TextEditingController? endereco;
  TextEditingController? numero;
  TextEditingController? bairro;
  TextEditingController? complemento;
  TextEditingController? estadoId;
  TextEditingController? estadoUf;
  TextEditingController? cidadeId;
  TextEditingController? cidadeNomeCidade;
  TextEditingController? cep;
  bool? desabilitado;

  UsuariosController({
    this.id,
    this.nome,
    this.email,
    this.cpf,
    this.telefone,
    this.endereco,
    this.numero,
    this.bairro,
    this.complemento,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNomeCidade,
    this.cep,
    this.desabilitado,
  });
}
