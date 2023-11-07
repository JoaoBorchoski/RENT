import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/cliente_preferencias.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';

class ClientePreferenciasRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<ClientePreferencias> _clientesPreferencias;

  List<ClientePreferencias> get items => [..._clientesPreferencias];

  int get itemsCount {
    return _clientesPreferencias.length;
  }

  ClientePreferenciasRepository([
    this._token = '',
    this._clientesPreferencias = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/clientes-preferencias';

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

  Future<List<ClientePreferencias>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _clientesPreferencias.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/clientes-preferencias/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<ClientePreferencias> clientePreferenciasList = dataList
        .map(
          (e) => ClientePreferencias(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            limiteLocarAntecedenciaGeral: e['limiteLocarAntecedenciaGeral'],
            valorConvidadoNaoSocio: e['valorConvidadoNaoSocio'],
            horaInicio: e['horaInicio'],
            horaFim: e['horaFim'],
          ),
        )
        .toList();

    _clientesPreferencias.addAll(clientePreferenciasList);

    notifyListeners();

    return clientePreferenciasList;
  }

  // get

  Future<ClientePreferencias> get(String id) async {
    ClientePreferencias clientePreferencias = ClientePreferencias();

    final url = '${AppConstants.apiUrl}/clientes-preferencias/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      clientePreferencias.id = data['id'];
      clientePreferencias.clienteId = data['clienteId'];
      clientePreferencias.clienteNome = data['nome'];
      clientePreferencias.clienteCnpj = data['cnpj'];
      clientePreferencias.limiteLocarAntecedenciaGeral = data['limiteAntecedenciaLocarGeral'];
      clientePreferencias.valorConvidadoNaoSocio = double.parse(data['valorConvidadoNaoSocio']);
      clientePreferencias.horaInicio = data['horaInicio'];
      clientePreferencias.horaFim = data['horaFim'];
    }

    return clientePreferencias;
  }

  // getbyclienteid

  Future<ClientePreferencias> getByClienteId(String? clienteId) async {
    ClientePreferencias clientePreferencias = ClientePreferencias();

    final url = clienteId != ""
        ? '${AppConstants.apiUrl}/clientes-preferencias/by-clienteid?id=$clienteId'
        : '${AppConstants.apiUrl}/clientes-preferencias/by-clienteid';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      clientePreferencias.id = data['id'];
      clientePreferencias.clienteId = data['clienteId'];
      clientePreferencias.clienteNome = data['nome'];
      clientePreferencias.clienteCnpj = data['cnpj'];
      clientePreferencias.limiteLocarAntecedenciaGeral = data['limiteAntecedenciaLocarGeral'];
      clientePreferencias.valorConvidadoNaoSocio = double.parse(data['valorConvidadoNaoSocio']);
      clientePreferencias.horaInicio = data['horaInicio'];
      clientePreferencias.horaFim = data['horaFim'];
    }

    return clientePreferencias;
  }

  // getbyemail

  Future<ClientePreferencias> getByEmail(String? email) async {
    ClientePreferencias clientePreferencias = ClientePreferencias();

    final url = '${AppConstants.apiUrl}/clientes-preferencias/by-email?email=$email';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      clientePreferencias.id = data['id'];
      clientePreferencias.clienteId = data['clienteId'];
      clientePreferencias.clienteNome = data['nome'];
      clientePreferencias.clienteCnpj = data['cnpj'];
      clientePreferencias.limiteLocarAntecedenciaGeral = data['limiteAntecedenciaLocarGeral'];
      clientePreferencias.valorConvidadoNaoSocio = double.parse(data['valorConvidadoNaoSocio']);
      clientePreferencias.horaInicio = data['horaInicio'];
      clientePreferencias.horaFim = data['horaFim'];
    }

    return clientePreferencias;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/clientes-preferencias/select?filter=$search';

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

  Future<String> delete(ClientePreferencias clientePreferencias) async {
    int index = _clientesPreferencias.indexWhere((p) => p.id == clientePreferencias.id);

    if (index >= 0) {
      final clientePreferencias = _clientesPreferencias[index];
      _clientesPreferencias.remove(clientePreferencias);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/clientes-preferencias/${clientePreferencias.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _clientesPreferencias.insert(index, clientePreferencias);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
