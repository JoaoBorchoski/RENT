import 'package:flutter/cupertino.dart';

class Locacoes {
  String? id;
  String? usuarioLocacaoId;
  String? usuarioId;
  String? usuarioNome;
  String? ativoId;
  String? ativoNome;
  String? clienteId;
  double? valorTotal;
  double? valorTotalConvidados;
  double? valorOutrasTaxas;
  double? valorAtivoInicial;
  String? meioPagamentoId;
  String? meioPagamentoNome;
  DateTime? dataInicio;
  DateTime? dataFim;
  String? horaInicio;
  String? horaFim;
  DateTime? dataPagamento;
  String? horaPagamento;
  DateTime? dataLimitePagamento;
  String? horaLimitePagamento;
  String? observacoes;
  String? status;

  Locacoes({
    this.id,
    this.usuarioLocacaoId,
    this.usuarioId,
    this.usuarioNome,
    this.ativoId,
    this.ativoNome,
    this.clienteId,
    this.valorTotal,
    this.valorTotalConvidados,
    this.valorOutrasTaxas,
    this.valorAtivoInicial,
    this.meioPagamentoId,
    this.meioPagamentoNome,
    this.dataInicio,
    this.dataFim,
    this.horaInicio,
    this.horaFim,
    this.dataPagamento,
    this.dataLimitePagamento,
    this.horaPagamento,
    this.horaLimitePagamento,
    this.observacoes,
    this.status,
  });
}

class LocacoesController {
  TextEditingController? id;
  TextEditingController? valorTotal;
  TextEditingController? valorTotalConvidados;
  TextEditingController? valorOutrasTaxas;
  TextEditingController? valorAtivoInicial;
  TextEditingController? meioPagamentoId;
  TextEditingController? meioPagamentoNome;
  TextEditingController? dataInicio;
  TextEditingController? dataFim;
  TextEditingController? dataPagamento;
  TextEditingController? dataLimitePagamento;
  TextEditingController? horaInicio;
  TextEditingController? horaFim;
  TextEditingController? horaPagamento;
  TextEditingController? horaLimitePagamento;
  TextEditingController? observacoes;
  TextEditingController? status;

  LocacoesController({
    this.id,
    this.valorTotal,
    this.valorTotalConvidados,
    this.valorOutrasTaxas,
    this.valorAtivoInicial,
    this.meioPagamentoId,
    this.meioPagamentoNome,
    this.dataInicio,
    this.dataFim,
    this.dataPagamento,
    this.dataLimitePagamento,
    this.horaInicio,
    this.horaFim,
    this.horaPagamento,
    this.horaLimitePagamento,
    this.observacoes,
    this.status,
  });
}
