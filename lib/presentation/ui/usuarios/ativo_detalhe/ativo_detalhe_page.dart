import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/ativo_oferece_repository.dart';
import 'package:locacao/data/repositories/clientes/ativo_regras_repository.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_oferece.dart';
import 'package:locacao/domain/models/clientes/ativo_regras.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/utils/app_icons.dart';
import 'package:locacao/presentation/ui/usuarios/ativo_detalhe/aitvo_detalhe_imagem_page.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../components/app_carrossel_list_widget.dart';

class AtivoDetalhePage extends StatefulWidget {
  const AtivoDetalhePage({Key? key}) : super(key: key);

  @override
  State<AtivoDetalhePage> createState() => _AtivoDetalhePageState();
}

class _AtivoDetalhePageState extends State<AtivoDetalhePage> {
  bool _dataIsLoaded = false;
  bool isPopUpImagemOpen = false;

  final _ativo = Ativo(
    id: '',
    clienteId: '',
    clienteNome: '',
    categoriaId: '',
    categoriasNome: '',
    identificador: '',
    nome: '',
    descricao: '',
    valor: 0,
    statusId: '',
    statusNome: '',
    ativoImagens: [],
  );

  final List<Map<String, dynamic>> _ativoOferece = [];
  final List<Map<String, dynamic>> _ativoRegras = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (!_dataIsLoaded) {
      _loadData(args['id']).then((value) {
        _loadDataOferece();
        _loadDataRegras();
      });
      _dataIsLoaded = true;
    }

    if (_ativo.id == null || _ativo.id == '') {
      return Center(
        child: LoadWidget(),
      );
    }

    if (isPopUpImagemOpen) {
      return AtivoDetalheImagemPage(
          ativoImagens: _ativo.ativoImagens!,
          funcaoVoltar: () {
            setState(() {
              isPopUpImagemOpen = false;
            });
          });
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushNamedAndRemoveUntil('/locar', (route) => false);

        return retorno;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_ativo.nome!),
          backgroundColor: AppColors.primary,
        ),
        body: fieldsDetalhe(context),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valor: R\$ ${_ativo.valor?.toStringAsFixed(2)}/${_ativo.pagamentoDiaHoraValue}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/locar-ativo', arguments: {'idAtivo': _ativo.id, 'ativo': _ativo});
                  },
                  child: Text('Reservar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView fieldsDetalhe(context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCarrosselListWidget(
            isFavorite: false,
            isInList: false,
            ativo: _ativo,
            heightCard: 200,
            marginHorizontalCard: 0,
            marginVerticalCard: 0,
            borderRadius: 0,
            onTapUpFuncion: (_) {
              setState(() {
                isPopUpImagemOpen = true;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescricao,
                _buildLine,
                _buildLugarOferece,
                _buildLine,
                _buildRegrasLugar,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildDescricao {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'Descrição',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12),
        Text(
          _ativo.descricao!,
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget get _buildLine {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          height: 1,
          color: Colors.grey[400],
        ),
        // SizedBox(height: 8),
      ],
    );
  }

  Widget get _buildLugarOferece {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'O que esse lugar oferece?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _ativoOferece.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(AppIcons.icones[_ativoOferece[index]['icone']]),
              title: Text(
                _ativoOferece[index]['topico'],
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                ),
              ),
              horizontalTitleGap: 0,
              dense: true,
            );
          },
        ),
      ],
    );
  }

  Widget get _buildRegrasLugar {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'Regras do lugar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _ativoRegras.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(AppIcons.icones[_ativoRegras[index]['icone']]),
              title: Text(
                _ativoRegras[index]['topico'],
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              horizontalTitleGap: 0,
              dense: true,
            );
          },
        ),
      ],
    );
  }

  Future<void> _loadData(String id) async {
    await Provider.of<AtivoRepository>(context, listen: false).get(id).then((ativo) => _populateAtivo(ativo));
  }

  Future<void> _loadDataOferece() async {
    await Provider.of<AtivoOfereceRepository>(context, listen: false)
        .getByAtivoId(_ativo.id!)
        .then((ativoOferece) => _populateAtivoOferece(ativoOferece));
  }

  Future<void> _loadDataRegras() async {
    await Provider.of<AtivoRegraRepository>(context, listen: false)
        .getByAtivoId(_ativo.id!)
        .then((ativoRegras) => _populateAtivoRegras(ativoRegras));
  }

  Future<void> _populateAtivo(Ativo ativo) async {
    setState(() {
      _ativo.id = ativo.id ?? '';
      _ativo.clienteId = ativo.clienteId ?? '';
      _ativo.clienteNome = ativo.clienteNome ?? '';
      _ativo.categoriaId = ativo.categoriaId ?? '';
      _ativo.categoriasNome = ativo.categoriasNome ?? '';
      _ativo.identificador = ativo.identificador ?? '';
      _ativo.nome = ativo.nome ?? '';
      _ativo.descricao = ativo.descricao ?? '';
      _ativo.valor = ativo.valor ?? 0;
      _ativo.pagamentoDiaHoraValue = ativo.pagamentoDiaHoraValue ?? '';
      _ativo.pagamentoDiaHoraNome = ativo.pagamentoDiaHoraNome ?? '';
      _ativo.limiteDiasHorasSeguidas = ativo.limiteDiasHorasSeguidas ?? 0;
      _ativo.limiteAntecedenciaLocar = ativo.limiteAntecedenciaLocar ?? 0;
      _ativo.statusId = ativo.statusId ?? '';
      _ativo.statusNome = ativo.statusNome ?? '';
      _ativo.ativoImagens = ativo.ativoImagens ?? [];
    });
  }

  Future<void> _populateAtivoOferece(List<AtivoOferece> ativoOferece) async {
    setState(() {
      _ativoOferece.addAll(ativoOferece[0].topico!.map((e) {
        return {
          'topico': e['topico'],
          'icone': e['icone'],
        };
      }));
    });
  }

  Future<void> _populateAtivoRegras(List<AtivoRegra> ativoRegras) async {
    setState(() {
      _ativoRegras.addAll(ativoRegras[0].topico!.map((e) {
        return {
          'topico': e['topico'],
          'icone': e['icone'],
        };
      }));
    });
  }
}
