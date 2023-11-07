import 'package:locacao/data/repositories/usuarios/dependentes_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/usuarios/dependentes.dart';
import 'package:locacao/presentation/components/app_legenda_desabilitado.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'dependentes_list_widget.dart';

class DependentesListPage extends StatefulWidget {
  const DependentesListPage({Key? key}) : super(key: key);

  @override
  State<DependentesListPage> createState() => _DependentesListPageState();
}

class _DependentesListPageState extends State<DependentesListPage> {
  // List<Dependentes> _cards = [];
  // bool _dataIsLoaded = false;
  late String idAssociado;

  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Dependentes> _cards;

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

  // Future<void> _loadData(String id) async {
  //   List<Dependentes> dependentesList = [];
  // await Provider.of<AssociadosRepository>(context, listen: false).get(id).then(
  //   (value) {
  //     dependentesList = value.dependentes ?? [];
  //     setState(() {
  //       _cards.addAll(dependentesList);
  //     });
  //   },
  // );
  // }

  Future<void> _fetchData() async {
    List<Dependentes> dependenteList = [];
    Authentication authentication = Provider.of(context, listen: false);

    await Provider.of<DependentesRepository>(context, listen: false)
        .listByCliente(authentication.usuarioAssociadoIdSelecionado!, _query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        dependenteList = value;
        setState(() {
          _isLastPage = dependenteList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(dependenteList);
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
        builder: (context) => AppPopErrorDialog(message: 'Ocorreu um erro ao carregar os ativos.')).then((value) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    // if (args != null && !_dataIsLoaded) {
    //   idAssociado = args['id'] ?? '';
    //   // _loadData(idAssociado);
    //   _dataIsLoaded = true;
    // }

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
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: AppScaffold(
        title: Text('Dependentes'),
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                            final Dependentes card = _cards[index];
                            return DependentesListWidget(card);
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
