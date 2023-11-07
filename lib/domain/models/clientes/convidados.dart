import 'package:flutter/cupertino.dart';

class Convidados {
  String? id;
  String? locacaoId;
  String? locacoesDescricao;
  String? email;
  String? nome;
  String? telefone;
  int? idade;
  String? codSocio;
  bool? isAssociado;
  bool? isPresente;
  bool? isExtra;

  Convidados({
    this.id,
    this.locacaoId,
    this.locacoesDescricao,
    this.email,
    this.nome,
    this.telefone,
    this.idade,
    this.codSocio,
    this.isAssociado,
    this.isPresente,
    this.isExtra,
  });
}

class ConvidadosController {
  TextEditingController? id;
  TextEditingController? locacaoId;
  TextEditingController? locacoesDescricao;
  TextEditingController? email;
  TextEditingController? telefone;
  TextEditingController? idade;
  TextEditingController? codSocio;
  TextEditingController? nome;
  TextEditingController? isAssociado;
  TextEditingController? isPresente;
  bool? isExtra;

  ConvidadosController({
    this.id,
    this.locacaoId,
    this.locacoesDescricao,
    this.email,
    this.telefone,
    this.idade,
    this.codSocio,
    this.nome,
    this.isAssociado,
    this.isPresente,
    this.isExtra,
  });
}
