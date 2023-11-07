import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/status_associados.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';

class StatusAssociadosRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<StatusAssociados> _statusAssociado;

  List<StatusAssociados> get items => [..._statusAssociado];

  int get itemsCount {
    return _statusAssociado.length;
  }

  StatusAssociadosRepository([
    this._token = '',
    this._statusAssociado = const [],
  ]);

  // Save

  Future<int> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/status-associado';

    if (data['id'] == '') {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      return response.statusCode!;
    }

    final response = await dio.put(
      '$url/${data['id']!}',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    return response.statusCode!;
  }

  // list

  Future<List<StatusAssociados>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _statusAssociado.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/status-associado/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<StatusAssociados> associadosList = dataList
        .map(
          (e) => StatusAssociados(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            cor: e['cor'],
            nome: e['nome'],
          ),
        )
        .toList();

    _statusAssociado.addAll(associadosList);

    notifyListeners();

    return associadosList;
  }

  // listAllAssociadosCliente

  Future<List<StatusAssociados>> listAllAssociadosCliente(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _statusAssociado.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/status-associado/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<StatusAssociados> associadosList = dataList
        .map(
          (e) => StatusAssociados(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            nome: e['nome'],
            cor: e['cor'],
          ),
        )
        .toList();

    _statusAssociado.addAll(associadosList);

    notifyListeners();

    return associadosList;
  }

  // get

  Future<StatusAssociados> get(String id) async {
    StatusAssociados statusAssociados = StatusAssociados();

    final url = '${AppConstants.apiUrl}/status-associado/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      statusAssociados.id = data['id'];
      statusAssociados.clienteId = data['clienteId'];
      statusAssociados.clienteNome = data['clienteNome'];
      statusAssociados.nome = data['nomeStatusAssociado'];
      statusAssociados.cor = data['corStatusAssociado'];
    }

    return statusAssociados;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/status-associado/select?filter=$search';

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

  Future<String> delete(StatusAssociados statusAssociados) async {
    int index = _statusAssociado.indexWhere((p) => p.id == statusAssociados.id);

    if (index >= 0) {
      final statusAssociados = _statusAssociado[index];
      _statusAssociado.remove(statusAssociados);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/status-associado/${statusAssociados.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _statusAssociado.insert(index, statusAssociados);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
