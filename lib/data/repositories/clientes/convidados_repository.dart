import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';

class ConvidadosRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Convidados> _convidado;

  List<Convidados> get items => [..._convidado];

  int get itemsCount {
    return _convidado.length;
  }

  ConvidadosRepository([
    this._token = '',
    this._convidado = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/convidado';

    if (data['id'] == '') {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    }

    final response = await dio.put(
      '$url/${data['id']!}',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // updatePresenca

  Future<bool> updatePresenca(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/convidado';

    final response = await dio.patch(
      '$url/presente/${data['id']!}',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // list

  Future<List<Convidados>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _convidado.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/convidado/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Convidados> convidadosList = dataList
        .map(
          (e) => Convidados(
            id: e['id'],
            locacaoId: e['locacaoId'],
            locacoesDescricao: e['locacoesDescricao'],
            email: e['email'],
            nome: e['nome'],
            idade: int.parse(e['idade']),
            telefone: e['telefone'],
            codSocio: e['codigoSocio'],
            isAssociado: e['isAssociado'],
            isPresente: e['isPresente'],
            isExtra: e['isExtra'],
          ),
        )
        .toList();

    _convidado.addAll(convidadosList);

    notifyListeners();

    return convidadosList;
  }

  // get

  Future<Convidados> get(String id) async {
    Convidados convidados = Convidados();

    final url = '${AppConstants.apiUrl}/convidado/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      convidados.id = data['id'];
      convidados.locacaoId = data['locacaoId'];
      convidados.locacoesDescricao = data['locacoesDescricao'];
      convidados.email = data['email'];
      convidados.idade = int.tryParse(data['idade']);
      convidados.isAssociado = data['isAssociado'];
      convidados.telefone = data['telefone'];
      convidados.codSocio = data['codigoSocio'];
      convidados.nome = data['nome'];
      convidados.isPresente = data['isPresente'];
      convidados.isExtra = data['isExtra'];
    }

    return convidados;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/convidado/select?filter=$search';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List<SuggestionModelSelect> suggestions = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      suggestions = List<SuggestionModelSelect>.from(
        data['items'].map((model) => SuggestionModelSelect.fromJson(model)),
      );
    }

    return Future.value(
      suggestions.map((e) => {'value': e.value, 'label': e.label}).toList(),
    );
  }

  // delete

  Future<String> delete(Convidados convidados) async {
    int index = _convidado.indexWhere((p) => p.id == convidados.id);

    if (index >= 0) {
      final convidados = _convidado[index];
      _convidado.remove(convidados);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/convidado/${convidados.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _convidado.insert(index, convidados);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
