import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/status_ativo.dart';

class StatusAtivoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<StatusAtivo> _statusAtivos;

  List<StatusAtivo> get items => [..._statusAtivos];

  int get itemsCount {
    return _statusAtivos.length;
  }

  StatusAtivoRepository([
    this._token = '',
    this._statusAtivos = const [],
  ]);

  // Save

  Future<String> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/status-ativos';

    if (data['id'] == '') {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );
      if (response.statusCode == 200) {
        return response.data["data"]["id"];
      }

      return '';
    }

    final response = await dio.put(
      '$url/${data['id']!}',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return response.data["data"]["id"];
    }

    return '';
  }

  // list

  Future<List<StatusAtivo>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _statusAtivos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/status-ativos/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<StatusAtivo> statusAtivoList = dataList
        .map(
          (e) => StatusAtivo(
            id: e['id'],
            nome: e['nome'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _statusAtivos.addAll(statusAtivoList);

    notifyListeners();

    return statusAtivoList;
  }

  // listByClienteId

  Future<List<StatusAtivo>> listByClienteId(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _statusAtivos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/status-ativos/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<StatusAtivo> statusAtivoList = dataList
        .map(
          (e) => StatusAtivo(
            id: e['id'],
            nome: e['nome'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _statusAtivos.addAll(statusAtivoList);

    notifyListeners();

    return statusAtivoList;
  }

  // get

  Future<StatusAtivo> get(String id) async {
    StatusAtivo statusativo = StatusAtivo();

    final url = '${AppConstants.apiUrl}/status-ativos/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      statusativo.id = data['id'];
      statusativo.nome = data['nome'];
      statusativo.descricao = data['descricao'];
      statusativo.desabilitado = data['desabilitado'];
    }

    return statusativo;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/status-ativos/select?filter=$search';

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

  Future<String> delete(StatusAtivo statusAtivo) async {
    int index = _statusAtivos.indexWhere((p) => p.id == statusAtivo.id);

    if (index >= 0) {
      final statusAtivo = _statusAtivos[index];
      _statusAtivos.remove(statusAtivo);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/status-ativos/${statusAtivo.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _statusAtivos.insert(index, statusAtivo);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
