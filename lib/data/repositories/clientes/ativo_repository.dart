import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';

class AtivoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Ativo> _ativos;

  List<Ativo> get items => [..._ativos];

  int get itemsCount {
    return _ativos.length;
  }

  AtivoRepository([
    this._token = '',
    this._ativos = const [],
  ]);

  // Save

  Future<String> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/ativos';

    if (data['id'] == '') {
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

    final response = await dio.put(
      '$url/${data['id']!}',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      return response.data["data"]["id"];
    }

    return "";
  }

  // list

  Future<List<Ativo>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _ativos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/ativos/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Ativo> ativoList = dataList
        .map(
          (e) => Ativo(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            categoriaId: e['categoriaId'],
            valor: double.parse(e['valor']),
            limiteConvidados: e['limiteConvidados'],
            categoriasNome: e['categoriasNome'],
            pagamentoDiaHoraValue: e['pagamentoHoraDia'],
            statusId: e['statusId'],
            statusNome: e['statusNome'],
            identificador: e['identificador'],
            nome: e['nome'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _ativos.addAll(ativoList);

    notifyListeners();

    return ativoList;
  }

  // list

  Future<List<Ativo>> listComImg(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _ativos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/ativos/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];
    List<Ativo> ativoList = dataList
        .map(
          (e) => Ativo(
            id: e['id'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            categoriaId: e['categoriaId'],
            valor: double.parse(e['valor']),
            limiteConvidados: e['limiteConvidados'],
            categoriasNome: e['categoriasNome'],
            pagamentoDiaHoraValue: e['pagamentoHoraDia'],
            statusId: e['statusId'],
            statusNome: e['statusNome'],
            identificador: e['identificador'],
            nome: e['nome'],
            desabilitado: e['desabilitado'],
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
          ),
        )
        .toList();

    _ativos.addAll(ativoList);

    notifyListeners();

    return ativoList;
  }

  // get

  Future<Ativo> get(String id) async {
    Ativo ativo = Ativo();

    final url = '${AppConstants.apiUrl}/ativos/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      ativo.id = data['id'];
      ativo.clienteId = data['clienteId'];
      ativo.clienteNome = data['clienteNome'];
      ativo.categoriaId = data['categoriaId'];
      ativo.categoriasNome = data['categoriasNome'];
      ativo.identificador = data['identificador'];
      ativo.nome = data['nome'];
      ativo.pagamentoDiaHoraValue = data['pagamentoHoraDia'];
      ativo.pagamentoDiaHoraNome =
          data['pagamentoHoraDia'][0].toString().toUpperCase() + data['pagamentoHoraDia'].substring(1).toLowerCase();
      ativo.limiteDiasHorasSeguidas = data['limiteDiasHorasSeguidas'];
      ativo.descricao = data['descricao'];
      ativo.valor = double.parse(data['valor']);
      ativo.limiteConvidados = data['limiteConvidados'];
      ativo.limiteConvidadosExtra = data['limiteConvidadosExtra'];
      ativo.limiteAntecedenciaLocar = data['limiteAntecedenciaLocar'];
      ativo.statusNome = data['statusNome'];
      ativo.statusId = data['statusId'];
      ativo.desabilitado = data['desabilitado'];
      ativo.ativoImagens = data['ativoImagens'] != null
          ? List<AtivoImagens>.from(
              data['ativoImagens'].map(
                (i) => AtivoImagens(
                  id: i['id'],
                  imagemNome: i['imagemNome'],
                ),
              ),
            )
          : [];
    }

    return ativo;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/ativos/select?filter=$search';

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

  Future<List<Map<String, String>>> selectByClienteId(String search) async {
    final url = '${AppConstants.apiUrl}/ativos/select-cliente?filter=$search';

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

  Future<String> delete(Ativo ativo) async {
    int index = _ativos.indexWhere((p) => p.id == ativo.id);

    if (index >= 0) {
      final ativo = _ativos[index];
      _ativos.remove(ativo);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/ativos/${ativo.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _ativos.insert(index, ativo);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
