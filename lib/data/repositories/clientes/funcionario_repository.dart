import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/funcionario.dart';
import 'package:locacao/domain/models/shared/suggestion_select.dart';
import 'package:locacao/shared/config/app_constants.dart';

class FuncionarioRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Funcionario> _funcionarios;

  List<Funcionario> get items => [..._funcionarios];

  int get itemsCount {
    return _funcionarios.length;
  }

  FuncionarioRepository([
    this._token = '',
    this._funcionarios = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/funcionarios';

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

  Future<List<Funcionario>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _funcionarios.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/funcionarios/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Funcionario> funcionarioList = dataList
        .map(
          (e) => Funcionario(
            id: e['id'],
            matricula: e['matricula'],
            nome: e['nome'],
            email: e['email'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            avatar: e['avatar'],
            cpf: e['cpf'],
            telefone: e['telefone'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _funcionarios.addAll(funcionarioList);

    notifyListeners();

    return funcionarioList;
  }

  // list by clienteId

  Future<List<Funcionario>> listByClienteId(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _funcionarios.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/funcionarios/list-cliente';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    List dataList = response.data['items'];

    List<Funcionario> funcionarioList = dataList
        .map(
          (e) => Funcionario(
            id: e['id'],
            matricula: e['matricula'],
            nome: e['nome'],
            email: e['email'],
            clienteId: e['clienteId'],
            clienteNome: e['clienteNome'],
            avatar: e['avatar'],
            cpf: e['cpf'],
            telefone: e['telefone'],
            desabilitado: e['desabilitado'],
          ),
        )
        .toList();

    _funcionarios.addAll(funcionarioList);

    notifyListeners();

    return funcionarioList;
  }

  // get

  Future<Funcionario> get(String id) async {
    Funcionario funcionario = Funcionario();

    final url = '${AppConstants.apiUrl}/funcionarios/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      funcionario.id = data['id'];
      funcionario.clienteId = data['clienteId'];
      funcionario.clienteNome = data['clienteNome'];
      funcionario.matricula = data['matricula'];
      funcionario.avatar = data['avatar'];
      funcionario.cpf = data['cpf'];
      funcionario.nome = data['nome'];
      funcionario.email = data['email'];
      funcionario.telefone = data['telefone'];
      funcionario.endereco = data['endereco'];
      funcionario.numero = data['numero'];
      funcionario.bairro = data['bairro'];
      funcionario.complemento = data['complemento'];
      funcionario.estadoId = data['estadoId'];
      funcionario.estadoUf = data['estadoUf'];
      funcionario.cidadeId = data['cidadeId'];
      funcionario.cidadeNomeCidade = data['cidadeNomeCidade'];
      funcionario.cep = data['cep'];
      funcionario.desabilitado = data['desabilitado'];
    }

    return funcionario;
  }

  // getbyemail

  Future<Funcionario> getByEmail(String? email) async {
    Funcionario funcionario = Funcionario();

    final url = '${AppConstants.apiUrl}/funcionarios/by-email?email=$email';

    final response = await dio.get(
      url,
      options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      funcionario.id = data['id'];
      funcionario.clienteId = data['clienteId'];
      funcionario.clienteNome = data['clienteNome'];
      funcionario.matricula = data['matricula'];
      funcionario.avatar = data['avatar'];
      funcionario.cpf = data['cpf'];
      funcionario.nome = data['nome'];
      funcionario.email = data['email'];
      funcionario.telefone = data['telefone'];
      funcionario.endereco = data['endereco'];
      funcionario.numero = data['numero'];
      funcionario.bairro = data['bairro'];
      funcionario.complemento = data['complemento'];
      funcionario.estadoId = data['estadoId'];
      funcionario.estadoUf = data['estadoUf'];
      funcionario.cidadeId = data['cidadeId'];
      funcionario.cidadeNomeCidade = data['cidadeNomeCidade'];
      funcionario.cep = data['cep'];
      funcionario.desabilitado = data['desabilitado'];
    }

    return funcionario;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/funcionarios/select?filter=$search';

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

  Future<String> delete(Funcionario funcionario) async {
    int index = _funcionarios.indexWhere((p) => p.id == funcionario.id);

    if (index >= 0) {
      final funcionario = _funcionarios[index];
      _funcionarios.remove(funcionario);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/funcionarios/${funcionario.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _funcionarios.insert(index, funcionario);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
