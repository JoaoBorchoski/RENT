import 'package:flutter/cupertino.dart';

class MeioPagamento {
  String? id;
  String? nome;
  String? descricao;
  double? taxa;
  bool? desabilitado;

  MeioPagamento({
    this.id,
    this.nome,
    this.descricao,
    this.taxa,
    this.desabilitado,
  });
}

class MeioPagamentoController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? descricao;
  TextEditingController? taxa;
  bool? desabilitado;

  MeioPagamentoController({
    this.id,
    this.nome,
    this.descricao,
    this.taxa,
    this.desabilitado,
  });
}
