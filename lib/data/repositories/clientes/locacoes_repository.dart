import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';

class LocacoesRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Locacoes> _locacao;

  List<Locacoes> get items => [..._locacao];

  int get itemsCount {
    return _locacao.length;
  }

  LocacoesRepository([
    this._token = '',
    this._locacao = const [],
  ]);

  // Save

  Future<String> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/locacao';

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

  Future<List<Locacoes>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _locacao.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/locacao/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Locacoes> locacoesList = dataList
        .map(
          (e) => Locacoes(
            id: e['id'],
            meioPagamentoId: e['meioPagamentoId'],
            meioPagamentoNome: e['meioPagamentoNome'],
            dataInicio: DateTime.parse(e['dataInicio']),
            dataFim: DateTime.parse(e['dataFim']),
            horaInicio: e['horaInicio'],
            horaFim: e['horaFim'],
            observacoes: e['observacoes'],
            status: e['status'],
          ),
        )
        .toList();

    _locacao.addAll(locacoesList);

    notifyListeners();

    return locacoesList;
  }

  // listByClienteId

  Future<List<AtivoUsuariosLocacao>> listByClienteId(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _locacao.clear();

    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/locacao/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoUsuariosLocacao> locacoesList = dataList
        .map(
          (e) => AtivoUsuariosLocacao(
            locacaoId: e['id'],
            id: e['usuarioLocacaoId'],
            usuarioId: e['usuarioId'],
            ativoId: e['ativoId'],
            clienteId: e['clienteId'],
            meioPagamentoId: e['meioPagamentoId'],
            meioPagamentoNome: e['meiosPagamentoNome'],
            usuariosNome: e['usuariosNome'],
            usuariosCodigoSocio: e['usuariosCodigoSocio'],
            ativoNome: e['ativosNome'],
            locacaoValorTotal: e['valorTotalLocacao'],
            locacaoDataInicio: DateTime.parse(e['dataInicio']),
            locacaoDataTermino: DateTime.parse(e['dataFim']),
            locacaoHoraInicio: e['horaInicio'],
            locacaoHoraTermino: e['horaFim'],
            locacoesStatus: e['statusLocacao'],
            quantidadeConvidadosNaoAssociados: e['quantidadeConvidadosNaoAssociados'],
            quantidadeConvidados: e['quantidadeConvidados'],
          ),
        )
        .toList();

    // _locacao.addAll(locacoesList);

    notifyListeners();

    return locacoesList;
  }

  // listFuncionario

  Future<List<AtivoUsuariosLocacao>> listFuncionario(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _locacao.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/locacao/list-funcionario';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoUsuariosLocacao> locacoesList = dataList
        .map(
          (e) => AtivoUsuariosLocacao(
            locacaoId: e['id'],
            id: e['usuarioLocacaoId'],
            usuarioId: e['usuarioId'],
            ativoId: e['ativoId'],
            clienteId: e['clienteId'],
            usuariosCodigoSocio: e['usuariosCodigoSocio'],
            usuariosNome: e['usuariosNome'],
            ativoNome: e['ativosNome'],
            locacaoDataInicio: DateTime.parse(e['dataInicio']),
            locacaoDataTermino: DateTime.parse(e['dataFim']),
            locacaoHoraInicio: e['horaInicio'],
            locacaoHoraTermino: e['horaFim'],
            quantidadeConvidadosNaoAssociados: e['quantidadeConvidadosNaoAssociados'],
            quantidadeConvidados: e['quantidadeConvidados'],
            quantidadeConvidadosPresentes: e['quantidadeConvidadosPresentes'],
          ),
        )
        .toList();

    // _locacao.addAll(locacoesList);

    notifyListeners();

    return locacoesList;
  }

  // listFuncionario

  Future<List<AtivoUsuariosLocacao>> listFuncionarioDia(
    String? search,
    String? dia,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _locacao.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'dia': dia,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/locacao/list-funcionario-dia';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoUsuariosLocacao> locacoesList = dataList
        .map(
          (e) => AtivoUsuariosLocacao(
            locacaoId: e['id'],
            id: e['usuarioLocacaoId'],
            usuarioId: e['usuarioId'],
            ativoId: e['ativoId'],
            clienteId: e['clienteId'],
            usuariosCodigoSocio: e['usuariosCodigoSocio'],
            usuariosNome: e['usuariosNome'],
            ativoNome: e['ativosNome'],
            locacaoDataInicio: DateTime.parse(e['dataInicio']),
            locacaoDataTermino: DateTime.parse(e['dataFim']),
            locacaoHoraInicio: e['horaInicio'],
            locacaoHoraTermino: e['horaFim'],
            quantidadeConvidadosNaoAssociados: e['quantidadeConvidadosNaoAssociados'],
            quantidadeConvidados: e['quantidadeConvidados'],
            quantidadeConvidadosPresentes: e['quantidadeConvidadosPresentes'],
          ),
        )
        .toList();

    // _locacao.addAll(locacoesList);

    notifyListeners();

    return locacoesList;
  }

  // listByDia

  Future<List<AtivoUsuariosLocacao>> listByDia(
    String dia,
    String ativoId,
  ) async {
    _locacao.clear();
    final Map<String, dynamic> data = {
      'ativoId': ativoId,
      'dia': dia,
    };
    const url = '${AppConstants.apiUrl}/locacao/list-dia';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data;

    List<AtivoUsuariosLocacao> locacoesList = dataList
        .map(
          (e) => AtivoUsuariosLocacao(
            locacaoId: e['id'],
            id: e['usuarioLocacaoId'],
            ativoId: e['ativoId'],
            clienteId: e['clienteId'],
            ativoNome: e['ativosNome'],
            locacaoDataInicio: DateTime.parse(e['dataInicio']),
            locacaoDataTermino: DateTime.parse(e['dataFim']),
            locacaoHoraInicio: e['horaInicio'],
            locacaoHoraTermino: e['horaFim'],
          ),
        )
        .toList();

    notifyListeners();

    return locacoesList;
  }

// listByPeriodo
  Future<List<AtivoUsuariosLocacao>> listByPeriodo(
    String diaInicial,
    String diaFinal,
    String ativoId,
  ) async {
    _locacao.clear();
    final Map<String, dynamic> data = {
      'ativoId': ativoId,
      'diaInicial': diaInicial,
      'diaFinal': diaFinal,
    };
    const url = '${AppConstants.apiUrl}/locacao/list-periodo';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data;

    List<AtivoUsuariosLocacao> locacoesList = dataList
        .map(
          (e) => AtivoUsuariosLocacao(
            locacaoId: e['id'],
            id: e['usuarioLocacaoId'],
            ativoId: e['ativoId'],
            clienteId: e['clienteId'],
            ativoNome: e['ativosNome'],
            locacaoDataInicio: DateTime.parse(e['dataInicio']),
            locacaoDataTermino: DateTime.parse(e['dataFim']),
            locacaoHoraInicio: e['horaInicio'],
            locacaoHoraTermino: e['horaFim'],
          ),
        )
        .toList();

    notifyListeners();

    return locacoesList;
  }

  // get

  Future<Locacoes> get(String id) async {
    Locacoes locacoes = Locacoes();

    final url = '${AppConstants.apiUrl}/locacao/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      locacoes.id = data['id'];
      locacoes.valorTotal = data['valorTotal'];
      locacoes.valorTotalConvidados = data['valorTotalConvidados'];
      locacoes.valorOutrasTaxas = data['valorOutrasTaxas'];
      locacoes.valorAtivoInicial = data['valorAtivoInicial'];
      locacoes.dataInicio = DateTime.parse(data['dataInicio']);
      locacoes.dataFim = DateTime.parse(data['dataFim']);
      locacoes.horaInicio = data['horaInicio'];
      locacoes.horaFim = data['horaFim'];
      locacoes.dataPagamento = DateTime.parse(data['dataPagamento']);
      locacoes.horaPagamento = data['horaPagamento'];
      locacoes.dataLimitePagamento = DateTime.parse(data['dataLimitePagamento']);
      locacoes.horaLimitePagamento = data['horaLimitePagamento'];
      locacoes.meioPagamentoId = data['meioPagamentoId'];
      locacoes.meioPagamentoNome = data['meioPagamentoNome'];
      locacoes.observacoes = data['observacoes'];
      locacoes.status = data['status'];
    }

    return locacoes;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/locacao/select?filter=$search';

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

  Future<String> delete(Locacoes locacoes) async {
    int index = _locacao.indexWhere((p) => p.id == locacoes.id);

    if (index >= 0) {
      final locacoes = _locacao[index];
      _locacao.remove(locacoes);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/locacao/${locacoes.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _locacao.insert(index, locacoes);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
