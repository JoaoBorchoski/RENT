import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/meios_pagamento_excecao.dart';

class MeiosPagamentoExcecaoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<MeiosPagamentoExcecao> _meioPagamentoExcecao;

  List<MeiosPagamentoExcecao> get items => [..._meioPagamentoExcecao];

  int get itemsCount {
    return _meioPagamentoExcecao.length;
  }

  MeiosPagamentoExcecaoRepository([
    this._token = '',
    this._meioPagamentoExcecao = const [],
  ]);

  // Save

  Future<bool> save(Map<String, dynamic> data,) async {
    const url = '${AppConstants.apiUrl}/meio-pagamento-excecao';

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

  Future<List<MeiosPagamentoExcecao>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _meioPagamentoExcecao.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/meio-pagamento-excecao/list';

    final response = await dio.post(
      url,
      data:data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<MeiosPagamentoExcecao> meiosPagamentoExcecaoList = dataList
        .map((e) => MeiosPagamentoExcecao(
            id: e['id'],
            ativoId: e['ativoId'],
            ativoNome: e['ativoNome'],
            meioPagamentoId: e['meioPagamentoId'],
            meioPagamentoNome: e['meioPagamentoNome'],
          ),
        )
        .toList();

    _meioPagamentoExcecao.addAll(meiosPagamentoExcecaoList);

    notifyListeners();

    return meiosPagamentoExcecaoList;
  }

  // get

  Future<MeiosPagamentoExcecao> get(String id) async {
    MeiosPagamentoExcecao meiosPagamentoExcecao = MeiosPagamentoExcecao();

    final url = '${AppConstants.apiUrl}/meio-pagamento-excecao/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      meiosPagamentoExcecao.id = data['id'];
      meiosPagamentoExcecao.ativoId = data['ativoId'];
      meiosPagamentoExcecao.ativoNome = data['ativoNome'];
      meiosPagamentoExcecao.meioPagamentoId = data['meioPagamentoId'];
      meiosPagamentoExcecao.meioPagamentoNome = data['meioPagamentoNome'];
    }

    return meiosPagamentoExcecao;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/meio-pagamento-excecao/select?filter=$search';

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

  Future<String> delete(MeiosPagamentoExcecao meiosPagamentoExcecao) async {
    int index = _meioPagamentoExcecao.indexWhere((p) => p.id == meiosPagamentoExcecao.id);

    if (index >= 0) {
      final meiosPagamentoExcecao = _meioPagamentoExcecao[index];
      _meioPagamentoExcecao.remove(meiosPagamentoExcecao);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/meio-pagamento-excecao/${meiosPagamentoExcecao.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _meioPagamentoExcecao.insert(index, meiosPagamentoExcecao);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
