import 'package:flutter/cupertino.dart';

class AtivoImagens {
  String? id;
  String? ativoId;
  String? ativoNome;
  String? imagemNome;

  AtivoImagens({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.imagemNome,
  });
}

class AtivoImagensController {
  TextEditingController? id;
  TextEditingController? ativoId;
  TextEditingController? ativoNome;
  TextEditingController? imagemNome;

  AtivoImagensController({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.imagemNome,
  });
}
