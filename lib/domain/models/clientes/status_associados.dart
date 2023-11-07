import 'package:flutter/cupertino.dart';

class StatusAssociados {
  String? id;
  String? clienteId;
  String? clienteNome;
  String? nome;
  String? cor;

  StatusAssociados({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.nome,
    this.cor,
  });
}

class StatusAssociadosController {
  TextEditingController? id;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? nome;
  TextEditingController? cor;

  StatusAssociadosController({
    this.id,
    this.clienteId,
    this.clienteNome,
    this.nome,
    this.cor,
  });
}
