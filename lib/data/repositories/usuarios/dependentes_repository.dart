import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/usuarios/dependentes.dart';

class DependentesRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Dependentes> _dependente;

  List<Dependentes> get items => [..._dependente];

  int get itemsCount {
    return _dependente.length;
  }

  DependentesRepository([
    this._token = '',
    this._dependente = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/dependente';

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

  Future<List<Dependentes>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _dependente.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/dependente/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Dependentes> dependentesList = dataList
        .map(
          (e) => Dependentes(
            id: e['id'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
            nome: e['nome'],
            email: e['email'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _dependente.addAll(dependentesList);

    notifyListeners();

    return dependentesList;
  }

  // listByCliente

  Future<List<Dependentes>> listByCliente(
    String clienteId,
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _dependente.clear();
    final Map<String, dynamic> data = {
      'clienteId': clienteId,
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/dependente/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Dependentes> dependentesList = dataList
        .map(
          (e) => Dependentes(
            id: e['id'],
            nome: e['dependenteNome'],
            email: e['dependenteEmail'],
            codigoSocio: e['dependenteCodigoSocio'],
            telefone: e['dependenteTelefone'],
            cpf: e['dependenteCpf'],
            idade: e['dependenteIdade'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _dependente.addAll(dependentesList);

    notifyListeners();

    return dependentesList;
  }

  // get

  Future<Dependentes> get(String id) async {
    Dependentes dependentes = Dependentes();

    final url = '${AppConstants.apiUrl}/dependente/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      dependentes.id = data['id'];
      dependentes.usuarioId = data['usuarioId'];
      dependentes.usuariosNome = data['usuariosNome'];
      dependentes.nome = data['nome'];
      dependentes.email = data['email'];
      dependentes.desabilitado = data['desabilitado'];
    }

    return dependentes;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/dependente/select?filter=$search';

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

  Future<String> delete(Dependentes dependentes) async {
    int index = _dependente.indexWhere((p) => p.id == dependentes.id);

    if (index >= 0) {
      final dependentes = _dependente[index];
      _dependente.remove(dependentes);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/dependente/${dependentes.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _dependente.insert(index, dependentes);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
