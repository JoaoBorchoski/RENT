import 'package:flutter/cupertino.dart';

class MeiosPagamentoExcecao {
  String? id;
  String? ativoId;
  String? ativoNome;
  String? meioPagamentoId;
  String? meioPagamentoNome;

  MeiosPagamentoExcecao({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.meioPagamentoId,
    this.meioPagamentoNome,
  });
}

class MeiosPagamentoExcecaoController {
  TextEditingController? id;
  TextEditingController? ativoId;
  TextEditingController? ativoNome;
  TextEditingController? meioPagamentoId;
  TextEditingController? meioPagamentoNome;

  MeiosPagamentoExcecaoController({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.meioPagamentoId,
    this.meioPagamentoNome,
  });
}
