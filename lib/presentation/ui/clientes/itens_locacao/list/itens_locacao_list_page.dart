import 'package:locacao/domain/models/clientes/itens_locacao.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:locacao/data/repositories/clientes/itens_locacao_repository.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'itens_locacao_list_widget.dart';

class ItensLocacaoListPage extends StatefulWidget {
  const ItensLocacaoListPage({Key? key}) : super(key: key);

  @override
  State<ItensLocacaoListPage> createState() => _ItensLocacaoListPageState();
}

class _ItensLocacaoListPageState extends State<ItensLocacaoListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<ItensLocacao> _cards;

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
    List<ItensLocacao> itensLocacaoList = [];
    await Provider.of<ItensLocacaoRepository>(context, listen: false).list(_query, _pageSize, _page, ['ASC', 'ASC']).then((value) {
        itensLocacaoList = value;
        setState(() {
          _isLastPage = itensLocacaoList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(itensLocacaoList);
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
            builder: (context) => AppPopErrorDialog(message: 'Ocorreu um erro ao carregar as item-locacao.'))
        .then((value) {
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
        _hasErrorDialog();
      }
    }
    return WillPopScope(onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: AppScaffold(title: Text('ItemLocacao'),
        route: '/item-locacao-form',
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Campo de busca
              AppSearchBar(onSearch: (q) {
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
                  : ListView.builder(itemCount: _cards.length + (_isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == _cards.length - _nextPageTrigger && !_isLastPage) {
                          _fetchData();
                        }

                        if (index == _cards.length) {
                          if (_hasError) {
                            _hasErrorDialog();
                          } else {
                            return const Center(
                              child: Padding(padding: EdgeInsets.all(8),
                                child: LoadWidget(),
                              ),
                            );
                          }
                        }
                        final ItensLocacao card = _cards[index];
                        return ItensLocacaoListWidget(card);
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
