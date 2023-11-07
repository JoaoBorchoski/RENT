import 'package:flutter/cupertino.dart';

class UsuariosLocacao {
  String? id;
  String? locacaoId;
  String? locacoesDescricao;
  String? usuarioId;
  String? usuariosNome;

  UsuariosLocacao({
    this.id,
    this.locacaoId,
    this.locacoesDescricao,
    this.usuarioId,
    this.usuariosNome,
  });
}

class UsuariosLocacaoController {
  TextEditingController? id;
  TextEditingController? locacaoId;
  TextEditingController? locacoesDescricao;
  TextEditingController? usuarioId;
  TextEditingController? usuariosNome;

  UsuariosLocacaoController({
    this.id,
    this.locacaoId,
    this.locacoesDescricao,
    this.usuarioId,
    this.usuariosNome,
  });
}
