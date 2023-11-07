import 'package:flutter/cupertino.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';

class AtivoUsuariosLocacao {
  String? id;
  String? locacaoId;
  String? locacoesStatus;
  String? locacaoValorTotal;
  String? locacaoValorTotalConvidados;
  String? locacaoValorOutrasTaxas;
  String? locacaoValorAtivoInicial;
  DateTime? locacaoDataInicio;
  DateTime? locacaoDataTermino;
  String? locacaoDataPagamento;
  String? locacaoDataLimitePagamento;
  String? locacaoHoraInicio;
  String? locacaoHoraTermino;
  String? locacaoHoraPagamento;
  String? locacaoHoraLimitePagamento;
  String? locacaoObservacoes;
  String? meioPagamentoId;
  String? meioPagamentoNome;
  String? usuarioId;
  String? usuariosNome;
  String? usuariosCodigoSocio;
  String? ativoId;
  String? ativoNome;
  String? clienteId;
  String? clienteNome;
  String? categoriaId;
  String? categoriaNome;
  String? ativosIdentificador;
  String? ativosDescricao;
  int? ativoLimiteConvidadosExtra;
  List<AtivoImagens>? ativosImagens;
  List<Convidados>? ativosConvidados;
  int? quantidadeConvidadosNaoAssociados;
  int? quantidadeConvidadosAssociados;
  int? quantidadeConvidados;
  int? quantidadeConvidadosPresentes;
  int? quantidadeConvidadosExtra;

  AtivoUsuariosLocacao({
    this.id,
    this.locacaoId,
    this.locacoesStatus,
    this.locacaoValorTotal,
    this.locacaoValorTotalConvidados,
    this.locacaoValorOutrasTaxas,
    this.locacaoValorAtivoInicial,
    this.locacaoDataInicio,
    this.locacaoDataTermino,
    this.locacaoDataPagamento,
    this.locacaoDataLimitePagamento,
    this.locacaoHoraInicio,
    this.locacaoHoraTermino,
    this.locacaoHoraPagamento,
    this.locacaoHoraLimitePagamento,
    this.locacaoObservacoes,
    this.meioPagamentoId,
    this.meioPagamentoNome,
    this.usuarioId,
    this.usuariosNome,
    this.usuariosCodigoSocio,
    this.ativoId,
    this.ativoNome,
    this.clienteId,
    this.clienteNome,
    this.categoriaId,
    this.categoriaNome,
    this.ativosIdentificador,
    this.ativosDescricao,
    this.ativosImagens,
    this.ativoLimiteConvidadosExtra,
    this.ativosConvidados,
    this.quantidadeConvidadosNaoAssociados,
    this.quantidadeConvidadosAssociados,
    this.quantidadeConvidados,
    this.quantidadeConvidadosPresentes,
    this.quantidadeConvidadosExtra,
  });
}

class AtivoUsuariosLocacaoController {
  TextEditingController? id;
  TextEditingController? locacaoId;
  TextEditingController? locacoesStatus;
  TextEditingController? locacaoValorTotal;
  TextEditingController? locacaoValorTotalConvidados;
  TextEditingController? locacaoValorOutrasTaxas;
  TextEditingController? locacaoValorAtivoInicial;
  TextEditingController? locacaoDataInicio;
  TextEditingController? locacaoDataTermino;
  TextEditingController? locacaoDataPagamento;
  TextEditingController? locacaoDataLimitePagamento;
  TextEditingController? locacaoHoraInicio;
  TextEditingController? locacaoHoraTermino;
  TextEditingController? locacaoHoraPagamento;
  TextEditingController? locacaoHoraLimitePagamento;
  TextEditingController? locacaoObservacoes;
  TextEditingController? meioPagamentoId;
  TextEditingController? meioPagamentoNome;
  TextEditingController? usuarioId;
  TextEditingController? usuariosNome;
  TextEditingController? usuariosCodigoSocio;
  TextEditingController? ativoId;
  TextEditingController? ativoNome;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? categoriaId;
  TextEditingController? categoriaNome;
  TextEditingController? ativosIdentificador;
  TextEditingController? ativoLimiteConvidadosExtra;
  TextEditingController? ativosDescricao;

  AtivoUsuariosLocacaoController({
    this.id,
    this.locacaoId,
    this.locacoesStatus,
    this.locacaoValorTotal,
    this.locacaoValorTotalConvidados,
    this.locacaoValorOutrasTaxas,
    this.locacaoValorAtivoInicial,
    this.locacaoDataInicio,
    this.locacaoDataTermino,
    this.locacaoDataPagamento,
    this.locacaoDataLimitePagamento,
    this.locacaoHoraInicio,
    this.locacaoHoraTermino,
    this.locacaoHoraPagamento,
    this.locacaoHoraLimitePagamento,
    this.locacaoObservacoes,
    this.meioPagamentoId,
    this.meioPagamentoNome,
    this.usuarioId,
    this.usuariosNome,
    this.usuariosCodigoSocio,
    this.ativoId,
    this.ativoNome,
    this.clienteId,
    this.clienteNome,
    this.categoriaId,
    this.categoriaNome,
    this.ativosIdentificador,
    this.ativoLimiteConvidadosExtra,
    this.ativosDescricao,
  });
}
