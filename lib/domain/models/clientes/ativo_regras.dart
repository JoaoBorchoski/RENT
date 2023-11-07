import 'package:flutter/cupertino.dart';

class AtivoRegra {
  String? id;
  String? ativoId;
  String? ativoNome;
  List<Map<String, dynamic>>? topico;

  AtivoRegra({
    this.id,
    this.ativoId,
    this.ativoNome,
    this.topico,
  });

  factory AtivoRegra.fromJson(Map<String, dynamic> json) {
    List<dynamic> topicosData = json['topicos'];
    List<Map<String, dynamic>> topicosList = topicosData.map((e) {
      return {"topico": e['topico'], "icone": e['icone']};
    }).toList();

    return AtivoRegra(
      id: json['id'],
      ativoId: json['ativoId'],
      ativoNome: json['ativoNome'],
      topico: topicosList,
    );
  }
}

class AtivoRegraController {
  TextEditingController? id;
  TextEditingController? ativoId;
  TextEditingController? ativoNome;

  AtivoRegraController({
    this.id,
    this.ativoId,
    this.ativoNome,
  });
}
