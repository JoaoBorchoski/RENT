import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import '../utils/pagamentos.dart';
import 'locacoes_list_widget.dart';

class LocacoesListPage extends StatefulWidget {
  const LocacoesListPage({Key? key}) : super(key: key);

  @override
  State<LocacoesListPage> createState() => _LocacoesListPageState();
}

class _LocacoesListPageState extends State<LocacoesListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<AtivoUsuariosLocacao> _cards;

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
        .listByClienteId(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        locacoesList = value;
        print(value);
        setState(() {
          _isLastPage = locacoesList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(locacoesList);
        });
      },
    ).catchError((error) {
      //print('oi erroooo');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  // void _hasErrorDialog() async {
  //   await showDialog(
  //       context: context,
  //       builder: (context) => AppPopErrorDialog(message: 'Ocorreu um erro ao carregar as locacao.')).then((value) {
  //     // setState(() {
  //     //   _isLoading = true;
  //     //   _hasError = false;
  //     //   _fetchData();
  //     // });
  //   });
  // }

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
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Locações'),
          backgroundColor: AppColors.primary,
          leading: BackButton(color: AppColors.background),
        ),
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
                            final AtivoUsuariosLocacao card = _cards[index];
                            return LocacoesListWidget(card);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statusColor(pagamentos),
            ),
          ),
        ),
      ),
    );
  }
}
