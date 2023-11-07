import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/config/app_constants.dart';

import '../../../domain/models/common/termo_uso.dart';

class TermoUsoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<TermoUso> _termoUsoAceitos;

  List<TermoUso> get items => [..._termoUsoAceitos];

  int get itemsCount {
    return _termoUsoAceitos.length;
  }

  TermoUsoRepository([
    this._token = '',
    this._termoUsoAceitos = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/termo-uso';

    if (data['id'] == '') {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    }

    return false;
  }

  // list

  Future<List<TermoUso>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _termoUsoAceitos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/termo-uso/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<TermoUso> termoUsoAceitoList = dataList
        .map(
          (e) => TermoUso(
            id: e['id'],
            ip: e['ip'],
            userId: e['userId'],
            userNome: e['userNome'],
          ),
        )
        .toList();

    _termoUsoAceitos.addAll(termoUsoAceitoList);

    notifyListeners();

    return termoUsoAceitoList;
  }

  // get

  Future<TermoUso> get(String id) async {
    TermoUso termoUsoAceito = TermoUso();

    final url = '${AppConstants.apiUrl}/termo-uso/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      termoUsoAceito.id = data['id'];
      termoUsoAceito.ip = data['ip'];
      termoUsoAceito.modeloDispositivo = data['modeloDispositivo'];
      termoUsoAceito.horaAceito = data['horaAceito'];
      termoUsoAceito.userId = data['userId']['id'];
      termoUsoAceito.userNome = data['userId']['name'];
      termoUsoAceito.userLogin = data['userId']['login'];
    }

    return termoUsoAceito;
  }

  // getbyemail

  Future<TermoUso> getByEmail(String email) async {
    TermoUso termoUsoAceito = TermoUso();

    final url = '${AppConstants.apiUrl}/termo-uso/by-email?email=$email';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      termoUsoAceito.id = data['id'];
      termoUsoAceito.ip = data['ip'];
      termoUsoAceito.modeloDispositivo = data['modeloDispositivo'];
      termoUsoAceito.horaAceito = data['horaAceito'];
      termoUsoAceito.userId = data['userId']['id'];
      termoUsoAceito.userNome = data['userId']['name'];
      termoUsoAceito.userLogin = data['userId']['login'];
    }

    return termoUsoAceito;
  }
}
