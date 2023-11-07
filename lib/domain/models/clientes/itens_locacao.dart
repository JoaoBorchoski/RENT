import 'package:flutter/cupertino.dart';

class ItensLocacao {
  String? id;
  String? ativoId;
  String? ativoNome;
  String? locacaoId;
  String? locacoesDescricao;

  ItensLocacao({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.locacaoId,
    this.locacoesDescricao,
  });
}

class ItensLocacaoController {
  TextEditingController? id;
  TextEditingController? ativoId;
  TextEditingController? ativoNome;
  TextEditingController? locacaoId;
  TextEditingController? locacoesDescricao;

  ItensLocacaoController({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.locacaoId,
    this.locacoesDescricao,
  });
}
