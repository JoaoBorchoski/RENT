import 'package:flutter/cupertino.dart';

class Cliente {
  String? id;
  String? cnpj;
  String? nome;
  String? email;
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

  Cliente({
    this.id,
    this.cnpj,
    this.nome,
    this.email,
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

class ClienteController {
  TextEditingController? id;
  TextEditingController? cnpj;
  TextEditingController? nome;
  TextEditingController? email;
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

  ClienteController({
    this.id,
    this.cnpj,
    this.nome,
    this.email,
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
