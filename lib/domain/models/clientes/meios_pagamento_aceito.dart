import 'package:flutter/cupertino.dart';

class MeiosPagamentoAceito {
  String? id;
  String? clienteId;
  String? clienteNome;
  String? meioPagamentoId;
  String? meioPagamentoNome;
  double? meioPagamentoTaxa;

  MeiosPagamentoAceito({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.meioPagamentoId,
    this.meioPagamentoNome,
    this.meioPagamentoTaxa,
  });
}

class MeiosPagamentoAceitoController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? meioPagamentoId;
  TextEditingController? meioPagamentoNome;
  TextEditingController? meioPagamentoTaxa;

  MeiosPagamentoAceitoController({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.meioPagamentoId,
    this.meioPagamentoNome,
    this.meioPagamentoTaxa,
  });
}
