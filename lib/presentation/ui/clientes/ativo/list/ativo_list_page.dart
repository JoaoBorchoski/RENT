// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/data/repositories/clientes/categorias_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/categorias.dart';
import 'package:locacao/presentation/components/app_legenda_desabilitado.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/presentation/ui/clientes/ativo/list/ativo_list_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class AtivoListPage extends StatefulWidget {
  const AtivoListPage({Key? key}) : super(key: key);

  @override
  State<AtivoListPage> createState() => _AtivoListPageState();
}

class _AtivoListPageState extends State<AtivoListPage> with SingleTickerProviderStateMixin {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Ativo> _cards;
  TabController? _tabController;
  late List<Categorias> _categorias;

  @override
  void initState() {
    super.initState();
    _page = 1;
    _cards = [];
    _isLastPage = false;
    _isLoading = true;
    _hasError = false;
    _categorias = [];
    _fetchDataCategoria().then((e) {
      _tabController = TabController(length: _categorias.length, vsync: this);
    });

    _fetchData();
    _fetchDataCategoria();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    List<Ativo> ativoList = [];
    await Provider.of<AtivoRepository>(context, listen: false).list(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        ativoList = value;
        setState(() {
          _isLastPage = ativoList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(ativoList);
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  Future<void> _fetchDataCategoria() async {
    Authentication authentication = Provider.of(context, listen: false);

    await Provider.of<CategoriasRepository>(context, listen: false)
        .listByClienteId(authentication.usuarioClienteId, _query, _pageSize, _page, ['ASC', 'ASC']).then((value) {
      setState(
        () {
          _categorias = value;
        },
      );
    }).catchError((error) {
      setState(() {
        _hasError = true;
      });
    });
  }

  void _hasErrorDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AppPopErrorDialog(
              message: 'Ocorreu um erro ao carregar os ativos.',
            )).then((value) {
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
        Navigator.of(context).pushReplacementNamed('/menu-ativos');
        return true;
      },
      child: AppScaffold(
        title: Text('Ativos'),
        route: '/ativos-form',
        showDrawer: false,
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
                        : _buildTabView(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppLegendaDesabilitado(),
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

  Widget _buildTabView() {
    return DefaultTabController(
      length: _categorias.length,
      child: Column(
        children: [
          TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary, //<-- selected text color
            unselectedLabelColor: AppColors.grey,
            controller: _tabController,
            isScrollable: true,
            tabs: _buildTabs(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTabs() {
    return _categorias
        .map((categoria) => Tab(
              text: categoria.nome,
              icon: Icon(AppIcons.icones[categoria.icone]),
            ))
        .toList();
  }

  List<Widget> _buildTabViews() {
    return _categorias.map((categoria) {
      final categoriaCards = _cards.where((ativo) => ativo.categoriaId == categoria.id).toList();
      return ListView.builder(
        itemCount: categoriaCards.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == categoriaCards.length - _nextPageTrigger && !_isLastPage) {
            _fetchData();
          }

          if (index == categoriaCards.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: LoadWidget(),
              ),
            );
          }

          final Ativo card = categoriaCards[index];
          return AtivoListWidget(card);
        },
      );
    }).toList();
  }
}
