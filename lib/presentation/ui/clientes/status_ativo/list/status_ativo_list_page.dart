import 'package:locacao/data/repositories/clientes/status_ativo_repository.dart';
import 'package:locacao/domain/models/clientes/status_ativo.dart';
import 'package:locacao/presentation/components/app_legenda_desabilitado.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'status_ativo_list_widget.dart';

class StatusAtivoListPage extends StatefulWidget {
  const StatusAtivoListPage({Key? key}) : super(key: key);

  @override
  State<StatusAtivoListPage> createState() => _StatusAtivoListPageState();
}

class _StatusAtivoListPageState extends State<StatusAtivoListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<StatusAtivo> _cards;

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
    List<StatusAtivo> statusAtivoList = [];
    await Provider.of<StatusAtivoRepository>(context, listen: false)
        .listByClienteId(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        statusAtivoList = value;
        setState(() {
          _isLastPage = statusAtivoList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(statusAtivoList);
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  void _hasErrorDialog() {
    Future.delayed(Duration.zero, () async {
      await showDialog(
              context: context,
              builder: (context) => AppPopErrorDialog(message: 'Ocorreu um erro ao carregar os status de ativos.'))
          .then((value) {
        setState(() {
          _isLoading = true;
          _hasError = false;
          _fetchData();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      if (_isLoading) {
        return Center(child: LoadWidget());
      } else if (_hasError) {
        _hasErrorDialog();
      }
    }
    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/menu-ativos');
        return retorno;
      },
      child: AppScaffold(
        title: Text('Status Ativos'),
        route: '/status-ativos-form',
        showDrawer: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Campo de busca
              AppSearchBar(
                onSearch: (q) {
                  setState(() {
                    _query = q;
                    _page = 1;
                    _cards.clear();
                    _fetchData();
                  });
                },
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
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: LoadWidget(),
                                  ),
                                );
                              }
                            }
                            final StatusAtivo card = _cards[index];
                            return StatusAtivoListWidget(card);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppLegendaDesabilitado(),
      ),
    );
  }
}
