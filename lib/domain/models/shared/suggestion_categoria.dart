// ignore_for_file: file_names

import 'package:locacao/domain/models/clientes/categorias.dart';

class SuggestionModelCategoria {
  String value;
  String label;
  String nome;
  String icone;

  SuggestionModelCategoria({
    required this.value,
    required this.label,
    required this.nome,
    required this.icone,
  });

  factory SuggestionModelCategoria.fromJson(Categorias json) {
    return SuggestionModelCategoria(
      value: json.clienteId ?? '',
      label: json.nome ?? '',
      nome: json.nome ?? '',
      icone: json.icone ?? '',
    );
  }
}
