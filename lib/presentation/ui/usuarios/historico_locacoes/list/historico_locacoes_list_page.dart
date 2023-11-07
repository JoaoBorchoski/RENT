// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/usuarios_locacao_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/presentation/ui/clientes/locacoes/utils/pagamentos.dart';
import 'package:locacao/presentation/ui/usuarios/historico_locacoes/list/historico_locacao_list_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class HistoricoLocacoesListPage extends StatefulWidget {
  const HistoricoLocacoesListPage({Key? key}) : super(key: key);

  @override
  State<HistoricoLocacoesListPage> createState() => _HistoricoLocacoesListPageState();
}

class _HistoricoLocacoesListPageState extends State<HistoricoLocacoesListPage> with SingleTickerProviderStateMixin {
  String _query = '';
  // ignore: prefer_final_fields
  String _usuarioId = '';
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
    Authentication authentication = Provider.of<Authentication>(context, listen: false);

    List<AtivoUsuariosLocacao> historicoLocacoesList = [];

    await Provider.of<UsuariosLocacaoRepository>(context, listen: false).listUsuarioLocacoes(
        authentication.usuarioAssociadoIdSelecionado!, _usuarioId, _query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        historicoLocacoesList = value;
        setState(() {
          _isLastPage = historicoLocacoesList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(historicoLocacoesList);
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
        Navigator.of(context).pushReplacementNamed('/locar');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Histórico de Locações'),
          backgroundColor: AppColors.primary,
          leading: BackButton(color: AppColors.background),
        ),
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
        if (index == _cards.length - _nextPageTrigger && !_isLastPage) {
          _fetchData();
        }

        if (index == _cards.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: LoadWidget(),
            ),
          );
        }

        final AtivoUsuariosLocacao card = _cards[index];

        return HistoricoLocacaoListWidget(card);
      },
    );
  }
}
