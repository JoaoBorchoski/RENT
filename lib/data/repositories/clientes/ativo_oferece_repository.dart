import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_oferece.dart';
import 'package:locacao/shared/config/app_constants.dart';

class AtivoOfereceRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<AtivoOferece> _ativoOferece;

  List<AtivoOferece> get items => [..._ativoOferece];

  int get itemsCount {
    return _ativoOferece.length;
  }

  AtivoOfereceRepository([
    this._token = '',
    this._ativoOferece = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
    bool isEditing,
  ) async {
    const url = '${AppConstants.apiUrl}/ativo-oferece';

    if (!isEditing) {
      final response = await dio.post(
        '$url/create',
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

  Future<List<AtivoOferece>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _ativoOferece.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/ativo-oferece/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoOferece> ativoOfereceList = dataList
        .map(
          (e) => AtivoOferece(
            id: e['id'],
            ativoId: e['ativoId'],
            ativoNome: e['ativoNome'],
            topico: e['topico'],
          ),
        )
        .toList();

    _ativoOferece.addAll(ativoOfereceList);

    notifyListeners();

    return ativoOfereceList;
  }

  // get

  Future<AtivoOferece> get(String id) async {
    AtivoOferece ativoOferece = AtivoOferece();

    final url = '${AppConstants.apiUrl}/ativo-oferece/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      ativoOferece.id = data['id'];
      ativoOferece.ativoId = data['ativoId'];
      ativoOferece.ativoNome = data['ativoNome'];
      ativoOferece.topico = data['topico'];
    }

    return ativoOferece;
  }

  // get by ativoId

  Future<List<AtivoOferece>> getByAtivoId(String ativoId) async {
    final url = '${AppConstants.apiUrl}/ativo-oferece/by-ativo/$ativoId';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data;

    List<AtivoOferece> ativoOfereceList = dataList.map((e) => AtivoOferece.fromJson(e)).toList();

    return ativoOfereceList;
  }

  // delete

  Future<String> delete(AtivoOferece ativoOferece) async {
    int index = _ativoOferece.indexWhere((p) => p.id == ativoOferece.id);

    if (index >= 0) {
      final ativoOferece = _ativoOferece[index];
      _ativoOferece.remove(ativoOferece);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/ativo-oferece/${ativoOferece.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _ativoOferece.insert(index, ativoOferece);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }

  // delete by ativoId

  Future<String> deleteByAtivoId(AtivoOferece ativoOferece) async {
    final List<AtivoOferece> itemsToDelete = _ativoOferece.where((p) => p.ativoId == ativoOferece.ativoId).toList();

    if (itemsToDelete.isEmpty) {
      return 'Itens não encontrados';
    }

    final List<int> indices = [];
    for (var itemToDelete in itemsToDelete) {
      final index = _ativoOferece.indexOf(itemToDelete);
      if (index >= 0) {
        indices.add(index);
        _ativoOferece.removeAt(index);
      }
    }
    notifyListeners();

    final url = '${AppConstants.apiUrl}/ativo-oferece/ativo/${ativoOferece.ativoId}';

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
