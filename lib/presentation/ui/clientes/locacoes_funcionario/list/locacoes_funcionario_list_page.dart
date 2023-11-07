// ignore_for_file: unused_local_variable

import 'package:intl/intl.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
// import 'package:locacao/presentation/components/app_date_picker.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
// import 'package:locacao/presentation/ui/usuarios/locar_forms/utils/parse_to_date_time.dart';
import 'package:provider/provider.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'locacoes_funcionario_list_widget.dart';

class LocacoesFuncionarioListPage extends StatefulWidget {
  const LocacoesFuncionarioListPage({Key? key}) : super(key: key);

  @override
  State<LocacoesFuncionarioListPage> createState() => _LocacoesFuncionarioListPageState();
}

class _LocacoesFuncionarioListPageState extends State<LocacoesFuncionarioListPage> {
  String _query = '';
  String _data = DateTime.now().toString();
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<AtivoUsuariosLocacao> _cards;
  TextEditingController dataFiltroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _page = 1;
    _cards = [];
    _isLastPage = false;
    _isLoading = true;
    _hasError = false;
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<AtivoUsuariosLocacao> locacoesList = [];
    await Provider.of<LocacoesRepository>(context, listen: false)
        .listFuncionarioDia(_query, _data, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        locacoesList = value;
        setState(() {
          _isLastPage = locacoesList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(locacoesList);
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  void _hasErrorDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AppPopErrorDialog(message: 'Ocorreu um erro ao carregar as locacao.')).then((value) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      if (_isLoading) {
        return Center(child: LoadWidget());
      } else if (_hasError) {
        //print('erro');
        _hasErrorDialog();
      }
    }
    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: AppScaffold(
        title: Text('Locações atuais'),
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Campo de busca
              Row(
                children: [
                  Expanded(
                    child: AppSearchBar(
                      onSearch: (q) {
                        setState(() {
                          _query = q;
                          _page = 1;
                          _cards.clear();
                          _fetchData();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(_data),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                        setState(() {
                          dataFiltroController.text = pickedDate.toString();
                          _data = pickedDate.toString();
                          _query = '';
                          _page = 1;
                          _cards.clear();
                          _fetchData();
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  )
                ],
              ),
              Expanded(
                child: SizedBox(
                  child: _cards.isEmpty
                      ? AppNoData()
                      : ListView.builder(
                          itemCount: _cards.length + (_isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index == _cards.length - _nextPageTrigger && !_isLastPage) {
                              _fetchData();
                            }

                            if (index == _cards.length) {
                              if (_hasError) {
                                _hasErrorDialog();
                                //print('erro 2');
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: LoadWidget(),
                                  ),
                                );
                              }
                            }
                            final AtivoUsuariosLocacao card = _cards[index];
                            return LocacoesFuncionarioListWidget(card);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
