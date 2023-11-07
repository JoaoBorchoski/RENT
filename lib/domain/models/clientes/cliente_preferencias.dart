import 'package:flutter/cupertino.dart';

class ClientePreferencias {
  String? id;
  String? clienteId;
  String? clienteCnpj;
  String? clienteNome;
  double? valorConvidadoNaoSocio;
  int? limiteLocarAntecedenciaGeral;
  String? horaInicio;
  String? horaFim;

  ClientePreferencias({
    this.id,
    this.clienteId,
    this.clienteCnpj,
    this.clienteNome,
    this.valorConvidadoNaoSocio,
    this.limiteLocarAntecedenciaGeral,
    this.horaInicio,
    this.horaFim,
  });
}

class ClientePreferenciasController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? clienteCnpj;
  TextEditingController? valorConvidadoNaoSocio;
  TextEditingController? limiteLocarAntecedenciaGeral;
  TextEditingController? horaInicio;
  TextEditingController? horaFim;

  ClientePreferenciasController({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.clienteCnpj,
    this.limiteLocarAntecedenciaGeral,
    this.valorConvidadoNaoSocio,
    this.horaInicio,
    this.horaFim,
  });
}
