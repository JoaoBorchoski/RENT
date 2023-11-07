import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/categorias.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';

class CategoriasRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Categorias> _categoria;

  List<Categorias> get items => [..._categoria];

  int get itemsCount {
    return _categoria.length;
  }

  CategoriasRepository([
    this._token = '',
    this._categoria = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/categoria';

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

  Future<List<Categorias>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _categoria.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/categoria/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Categorias> categoriasList = dataList
        .map(
          (e) => Categorias(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            nome: e['nome'],
            icone: e['icone'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _categoria.addAll(categoriasList);

    notifyListeners();

    return categoriasList;
  }

  // list

  Future<List<Categorias>> listByClienteId(
    String? clienteId,
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _categoria.clear();
    final Map<String, dynamic> data = {
      'clienteId': clienteId,
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/categoria/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Categorias> categoriasList = dataList
        .map(
          (e) => Categorias(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            nome: e['nome'],
            icone: e['icone'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _categoria.addAll(categoriasList);

    notifyListeners();

    return categoriasList;
  }

  // get

  Future<Categorias> get(String id) async {
    Categorias categorias = Categorias();

    final url = '${AppConstants.apiUrl}/categoria/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      categorias.id = data['id'];
      categorias.clienteId = data['clienteId'];
      categorias.nome = data['nome'];
      categorias.clienteNome = data['clienteNome'];
      categorias.icone = data['icone'];
      categorias.desabilitado = data['desabilitado'];
    }

    return categorias;
  }

  // select

  Future<List<Map<String, String>>> select(String search, String clienteId) async {
    final url = '${AppConstants.apiUrl}/categoria/select?filter=$search&clienteId=$clienteId';

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

  Future<String> delete(Categorias categorias) async {
    int index = _categoria.indexWhere((p) => p.id == categorias.id);

    if (index >= 0) {
      final categorias = _categoria[index];
      _categoria.remove(categorias);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/categoria/${categorias.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _categoria.insert(index, categorias);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
