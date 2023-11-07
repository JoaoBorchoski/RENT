import 'package:flutter/cupertino.dart';

class ListasNegras {
  String? id;
  String? usuarioId;
  String? usuariosNome;
  String? clienteId;
  String? clienteNome;
  String? motivo;

  ListasNegras({
    this.id,
    this.usuarioId,
    this.usuariosNome,
    this.clienteId,
    this.clienteNome,
    this.motivo,
  });
}

class ListasNegrasController {
  TextEditingController? id;
  TextEditingController? usuarioId;
  TextEditingController? usuariosNome;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? motivo;

  ListasNegrasController({
    this.id,
    this.usuarioId,
    this.usuariosNome,
    this.clienteId,
    this.clienteNome,
    this.motivo,
  });
}
