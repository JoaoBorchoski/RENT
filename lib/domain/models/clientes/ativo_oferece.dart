import 'package:flutter/cupertino.dart';

class AtivoOferece {
  String? id;
  String? ativoId;
  String? ativoNome;
  List<Map<String, dynamic>>? topico;

  AtivoOferece({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.topico,
  });

  factory AtivoOferece.fromJson(Map<String, dynamic> json) {
    List<dynamic> topicosData = json['topicos'];
    List<Map<String, dynamic>> topicosList = topicosData.map((e) {
      return {"topico": e['topico'], "icone": e['icone']};
    }).toList();

    return AtivoOferece(
      id: json['id'],
      ativoId: json['ativoId'],
      ativoNome: json['ativoNome'],
      topico: topicosList,
    );
  }
}

class AtivoOfereceController {
  TextEditingController? id;
  TextEditingController? ativoId;
  TextEditingController? ativoNome;

  AtivoOfereceController({
    this.id,
    this.ativoId,
    this.ativoNome,
  });
}
