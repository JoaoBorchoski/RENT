import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/usuarios/favoritos.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';

class FavoritoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Favorito> _favoritos;

  List<Favorito> get items => [..._favoritos];

  int get itemsCount {
    return _favoritos.length;
  }

  FavoritoRepository([
    this._token = '',
    this._favoritos = const [],
  ]);

  // Save

  Future<String> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/favorito';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return response.data["data"]["id"];
    }

    return "";
  }

  // list

  Future<List<Favorito>> list(
    String? clienteId,
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _favoritos.clear();
    final Map<String, dynamic> data = {
      'clienteId': clienteId,
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/favorito/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Favorito> favoritoList = dataList
        .map(
          (e) => Favorito(
              id: e['id'],
              usuarioId: e['usuarioId'],
              usuarioNome: e['usuarioNome'],
              ativo: Ativo(
                id: e['ativoId'],
                nome: e['ativoNome'],
                clienteId: e['clienteId'],
                clienteNome: e['clienteNome'],
                categoriaId: e['categoriaId'],
                valor: double.parse(e['valor']),
                categoriasNome: e['categoriasNome'],
                statusId: e['statusId'],
                statusNome: e['statusNome'],
                identificador: e['identificador'],
                pagamentoDiaHoraValue: e['pagamentoHoraDia'],
                ativoImagens: e['ativoImagens'] != null
                    ? List<AtivoImagens>.from(
                        e['ativoImagens'].map(
                          (i) => AtivoImagens(
                            id: i['id'],
                            imagemNome: i['imagemNome'],
                          ),
                        ),
                      )
                    : [],
              )),
        )
        .toList();

    _favoritos.addAll(favoritoList);

    notifyListeners();

    return favoritoList;
  }

  // get by ativo

  Future<Favorito> getByAtivo(String ativoId) async {
    Favorito favorito = Favorito();

    const url = '${AppConstants.apiUrl}/favorito/by-ativo';

    final response = await dio.get(
      url,
      queryParameters: {
        'ativoId': ativoId,
      },
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      favorito.id = data['id'];
      favorito.usuarioId = data['usuarioId'];
      favorito.usuarioNome = data['usuarioNome'];
      favorito.ativo?.id = data['ativoId'];
      favorito.ativo?.nome = data['ativoNome'];
    }

    return favorito;
  }

  // delete

  Future<String> delete(String ativoId) async {
    const url = '${AppConstants.apiUrl}/favorito';

    final response = await dio.delete(
      url,
      data: {
        'ativoId': ativoId,
      },
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == null) {
      return 'Erro desconhecido!';
    }

    return 'Sucesso';
  }
}
