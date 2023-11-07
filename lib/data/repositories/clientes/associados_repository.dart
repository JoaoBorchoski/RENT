import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/domain/models/usuarios/dependentes.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/associados.dart';

class AssociadosRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Associados> _associado;

  List<Associados> get items => [..._associado];

  int get itemsCount {
    return _associado.length;
  }

  AssociadosRepository([
    this._token = '',
    this._associado = const [],
  ]);

  // Save

  Future<int> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/associado';

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

  // import associados

  Future<dynamic> importAssociadosFile(File? csvFile) async {
    const url = '${AppConstants.apiUrl}/associado/import';

    if (csvFile != null) {
      final data = FormData.fromMap({'file': await MultipartFile.fromFile(csvFile.path)});

      final response = await dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
        data: data,
      );

      if (response.statusCode == 201) {
        return response.statusCode;
      }
    }
    return null;
  }

  // list

  Future<List<Associados>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _associado.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/associado/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Associados> associadosList = dataList
        .map(
          (e) => Associados(
            id: e['id'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            codigoSocio: e['codigoSocio'],
            statusAssociadoId: e['statusAssociadoId'],
            statusAssociadoNome: e['statusAssociadoNome'],
            statusAssociadoCor: e['statusAssociadoCor'],
          ),
        )
        .toList();

    _associado.addAll(associadosList);

    notifyListeners();

    return associadosList;
  }

  // listAllAssociadosCliente

  Future<List<Associados>> listAllAssociadosCliente(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _associado.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/associado/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Associados> associadosList = dataList
        .map(
          (e) => Associados(
            id: e['id'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
            usuarioEmail: e['usuarioEmail'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            codigoSocio: e['codigoSocio'],
            statusAssociadoId: e['statusAssociadoId'],
            statusAssociadoNome: e['statusAssociadoNome'],
            statusAssociadoCor: e['statusAssociadoCor'],
          ),
        )
        .toList();

    _associado.addAll(associadosList);

    notifyListeners();

    return associadosList;
  }

  // listAllClientesAssociado

  Future<List<Associados>> listAllClientesAssociado(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _associado.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/associado/list-associado';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Associados> associadosList = dataList
        .map(
          (e) => Associados(
            id: e['id'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            codigoSocio: e['codigoSocio'],
            statusAssociadoId: e['statusAssociadoId'],
            statusAssociadoNome: e['statusAssociadoNome'],
            statusAssociadoCor: e['statusAssociadoCor'],
          ),
        )
        .toList();

    _associado.addAll(associadosList);

    notifyListeners();

    return associadosList;
  }

  // get

  Future<Associados> get(String id) async {
    Associados associados = Associados();

    final url = '${AppConstants.apiUrl}/associado/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data[0];
      associados.id = data['id'];
      associados.usuarioId = data['usuarioId'];
      associados.usuariosNome = data['usuariosNome'];
      associados.usuarioEmail = data['usuarioEmail'];
      associados.usuarioCpf = data['usuarioCpf'];
      associados.clienteId = data['clienteId'];
      associados.clienteNome = data['clienteNome'];
      associados.codigoSocio = data['codigoSocio'];
      associados.statusAssociadoId = data['statusAssociadoId'];
      associados.statusAssociadoNome = data['statusAssociadoNome'];
      associados.statusAssociadoCor = data['statusAssociadoCor'];
      associados.dependentes = data['dependentes'] != null
          ? List<Dependentes>.from(
              data['dependentes'].map(
                (i) => Dependentes(
                  nome: i['dependenteNome'],
                  email: i['dependenteEmail'],
                  codigoSocio: i['dependenteCodigoSocio'],
                  telefone: i['dependenteTelefone'],
                  idade: i['dependenteIdade'],
                  cpf: i['dependenteCpf'],
                  desabilitado: false,
                ),
              ),
            )
          : [];
    }

    return associados;
  }

  // verifica associado by email
  Future<bool> verificaAssociadoByEmail(String clienteId, String usuarioEmail) async {
    final url = '${AppConstants.apiUrl}/associado/verifica?clienteId=$clienteId&usuarioEmail=$usuarioEmail';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // verifica associado by cpf
  Future<bool> verificaAssociadoByCpf(String clienteId, String usuarioCpf) async {
    final url = '${AppConstants.apiUrl}/associado/verifica-cpf?clienteId=$clienteId&usuarioCpf=$usuarioCpf';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // verifica associado by codigoSocio
  Future<bool> verificaAssociadoByCodigoSocio(String clienteId, String codigoSocio) async {
    final url = '${AppConstants.apiUrl}/associado/verifica-codigo-socio?clienteId=$clienteId&codigoSocio=$codigoSocio';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/associado/select?filter=$search';

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

  Future<String> delete(Associados associados) async {
    int index = _associado.indexWhere((p) => p.id == associados.id);

    if (index >= 0) {
      final associados = _associado[index];
      _associado.remove(associados);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/associado/${associados.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _associado.insert(index, associados);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
