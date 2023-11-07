import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/meios_pagamento_aceito.dart';

class MeiosPagamentoAceitoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<MeiosPagamentoAceito> _meioPagamentoAceito;

  List<MeiosPagamentoAceito> get items => [..._meioPagamentoAceito];

  int get itemsCount {
    return _meioPagamentoAceito.length;
  }

  MeiosPagamentoAceitoRepository([
    this._token = '',
    this._meioPagamentoAceito = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/meio-pagamento-aceito';

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

  Future<List<MeiosPagamentoAceito>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _meioPagamentoAceito.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/meio-pagamento-aceito/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<MeiosPagamentoAceito> meiosPagamentoAceitoList = dataList
        .map(
          (e) => MeiosPagamentoAceito(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            meioPagamentoId: e['meioPagamentoId'],
            meioPagamentoNome: e['meioPagamentoNome'],
          ),
        )
        .toList();

    _meioPagamentoAceito.addAll(meiosPagamentoAceitoList);

    notifyListeners();

    return meiosPagamentoAceitoList;
  }

  // listByClienteId

  Future<List<MeiosPagamentoAceito>> listByClienteId(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _meioPagamentoAceito.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/meio-pagamento-aceito/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<MeiosPagamentoAceito> meiosPagamentoAceitoList = dataList
        .map(
          (e) => MeiosPagamentoAceito(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            meioPagamentoId: e['meioPagamentoId'],
            meioPagamentoNome: e['meioPagamentoNome'],
            meioPagamentoTaxa: double.parse(e['meioPagamentoTaxa']),
          ),
        )
        .toList();

    _meioPagamentoAceito.addAll(meiosPagamentoAceitoList);

    notifyListeners();

    return meiosPagamentoAceitoList;
  }

  // get

  Future<MeiosPagamentoAceito> get(String id) async {
    MeiosPagamentoAceito meiosPagamentoAceito = MeiosPagamentoAceito();

    final url = '${AppConstants.apiUrl}/meio-pagamento-aceito/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      meiosPagamentoAceito.id = data['id'];
      meiosPagamentoAceito.clienteId = data['clienteId'];
      meiosPagamentoAceito.clienteNome = data['clienteNome'];
      meiosPagamentoAceito.meioPagamentoId = data['meioPagamentoId'];
      meiosPagamentoAceito.meioPagamentoNome = data['meioPagamentoNome'];
    }

    return meiosPagamentoAceito;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/meio-pagamento-aceito/select?filter=$search';

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

  // selectByClienteId

  Future<List<Map<String, String>>> selectByClienteId(String search) async {
    final url = '${AppConstants.apiUrl}/meio-pagamento-aceito/select-cliente?filter=$search';

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

  Future<String> delete(MeiosPagamentoAceito meiosPagamentoAceito) async {
    int index = _meioPagamentoAceito.indexWhere((p) => p.id == meiosPagamentoAceito.id);

    if (index >= 0) {
      final meiosPagamentoAceito = _meioPagamentoAceito[index];
      _meioPagamentoAceito.remove(meiosPagamentoAceito);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/meio-pagamento-aceito/${meiosPagamentoAceito.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _meioPagamentoAceito.insert(index, meiosPagamentoAceito);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
