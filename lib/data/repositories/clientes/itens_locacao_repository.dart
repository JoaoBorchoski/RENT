import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/itens_locacao.dart';

class ItensLocacaoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<ItensLocacao> _itemLocacao;

  List<ItensLocacao> get items => [..._itemLocacao];

  int get itemsCount {
    return _itemLocacao.length;
  }

  ItensLocacaoRepository([
    this._token = '',
    this._itemLocacao = const [],
  ]);

  // Save

  Future<bool> save(Map<String, dynamic> data,) async {
    const url = '${AppConstants.apiUrl}/item-locacao';

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

  Future<List<ItensLocacao>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _itemLocacao.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/item-locacao/list';

    final response = await dio.post(
      url,
      data:data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<ItensLocacao> itensLocacaoList = dataList
        .map((e) => ItensLocacao(
            id: e['id'],
            ativoId: e['ativoId'],
            ativoNome: e['ativoNome'],
            locacaoId: e['locacaoId'],
            locacoesDescricao: e['locacoesDescricao'],
          ),
        )
        .toList();

    _itemLocacao.addAll(itensLocacaoList);

    notifyListeners();

    return itensLocacaoList;
  }

  // get

  Future<ItensLocacao> get(String id) async {
    ItensLocacao itensLocacao = ItensLocacao();

    final url = '${AppConstants.apiUrl}/item-locacao/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      itensLocacao.id = data['id'];
      itensLocacao.ativoId = data['ativoId'];
      itensLocacao.ativoNome = data['ativoNome'];
      itensLocacao.locacaoId = data['locacaoId'];
      itensLocacao.locacoesDescricao = data['locacoesDescricao'];
    }

    return itensLocacao;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/item-locacao/select?filter=$search';

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

  Future<String> delete(ItensLocacao itensLocacao) async {
    int index = _itemLocacao.indexWhere((p) => p.id == itensLocacao.id);

    if (index >= 0) {
      final itensLocacao = _itemLocacao[index];
      _itemLocacao.remove(itensLocacao);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/item-locacao/${itensLocacao.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _itemLocacao.insert(index, itensLocacao);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
