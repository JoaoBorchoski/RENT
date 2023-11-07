import 'package:flutter/cupertino.dart';
import 'package:locacao/domain/models/usuarios/dependentes.dart';

class Associados {
  String? id;
  String? codigoSocio;
  String? usuarioId;
  String? usuariosNome;
  String? usuarioEmail;
  String? usuarioCpf;
  String? clienteId;
  String? clienteNome;
  String? statusAssociadoId;
  String? statusAssociadoNome;
  String? statusAssociadoCor;
  List<Dependentes>? dependentes;

  Associados({
    this.id,
    this.codigoSocio,
    this.usuarioId,
    this.usuariosNome,
    this.usuarioCpf,
    this.usuarioEmail,
    this.clienteId,
    this.clienteNome,
    this.statusAssociadoId,
    this.statusAssociadoNome,
    this.statusAssociadoCor,
    this.dependentes,
  });
}

class AssociadosController {
  TextEditingController? id;
  TextEditingController? codigoSocio;
  TextEditingController? usuarioId;
  TextEditingController? usuariosNome;
  TextEditingController? usuarioEmail;
  TextEditingController? usuarioCpf;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? statusAssociadoId;
  TextEditingController? statusAssociadoNome;
  TextEditingController? statusAssociadoCor;

  AssociadosController({
    this.id,
    this.codigoSocio,
    this.usuarioId,
    this.usuariosNome,
    this.usuarioCpf,
    this.usuarioEmail,
    this.clienteId,
    this.clienteNome,
    this.statusAssociadoId,
    this.statusAssociadoNome,
    this.statusAssociadoCor,
  });
}
