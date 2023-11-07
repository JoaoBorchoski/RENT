import 'package:flutter/cupertino.dart';

class Funcionario {
  String? id;
  String? clienteId;
  String? clienteNome;
  String? avatar;
  String? nome;
  String? email;
  String? matricula;
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

  Funcionario({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.avatar,
    this.matricula,
    this.cpf,
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

class FuncionarioController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? avatar;
  TextEditingController? matricula;
  TextEditingController? cpf;
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

  FuncionarioController({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.avatar,
    this.matricula,
    this.cpf,
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
