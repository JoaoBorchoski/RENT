import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/comum/meio_pagamento.dart';

class MeioPagamentoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<MeioPagamento> _meiosPagamento;

  List<MeioPagamento> get items => [..._meiosPagamento];

  int get itemsCount {
    return _meiosPagamento.length;
  }

  MeioPagamentoRepository([
    this._token = '',
    this._meiosPagamento = const [],
  ]);

  // Save

  Future<bool> save(Map<String, dynamic> data,) async {
    const url = '${AppConstants.apiUrl}/meios-pagamento';

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

  Future<List<MeioPagamento>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _meiosPagamento.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/meios-pagamento/list';

    final response = await dio.post(
      url,
      data:data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<MeioPagamento> meioPagamentoList = dataList
        .map((e) => MeioPagamento(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _meiosPagamento.addAll(meioPagamentoList);

    notifyListeners();

    return meioPagamentoList;
  }

  // get

  Future<MeioPagamento> get(String id) async {
    MeioPagamento meioPagamento = MeioPagamento();

    final url = '${AppConstants.apiUrl}/meios-pagamento/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      meioPagamento.id = data['id'];
      meioPagamento.nome = data['nome'];
      meioPagamento.descricao = data['descricao'];
      meioPagamento.taxa = data['taxa'];
      meioPagamento.desabilitado = data['desabilitado'];
    }

    return meioPagamento;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/meios-pagamento/select?filter=$search';

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

  Future<String> delete(MeioPagamento meioPagamento) async {
    int index = _meiosPagamento.indexWhere((p) => p.id == meioPagamento.id);

    if (index >= 0) {
      final meioPagamento = _meiosPagamento[index];
      _meiosPagamento.remove(meioPagamento);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/meios-pagamento/${meioPagamento.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _meiosPagamento.insert(index, meioPagamento);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
