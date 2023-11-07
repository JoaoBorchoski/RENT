import 'package:flutter/cupertino.dart';

class StatusAtivo {
  String? id;
  String? clienteId;
  String? clienteNome;
  String? nome;
  String? descricao;
  bool? desabilitado;

  StatusAtivo({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.nome,
    this.descricao,
    this.desabilitado,
  });
}

class StatusAtivoController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? nome;
  TextEditingController? descricao;
  bool? desabilitado;

  StatusAtivoController({
    this.id,
    this.clienteNome,
    this.nome,
    this.descricao,
    this.desabilitado,
  });
}
