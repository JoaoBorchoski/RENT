// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/favoritos_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/usuarios/favoritos.dart';
import 'package:locacao/presentation/components/app_carrossel_list_widget.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'package:provider/provider.dart';

class FavoritoListPage extends StatefulWidget {
  const FavoritoListPage({Key? key}) : super(key: key);

  @override
  State<FavoritoListPage> createState() => _FavoritoListPageState();
}

class _FavoritoListPageState extends State<FavoritoListPage> with SingleTickerProviderStateMixin {
  String _query = '';
  late int _page;
  // final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Ativo> _cards;

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
    Authentication authentication = Provider.of<Authentication>(context, listen: false);

    List<Favorito> favoritoList = [];
    await Provider.of<FavoritoRepository>(context, listen: false)
        .list(authentication.usuarioAssociadoIdSelecionado, _query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        favoritoList = value;
        setState(() {
          _isLastPage = favoritoList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(favoritoList.map((e) => e.ativo!));
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
    if (_cards.isEmpty) {
      if (_isLoading) {
        return Center(child: LoadWidget());
      } else if (_hasError) {
        return _buildErrorDialog();
      }
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return true;
      },
      child: AppScaffold(
        title: Text('Favoritos'),
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Campo de busca
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
                child: _isLoading
                    ? Center(child: LoadWidget())
                    : _hasError
                        ? _buildErrorDialog()
                        : _buildListWidgets(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorDialog() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ocorreu um erro ao carregar os ativos.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                  _fetchData();
                });
              },
              child: Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListWidgets() {
    return ListView.builder(
      itemCount: _cards.length + (_isLastPage ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == _cards.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: LoadWidget(),
            ),
          );
        }

        final Ativo card = _cards[index];
        return AppCarrosselListWidget(
          isFavorite: false,
          isInList: true,
          ativo: card,
          heightCard: 300,
          marginHorizontalCard: 10,
          marginVerticalCard: 5,
          borderRadius: 10,
          onTapUpFuncion: (value) => {
            Navigator.pushNamed(
              context,
              '/ativos-detalhe',
              arguments: {'id': card.id},
            ),
          },
        );
      },
    );
  }
}
