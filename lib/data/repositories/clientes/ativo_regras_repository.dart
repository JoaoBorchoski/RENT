import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_regras.dart';
import 'package:locacao/shared/config/app_constants.dart';

class AtivoRegraRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<AtivoRegra> _ativoRegra;

  List<AtivoRegra> get items => [..._ativoRegra];

  int get itemsCount {
    return _ativoRegra.length;
  }

  AtivoRegraRepository([
    this._token = '',
    this._ativoRegra = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
    bool isEditing,
  ) async {
    const url = '${AppConstants.apiUrl}/ativo-regras';

    if (!isEditing) {
      final response = await dio.post(
        "$url/create",
        data: data,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    }

    final response = await dio.put(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // list

  Future<List<AtivoRegra>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _ativoRegra.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/ativo-regras/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoRegra> ativoRegraList = dataList
        .map(
          (e) => AtivoRegra(
            id: e['id'],
            ativoId: e['ativoId'],
            ativoNome: e['ativoNome'],
            topico: e['topico'],
          ),
        )
        .toList();

    _ativoRegra.addAll(ativoRegraList);

    notifyListeners();

    return ativoRegraList;
  }

  // get

  Future<AtivoRegra> get(String id) async {
    AtivoRegra ativoRegra = AtivoRegra();

    final url = '${AppConstants.apiUrl}/ativo-regras/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      ativoRegra.id = data['id'];
      ativoRegra.ativoId = data['ativoId'];
      ativoRegra.ativoNome = data['ativoNome'];
      ativoRegra.topico = data['topico'];
    }

    return ativoRegra;
  }

  // get by ativoId

  Future<List<AtivoRegra>> getByAtivoId(String ativoId) async {
    final url = '${AppConstants.apiUrl}/ativo-regras/by-ativo/$ativoId';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data;

    List<AtivoRegra> ativoRegraList = dataList.map((e) => AtivoRegra.fromJson(e)).toList();

    return ativoRegraList;
  }

  // delete

  Future<String> delete(AtivoRegra ativoRegra) async {
    int index = _ativoRegra.indexWhere((p) => p.id == ativoRegra.id);

    if (index >= 0) {
      final ativoRegra = _ativoRegra[index];
      _ativoRegra.remove(ativoRegra);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/ativo-regras/${ativoRegra.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _ativoRegra.insert(index, ativoRegra);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }

  // delete by ativoId

  Future<String> deleteByAtivoId(AtivoRegra ativoRegra) async {
    final List<AtivoRegra> itemsToDelete = _ativoRegra.where((p) => p.ativoId == ativoRegra.ativoId).toList();

    if (itemsToDelete.isEmpty) {
      return 'Itens não encontrados';
    }

    final List<int> indices = [];
    for (var itemToDelete in itemsToDelete) {
      final index = _ativoRegra.indexOf(itemToDelete);
      if (index >= 0) {
        indices.add(index);
        _ativoRegra.removeAt(index);
      }
    }
    notifyListeners();

    final url = '${AppConstants.apiUrl}/ativo-regras/ativo/${ativoRegra.ativoId}';

    final response = await dio.delete(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == null) {
      return 'Erro desconhecido!';
    }

    if (response.statusCode! >= 400) {
      return response.data['message'];
    }

    return 'Sucesso';
  }
}
