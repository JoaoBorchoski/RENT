import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/status_associados.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_text_image.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/presentation/ui/usuarios/associados_login_usuario/list/associados_usuario_login_list_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:locacao/data/repositories/clientes/associados_repository.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';

class AssociadosUsuarioLoginListPage extends StatefulWidget {
  const AssociadosUsuarioLoginListPage({Key? key}) : super(key: key);

  @override
  State<AssociadosUsuarioLoginListPage> createState() => _AssociadosUsuarioLoginListPageState();
}

class _AssociadosUsuarioLoginListPageState extends State<AssociadosUsuarioLoginListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 10;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Associados> _cards;
  late List<StatusAssociados> _cores;

  @override
  void initState() {
    super.initState();
    _page = 1;
    _cards = [];
    _cores = [];
    _isLastPage = false;
    _isLoading = true;
    _hasError = false;
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Associados> associadosList = [];
    await Provider.of<AssociadosRepository>(context, listen: false)
        .listAllClientesAssociado(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        associadosList = value;
        setState(() {
          _isLastPage = associadosList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(associadosList);
          associadosList
              .map((e) => _cores.add(StatusAssociados(
                    id: e.statusAssociadoId,
                    nome: e.statusAssociadoNome,
                    cor: e.statusAssociadoCor,
                    clienteNome: e.clienteNome,
                  )))
              .toList();
          _cores.add(StatusAssociados(id: '', nome: 'Status erro', cor: '#111111', clienteNome: 'Erro'));
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
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Minhas Associações'),
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            leading: null,
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Sair"),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.only(right: 12),
                ),
              )
            ],
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
                        ? AppTextImage(
                            icon: Icons.search,
                            text: 'Nenhum associado encontrado, entre em contato com sua associação.',
                          )
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
                              final Associados card = _cards[index];
                              return AssociadosUsuarioLoginListWidget(card);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: Padding(
          //   padding: EdgeInsets.only(top: 5, bottom: 5),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: _cores
          //             .map(
          //               (e) => Row(
          //                 children: [
          //                   Card(
          //                     color: statusColorHex(_cores.firstWhere((element) => element.id == e.id).cor!),
          //                     child: SizedBox(height: 15, width: 15),
          //                   ),
          //                   Text(_cores.firstWhere((element) => element.id == e.id).nome.toString()),
          //                 ],
          //               ),
          //             )
          //             .toList(),
          //       ),
          //     ),
          //   ),
          // ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _cores
                      .map(
                        (e) => Row(
                          children: [
                            Card(
                              color: statusColorHex(_cores.firstWhere((element) => element.id == e.id).cor!),
                              child: SizedBox(height: 15, width: 15),
                            ),
                            Text(
                              '${_cores.firstWhere((element) => element.id == e.id).clienteNome} - ${_cores.firstWhere((element) => element.id == e.id).nome.toString()}',
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          )),
    );
  }
}
