// ignore_for_file: file_names

import 'package:locacao/domain/models/clientes/ativo.dart';

class SuggestionModelIdentificador {
  String value;
  String label;
  String nome;
  String categoria;

  SuggestionModelIdentificador({
    required this.value,
    required this.label,
    required this.nome,
    required this.categoria,
  });

  factory SuggestionModelIdentificador.fromJson(Ativo json) {
    return SuggestionModelIdentificador(
      value: json.id ?? '',
      label: json.nome ?? '',
      nome: json.nome ?? '',
      categoria: json.categoriasNome ?? '',
    );
  }
}
