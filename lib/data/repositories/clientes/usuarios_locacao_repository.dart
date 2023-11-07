import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/domain/models/clientes/convidados.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:locacao/domain/models/clientes/usuarios_locacao.dart';

class UsuariosLocacaoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<UsuariosLocacao> _usuarioLocacao;

  List<UsuariosLocacao> get items => [..._usuarioLocacao];

  int get itemsCount {
    return _usuarioLocacao.length;
  }

  UsuariosLocacaoRepository([
    this._token = '',
    this._usuarioLocacao = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/usuario-locacao';

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

  Future<List<UsuariosLocacao>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _usuarioLocacao.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/usuario-locacao/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<UsuariosLocacao> usuariosLocacaoList = dataList
        .map(
          (e) => UsuariosLocacao(
            id: e['id'],
            locacaoId: e['locacaoId'],
            locacoesDescricao: e['locacoesDescricao'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
          ),
        )
        .toList();

    _usuarioLocacao.addAll(usuariosLocacaoList);

    notifyListeners();

    return usuariosLocacaoList;
  }

  // list usuarios locacoes historico
  Future<List<AtivoUsuariosLocacao>> listUsuarioLocacoes(
    String clienteId,
    String usuarioId,
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    final Map<String, dynamic> data = {
      'clienteId': clienteId,
      'usuarioId': usuarioId,
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/usuario-locacao/list-usuario';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<AtivoUsuariosLocacao> ativoUsuarioLocacaoList = dataList
        .map(
          (e) => AtivoUsuariosLocacao(
            id: e['id'],
            locacaoId: e['locacaoId'],
            locacaoValorTotal: e['valorTotalLocacao'],
            locacaoDataInicio: DateTime.parse(e['dataInicio']),
            locacaoDataTermino: DateTime.parse(e['dataFim']),
            locacaoDataPagamento: e['dataPagamento'],
            locacaoHoraInicio: e['horaInicio'],
            locacaoHoraTermino: e['horaFim'],
            locacaoHoraPagamento: e['horaPagamento'],
            meioPagamentoId: e['meioPagamentoId'],
            meioPagamentoNome: e['meiosPagamentoNome'],
            usuarioId: e['usuarioId'],
            usuariosNome: e['usuariosNome'],
            ativoId: e['ativoId'],
            ativoNome: e['ativosNome'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            locacoesStatus: e['statusLocacao'],
            quantidadeConvidadosNaoAssociados: e['quantidadeConvidadosNaoAssociados'],
            quantidadeConvidados: e['quantidadeConvidados'],
          ),
        )
        .toList();

    notifyListeners();

    return ativoUsuarioLocacaoList;
  }

  // get

  Future<AtivoUsuariosLocacao> get(String id) async {
    AtivoUsuariosLocacao ativoUsuariosLocacao = AtivoUsuariosLocacao();

    final url = '${AppConstants.apiUrl}/usuario-locacao/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      ativoUsuariosLocacao.id = data['id'];
      ativoUsuariosLocacao.locacaoId = data['locacaoId'];
      ativoUsuariosLocacao.locacoesStatus = data['locacoesStatus'];
      ativoUsuariosLocacao.locacaoValorTotal = data['locacaoValorTotal'];
      ativoUsuariosLocacao.locacaoValorTotalConvidados = data['locacaoValorTotalConvidados'];
      ativoUsuariosLocacao.locacaoValorOutrasTaxas = data['locacaoValorOutrasTaxas'];
      ativoUsuariosLocacao.locacaoValorAtivoInicial = data['locacaoValorAtivoInicial'];
      ativoUsuariosLocacao.locacaoDataInicio = DateTime.parse(data['locacaoDataInicio']);
      ativoUsuariosLocacao.locacaoDataTermino = DateTime.parse(data['locacaoDataFim']);
      ativoUsuariosLocacao.locacaoDataPagamento = data['locacaoDataPagamento'];
      ativoUsuariosLocacao.locacaoDataLimitePagamento = data['locacaoDataLimitePagamento'];
      ativoUsuariosLocacao.locacaoHoraInicio = data['locacaoHoraInicio'];
      ativoUsuariosLocacao.locacaoHoraTermino = data['locacaoHoraFim'];
      ativoUsuariosLocacao.locacaoHoraPagamento = data['locacaoHoraPagamento'];
      ativoUsuariosLocacao.locacaoHoraLimitePagamento = data['locacaoHoraLimitePagamento'];
      ativoUsuariosLocacao.locacaoObservacoes = data['locacaoObservacoes'];
      ativoUsuariosLocacao.meioPagamentoId = data['meioPagamentoId'];
      ativoUsuariosLocacao.meioPagamentoNome = data['meiosPagamentoNome'];
      ativoUsuariosLocacao.usuarioId = data['usuarioId'];
      ativoUsuariosLocacao.usuariosNome = data['usuariosNome'];
      ativoUsuariosLocacao.usuariosCodigoSocio = data['usuariosCodigoSocio'];
      ativoUsuariosLocacao.ativoId = data['ativoId'];
      ativoUsuariosLocacao.ativoNome = data['ativosNome'];
      ativoUsuariosLocacao.clienteId = data['clienteId'];
      ativoUsuariosLocacao.clienteNome = data['clienteNome'];
      ativoUsuariosLocacao.categoriaId = data['categoriaId'];
      ativoUsuariosLocacao.categoriaNome = data['categoriasNome'];
      ativoUsuariosLocacao.ativosIdentificador = data['ativosIdentificador'];
      ativoUsuariosLocacao.ativosDescricao = data['ativosDescricao'];
      ativoUsuariosLocacao.ativoLimiteConvidadosExtra = data['ativoLimiteConvidadosExtra'];
      ativoUsuariosLocacao.ativosImagens = data['ativoImagens'] != null
          ? List<AtivoImagens>.from(
              data['ativoImagens'].map(
                (i) => AtivoImagens(
                  id: i['id'],
                  imagemNome: i['imagemNome'],
                ),
              ),
            )
          : [];
      ativoUsuariosLocacao.ativosConvidados = data['convidados'] != null
          ? List<Convidados>.from(
              data['convidados'].map(
                (i) => Convidados(
                  id: i['id'],
                  nome: i['convidadoNome'],
                  email: i['convidadoEmail'],
                  idade: int.tryParse(i['convidadoIdade']) ?? 0,
                  telefone: i['convidadoTelefone'],
                  codSocio: i['convidadoCodigoSocio'],
                  isAssociado: i['convidadoIsAssociado'],
                  isPresente: i['convidadoIsPresente'],
                ),
              ),
            )
          : [];

      ativoUsuariosLocacao.quantidadeConvidados = data['convidados'] != null ? data['convidados'].length : 0;
      ativoUsuariosLocacao.quantidadeConvidadosExtra = data['convidados'] != null
          ? data['convidados'].where((element) => element['convidadoIsExtra'] == true).length
          : 0;
      ativoUsuariosLocacao.quantidadeConvidadosAssociados = data['convidados'] != null
          ? data['convidados'].where((element) => element['convidadoIsAssociado'] == true).length
          : 0;
      ativoUsuariosLocacao.quantidadeConvidadosNaoAssociados = data['convidados'] != null
          ? data['convidados'].where((element) => element['convidadoIsAssociado'] == false).length
          : 0;
    }

    return ativoUsuariosLocacao;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/usuario-locacao/select?filter=$search';

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

  Future<String> delete(UsuariosLocacao usuariosLocacao) async {
    int index = _usuarioLocacao.indexWhere((p) => p.id == usuariosLocacao.id);

    if (index >= 0) {
      final usuariosLocacao = _usuarioLocacao[index];
      _usuarioLocacao.remove(usuariosLocacao);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/usuario-locacao/${usuariosLocacao.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _usuarioLocacao.insert(index, usuariosLocacao);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
