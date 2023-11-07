import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:locacao/data/repositories/clientes/status_associados_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/associados.dart';
import 'package:locacao/domain/models/clientes/status_associados.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_no_data.dart';
import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/utils/status_color.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:locacao/data/repositories/clientes/associados_repository.dart';
import 'package:locacao/presentation/components/app_search_bar.dart';
import 'associados_list_widget.dart';

class AssociadosListPage extends StatefulWidget {
  const AssociadosListPage({Key? key}) : super(key: key);

  @override
  State<AssociadosListPage> createState() => _AssociadosListPageState();
}

class _AssociadosListPageState extends State<AssociadosListPage> {
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
    _fetchLegendaCores();
  }

  Future<void> _fetchData() async {
    List<Associados> associadosList = [];
    await Provider.of<AssociadosRepository>(context, listen: false)
        .listAllAssociadosCliente(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        associadosList = value;
        setState(() {
          _isLastPage = associadosList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(associadosList);
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  Future<void> _fetchLegendaCores() async {
    List<StatusAssociados> statusAssociadosList = [];
    await Provider.of<StatusAssociadosRepository>(context, listen: false)
        .listAllAssociadosCliente("", 10000, 1, ['ASC', 'ASC']).then(
      (value) {
        statusAssociadosList = value;
        setState(() {
          _isLastPage = statusAssociadosList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cores.addAll(statusAssociadosList);
          _cores.add(StatusAssociados(id: '', nome: 'Não cadastrado', cor: '#111111'));
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  // void _hasErrorDialog() async {
  //   await showDialog(
  //       context: context,
  //       builder: (context) => AppPopErrorDialog(
  //             message: 'Ocorreu um erro ao carregar as associado.',
  //           )).then((value) {});
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
    Authentication auth = Provider.of<Authentication>(context);

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
        Navigator.of(context)
            .pushReplacementNamed(auth.tipoUser == "Cliente Funcionario" ? '/home' : '/menu-associado');
        return retorno;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: AppColors.background),
          title: Text('Associado'),
          backgroundColor: AppColors.primary,
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
                            final Associados card = _cards[index];
                            return AssociadosListWidget(card);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: auth.tipoUser == 'Cliente'
            ? SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: AppColors.secondDegrade,
                spacing: 10,
                spaceBetweenChildren: 5,
                childPadding: EdgeInsets.all(3),
                overlayOpacity: 0,
                childMargin: EdgeInsets.only(right: 14),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.add),
                    backgroundColor: AppColors.secondDegrade,
                    foregroundColor: AppColors.white,
                    label: 'Adicionar',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/associado-form');
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.file_download_outlined),
                    backgroundColor: AppColors.secondDegrade,
                    foregroundColor: AppColors.white,
                    label: 'Importar CSV',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: _openFilePicker,
                  ),
                ],
              )
            : SizedBox.shrink(),
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
                          Text(_cores.firstWhere((element) => element.id == e.id).nome.toString()),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _readCSVFile(file);
    } else {
      // ignore: use_build_context_synchronously
      return showDialog(
          context: context,
          builder: (context) => AppPopErrorDialog(
                message: 'Nenhum arquivo selecionado.',
              ));
    }
  }

  Future<void> _readCSVFile(File file) async {
    try {
      String csvContent = await file.readAsString();
      List<List<dynamic>> csvRows = CsvToListConverter().convert(csvContent);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/associado-import-table', arguments: {
        'associados': csvRows,
        'csvFile': file,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao ler o arquivo: $e');
    }
  }
}
