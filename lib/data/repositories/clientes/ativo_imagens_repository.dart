// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';

class AtivoImagensRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<AtivoImagens> _ativoImagem;

  List<AtivoImagens> get items => [..._ativoImagem];

  int get itemsCount {
    return _ativoImagem.length;
  }

  AtivoImagensRepository([
    this._token = '',
    this._ativoImagem = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/ativo-imagem';

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

  // save imagens
  Future<bool> saveImages(List<File> images, String id) async {
    var url = '${AppConstants.apiUrl}/ativo-imagem/create/$id';
    FormData formData = FormData();

    for (int i = 0; i < images.length; i++) {
      formData.files.add(
        MapEntry(
          'arquivos',
          await MultipartFile.fromFile(
            images[i].path,
            filename: 'image$i.jpg',
          ),
        ),
      );
    }

    try {
      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $_token',
        }),
      );

      if (response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      print('Erro durante o envio das imagens: $e');
    }

    return false;
  }

  // list

  Future<List<AtivoImagens>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _ativoImagem.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/ativo-imagem/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoImagens> ativoImagensList = dataList
        .map(
          (e) => AtivoImagens(
            id: e['id'],
            ativoId: e['ativoId'],
            ativoNome: e['ativoNome'],
            imagemNome: e['imagemNome'],
          ),
        )
        .toList();

    _ativoImagem.addAll(ativoImagensList);

    notifyListeners();

    return ativoImagensList;
  }

  // get

  Future<AtivoImagens> get(String id) async {
    AtivoImagens ativoImagens = AtivoImagens();

    final url = '${AppConstants.apiUrl}/ativo-imagem/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      ativoImagens.id = data['id'];
      ativoImagens.ativoId = data['ativoId'];
      ativoImagens.ativoNome = data['ativoNome'];
      ativoImagens.imagemNome = data['imagemNome'];
    }

    return ativoImagens;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/ativo-imagem/select?filter=$search';

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

  Future<String> delete(AtivoImagens ativoImagens) async {
    final url = '${AppConstants.apiUrl}/ativo-imagem/${ativoImagens.id}';

    final response = await dio.delete(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == null) {
      return 'Erro desconhecido!';
    }

    return 'Sucesso';
  }
}
