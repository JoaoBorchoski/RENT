import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/usuarios/usuarios.dart';

class UsuariosRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Usuarios> _usuario;

  List<Usuarios> get items => [..._usuario];

  int get itemsCount {
    return _usuario.length;
  }

  UsuariosRepository([
    this._token = '',
    this._usuario = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/usuario';

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

  Future<List<Usuarios>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _usuario.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/usuario/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Usuarios> usuariosList = dataList
        .map(
          (e) => Usuarios(
            id: e['id'],
            nome: e['nome'],
            email: e['email'],
            cpf: e['cpf'],
          ),
        )
        .toList();

    _usuario.addAll(usuariosList);

    notifyListeners();

    return usuariosList;
  }

  // get

  Future<Usuarios> get(String id) async {
    Usuarios usuarios = Usuarios();

    final url = '${AppConstants.apiUrl}/usuario/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      usuarios.id = data['id'];
      usuarios.nome = data['nome'];
      usuarios.email = data['email'];
      usuarios.cpf = data['cpf'];
      usuarios.telefone = data['telefone'];
      usuarios.endereco = data['endereco'];
      usuarios.numero = data['numero'];
      usuarios.bairro = data['bairro'];
      usuarios.complemento = data['complemento'];
      usuarios.estadoId = data['estadoId'];
      usuarios.estadoUf = data['estadoUf'];
      usuarios.cidadeId = data['cidadeId'];
      usuarios.cidadeNomeCidade = data['cidadeNomeCidade'];
      usuarios.cep = data['cep'];
      usuarios.desabilitado = data['desabilitado'];
    }

    return usuarios;
  }

  // getbyemail

  Future<Usuarios> getByEmail(String? email) async {
    Usuarios usuarios = Usuarios();

    final url = '${AppConstants.apiUrl}/usuario/by-email?email=$email';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      usuarios.id = data['id'];
      usuarios.nome = data['nome'];
      usuarios.email = data['email'];
      usuarios.cpf = data['cpf'];
      usuarios.telefone = data['telefone'];
      usuarios.endereco = data['endereco'];
      usuarios.numero = data['numero'];
      usuarios.bairro = data['bairro'];
      usuarios.complemento = data['complemento'];
      usuarios.estadoId = data['estadoId'];
      usuarios.estadoUf = data['estadoUf'];
      usuarios.cidadeId = data['cidadeId'];
      usuarios.cidadeNomeCidade = data['cidadeNomeCidade'];
      usuarios.cep = data['cep'];
      usuarios.desabilitado = data['desabilitado'];
    }

    return usuarios;
  }

  // getbyCpf

  Future<Usuarios> getByCpf(String? cpf) async {
    Usuarios usuarios = Usuarios();

    final url = '${AppConstants.apiUrl}/usuario/by-cpf?email=$cpf';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      usuarios.id = data['id'];
      usuarios.nome = data['nome'];
      usuarios.email = data['email'];
      usuarios.cpf = data['cpf'];
      usuarios.telefone = data['telefone'];
      usuarios.endereco = data['endereco'];
      usuarios.numero = data['numero'];
      usuarios.bairro = data['bairro'];
      usuarios.complemento = data['complemento'];
      usuarios.estadoId = data['estadoId'];
      usuarios.estadoUf = data['estadoUf'];
      usuarios.cidadeId = data['cidadeId'];
      usuarios.cidadeNomeCidade = data['cidadeNomeCidade'];
      usuarios.cep = data['cep'];
      usuarios.desabilitado = data['desabilitado'];
    }

    return usuarios;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/usuario/select?filter=$search';

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

  // selectByEmail

  Future<List<Map<String, String>>> selectByEmail(String search) async {
    final url = '${AppConstants.apiUrl}/usuario/select/email?filter=$search';

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

  // selectByCpf

  Future<List<Map<String, String>>> selectByCpf(String cpf) async {
    final url = '${AppConstants.apiUrl}/usuario/select/cpf?filter=$cpf';

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

  Future<String> delete(Usuarios usuarios) async {
    int index = _usuario.indexWhere((p) => p.id == usuarios.id);

    if (index >= 0) {
      final usuarios = _usuario[index];
      _usuario.remove(usuarios);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/usuario/${usuarios.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _usuario.insert(index, usuarios);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
