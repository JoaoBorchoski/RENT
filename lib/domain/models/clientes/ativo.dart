import 'package:flutter/cupertino.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/clientes/ativo_oferece.dart';
import 'package:locacao/domain/models/clientes/ativo_regras.dart';

class Ativo {
  String? id;
  String? clienteId;
  String? clienteNome;
  String? categoriaId;
  String? categoriasNome;
  String? identificador;
  String? nome;
  String? descricao;
  double? valor;
  int? limiteConvidados;
  int? limiteConvidadosExtra;
  int? limiteDiasHorasSeguidas;
  int? limiteAntecedenciaLocar;
  String? statusId;
  String? statusNome;
  String? pagamentoDiaHoraValue;
  String? pagamentoDiaHoraNome;
  List<AtivoImagens>? ativoImagens;
  List<AtivoRegra>? ativoRegras;
  List<AtivoOferece>? ativoOferece;
  bool? desabilitado;

  Ativo({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.categoriaId,
    this.categoriasNome,
    this.identificador,
    this.nome,
    this.descricao,
    this.valor,
    this.limiteConvidados,
    this.limiteConvidadosExtra,
    this.limiteDiasHorasSeguidas,
    this.limiteAntecedenciaLocar,
    this.statusId,
    this.statusNome,
    this.pagamentoDiaHoraValue,
    this.pagamentoDiaHoraNome,
    this.ativoImagens,
    this.ativoRegras,
    this.ativoOferece,
    this.desabilitado,
  });
}

class AtivoController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? categoriaId;
  TextEditingController? categoriasNome;
  TextEditingController? identificador;
  TextEditingController? nome;
  TextEditingController? descricao;
  TextEditingController? valor;
  TextEditingController? limiteConvidados;
  TextEditingController? limiteConvidadosExtra;
  TextEditingController? limiteDiasHorasSeguidas;
  TextEditingController? limiteAntecedenciaLocar;
  TextEditingController? statusId;
  TextEditingController? statusNome;
  TextEditingController? pagamentoDiaHoraValue;
  TextEditingController? pagamentoDiaHoraNome;
  bool? desabilitado;

  AtivoController({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.categoriaId,
    this.categoriasNome,
    this.identificador,
    this.nome,
    this.descricao,
    this.valor,
    this.limiteConvidados,
    this.limiteConvidadosExtra,
    this.limiteDiasHorasSeguidas,
    this.limiteAntecedenciaLocar,
    this.pagamentoDiaHoraNome,
    this.pagamentoDiaHoraValue,
    this.statusId,
    this.statusNome,
    this.desabilitado,
  });
}
