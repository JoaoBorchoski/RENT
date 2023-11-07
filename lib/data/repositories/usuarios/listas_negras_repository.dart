import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/usuarios/listas_negras.dart';

class ListasNegrasRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<ListasNegras> _listaNegra;

  List<ListasNegras> get items => [..._listaNegra];

  int get itemsCount {
    return _listaNegra.length;
  }

  ListasNegrasRepository([
    this._token = '',
    this._listaNegra = const [],
  ]);

  // Save

  Future<bool> save(Map<String, dynamic> data,) async {
    const url = '${AppConstants.apiUrl}/lista-negra';

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

  // list

  Future<List<ListasNegras>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _listaNegra.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/lista-negra/list';

    final response = await dio.post(
      url,
      data:data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<ListasNegras> listasNegrasList = dataList
        .map((e) => ListasNegras(
            id: e['id'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            motivo: e['motivo'],
          ),
        )
        .toList();

    _listaNegra.addAll(listasNegrasList);

    notifyListeners();

    return listasNegrasList;
  }

  // get

  Future<ListasNegras> get(String id) async {
    ListasNegras listasNegras = ListasNegras();

    final url = '${AppConstants.apiUrl}/lista-negra/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      listasNegras.id = data['id'];
      listasNegras.usuarioId = data['usuarioId'];
      listasNegras.usuariosNome = data['usuariosNome'];
      listasNegras.clienteId = data['clienteId'];
      listasNegras.clienteNome = data['clienteNome'];
      listasNegras.motivo = data['motivo'];
    }

    return listasNegras;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/lista-negra/select?filter=$search';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List<SuggestionModelSelect> suggestions = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      suggestions = List<SuggestionModelSelect>.from(data['items'].map((model) => SuggestionModelSelect.fromJson(model)),
      );
    }

    return Future.value(suggestions.map((e) => {'value': e.value, 'label': e.label}).toList(),
    );
  }

  // delete

  Future<String> delete(ListasNegras listasNegras) async {
    int index = _listaNegra.indexWhere((p) => p.id == listasNegras.id);

    if (index >= 0) {
      final listasNegras = _listaNegra[index];
      _listaNegra.remove(listasNegras);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/lista-negra/${listasNegras.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _listaNegra.insert(index, listasNegras);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
