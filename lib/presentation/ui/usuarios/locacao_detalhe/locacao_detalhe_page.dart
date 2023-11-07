import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locacao/data/repositories/clientes/usuarios_locacao_repository.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/ui/usuarios/locacao_detalhe/components/convidados_modal.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../components/app_carrossel_list_widget.dart';

class LocacaoDetalhePage extends StatefulWidget {
  const LocacaoDetalhePage({Key? key}) : super(key: key);

  @override
  State<LocacaoDetalhePage> createState() => _LocacaoDetalhePageState();
}

class _LocacaoDetalhePageState extends State<LocacaoDetalhePage> {
  bool _dataIsLoaded = false;

  final _ativoUsuarioLocacao = AtivoUsuariosLocacao(
    id: '',
    locacaoId: '',
    locacoesStatus: '',
    locacaoValorTotal: '',
    locacaoValorAtivoInicial: '',
    locacaoValorTotalConvidados: '',
    locacaoValorOutrasTaxas: '',
    locacaoDataInicio: null,
    locacaoDataTermino: null,
    locacaoDataPagamento: null,
    locacaoObservacoes: '',
    meioPagamentoId: '',
    meioPagamentoNome: '',
    usuarioId: '',
    usuariosNome: '',
    ativoId: '',
    ativoNome: '',
    clienteId: '',
    clienteNome: '',
    categoriaId: '',
    categoriaNome: '',
    ativosIdentificador: '',
    ativosDescricao: '',
    ativosImagens: [],
    ativosConvidados: [],
  );

  int ativosConvidadosAssociados = 0;
  int ativosConvidadosNaoAssociados = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (!_dataIsLoaded) {
      _loadData(args['id']);
      _dataIsLoaded = true;
    }

    if (_ativoUsuarioLocacao.id == null || _ativoUsuarioLocacao.id == '') {
      return Center(
        child: LoadWidget(),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(args['isClienteView'] ? '/locacao' : '/historico-locacoes', (route) => false);

        return retorno;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_ativoUsuarioLocacao.ativoNome!),
          backgroundColor: AppColors.primary,
          leading: BackButton(color: AppColors.background),
        ),
        body: fieldsDetalhe(context),
        bottomNavigationBar: !args['isClienteView']
            ? BottomAppBar(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondDegrade,
                    ),
                    onPressed: () {
                      final data = {'ativoLocacaoId': _ativoUsuarioLocacao.id};
                      Navigator.of(context).pushReplacementNamed('/locar-ativo', arguments: data);
                    },
                    child: Text('Reservar novamente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            : null,
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
            isHistoricoPage: true,
            ativo: Ativo(
              id: _ativoUsuarioLocacao.ativoId,
              nome: _ativoUsuarioLocacao.ativoNome,
              clienteNome: _ativoUsuarioLocacao.clienteNome,
              ativoImagens: _ativoUsuarioLocacao.ativosImagens!,
            ),
            heightCard: 200,
            marginHorizontalCard: 0,
            marginVerticalCard: 0,
            borderRadius: 0,
            onTapUpFuncion: (_) {},
            locacao: _ativoUsuarioLocacao,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataHora,
                _buildPagemento,
                _buildConvidados,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildDataHora {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Data e hora da locação',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Data de início',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(DateFormat('dd/MM/yyyy').format(_ativoUsuarioLocacao.locacaoDataInicio!),
                            style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Data de término',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(DateFormat('dd/MM/yyyy').format(_ativoUsuarioLocacao.locacaoDataTermino!),
                            style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Hora de início',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(_ativoUsuarioLocacao.locacaoHoraInicio!,
                            style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        Text('Hora de término',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text(_ativoUsuarioLocacao.locacaoHoraTermino!,
                            style: TextStyle(fontSize: 16, color: AppColors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildPagemento {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Informações de pagamento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Data do pagamento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                    _ativoUsuarioLocacao.locacaoDataPagamento == ""
                        ? "Ainda não pago"
                        : DateFormat('dd/MM/yyyy').format(DateTime.parse(_ativoUsuarioLocacao.locacaoDataPagamento!)),
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hora do pagamento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                    _ativoUsuarioLocacao.locacaoHoraPagamento == ""
                        ? "Ainda não pago"
                        : _ativoUsuarioLocacao.locacaoHoraPagamento!,
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status do pagamento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                    _ativoUsuarioLocacao.locacaoDataPagamento == ""
                        ? "Ainda não pago"
                        : _ativoUsuarioLocacao.locacoesStatus!,
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meio de pagamento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(_ativoUsuarioLocacao.meioPagamentoNome!, style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor do ativo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text('R\$ ${double.parse(_ativoUsuarioLocacao.locacaoValorAtivoInicial.toString()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor convidados não sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                    'R\$ ${double.parse(_ativoUsuarioLocacao.locacaoValorTotalConvidados.toString()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Outras taxas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text('R\$ ${double.parse(_ativoUsuarioLocacao.locacaoValorOutrasTaxas.toString()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor total',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                    'R\$ ${double.parse(_ativoUsuarioLocacao.locacaoValorTotal.toString()).toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildConvidados {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          ),
          child: Text(
            'Seus convidados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total de convidados',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(_ativoUsuarioLocacao.ativosConvidados!.length.toString(),
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados não sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(_ativoUsuarioLocacao.quantidadeConvidadosNaoAssociados.toString(),
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(_ativoUsuarioLocacao.quantidadeConvidadosAssociados.toString(),
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados extras',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text((_ativoUsuarioLocacao.quantidadeConvidadosExtra ?? 0).toString(),
                    style: TextStyle(fontSize: 16, color: AppColors.black)),
              ],
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: showModalConvidados,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    color: AppColors.primary,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                "Ver todos os convidados",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  // ignore: unused_element
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

  void showModalConvidados() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConvidadosModal(
          locacaoId: _ativoUsuarioLocacao.id!,
          listConvidados: _ativoUsuarioLocacao.ativosConvidados!,
          ativoNome: _ativoUsuarioLocacao.ativoNome!,
        );
      },
    );
  }

  Future<void> _loadData(String id) async {
    await Provider.of<UsuariosLocacaoRepository>(context, listen: false)
        .get(id)
        .then((ativoUsuarioLocacao) => _populateAtivo(ativoUsuarioLocacao));
  }

  Future<void> _populateAtivo(AtivoUsuariosLocacao ativoUsuarioLocacao) async {
    setState(() {
      _ativoUsuarioLocacao.id = ativoUsuarioLocacao.id ?? '';
      _ativoUsuarioLocacao.locacaoId = ativoUsuarioLocacao.locacaoId ?? '';
      _ativoUsuarioLocacao.locacoesStatus = ativoUsuarioLocacao.locacoesStatus ?? '';
      _ativoUsuarioLocacao.locacaoValorTotal = ativoUsuarioLocacao.locacaoValorTotal ?? '0';
      _ativoUsuarioLocacao.locacaoValorTotalConvidados = ativoUsuarioLocacao.locacaoValorTotalConvidados ?? '0';
      _ativoUsuarioLocacao.locacaoValorOutrasTaxas = ativoUsuarioLocacao.locacaoValorOutrasTaxas ?? '0';
      _ativoUsuarioLocacao.locacaoValorAtivoInicial = ativoUsuarioLocacao.locacaoValorAtivoInicial ?? '0';
      _ativoUsuarioLocacao.locacaoDataInicio = ativoUsuarioLocacao.locacaoDataInicio;
      _ativoUsuarioLocacao.locacaoDataTermino = ativoUsuarioLocacao.locacaoDataTermino;
      _ativoUsuarioLocacao.locacaoDataPagamento = ativoUsuarioLocacao.locacaoDataPagamento ?? '';
      _ativoUsuarioLocacao.locacaoDataLimitePagamento = ativoUsuarioLocacao.locacaoDataLimitePagamento ?? '';
      _ativoUsuarioLocacao.locacaoHoraInicio = ativoUsuarioLocacao.locacaoHoraInicio;
      _ativoUsuarioLocacao.locacaoHoraTermino = ativoUsuarioLocacao.locacaoHoraTermino;
      _ativoUsuarioLocacao.locacaoHoraPagamento = ativoUsuarioLocacao.locacaoHoraPagamento ?? '';
      _ativoUsuarioLocacao.locacaoHoraLimitePagamento = ativoUsuarioLocacao.locacaoHoraLimitePagamento ?? '';
      _ativoUsuarioLocacao.locacaoObservacoes = ativoUsuarioLocacao.locacaoObservacoes ?? '';
      _ativoUsuarioLocacao.meioPagamentoId = ativoUsuarioLocacao.meioPagamentoId ?? '';
      _ativoUsuarioLocacao.meioPagamentoNome = ativoUsuarioLocacao.meioPagamentoNome ?? '';
      _ativoUsuarioLocacao.usuarioId = ativoUsuarioLocacao.usuarioId ?? '';
      _ativoUsuarioLocacao.usuariosNome = ativoUsuarioLocacao.usuariosNome ?? '';
      _ativoUsuarioLocacao.ativoId = ativoUsuarioLocacao.ativoId ?? '';
      _ativoUsuarioLocacao.ativoNome = ativoUsuarioLocacao.ativoNome ?? '';
      _ativoUsuarioLocacao.clienteId = ativoUsuarioLocacao.clienteId ?? '';
      _ativoUsuarioLocacao.clienteNome = ativoUsuarioLocacao.clienteNome ?? '';
      _ativoUsuarioLocacao.categoriaId = ativoUsuarioLocacao.categoriaId ?? '';
      _ativoUsuarioLocacao.categoriaNome = ativoUsuarioLocacao.categoriaNome ?? '';
      _ativoUsuarioLocacao.ativosIdentificador = ativoUsuarioLocacao.ativosIdentificador ?? '';
      _ativoUsuarioLocacao.ativosDescricao = ativoUsuarioLocacao.ativosDescricao ?? '';
      _ativoUsuarioLocacao.ativosImagens = ativoUsuarioLocacao.ativosImagens ?? [];
      _ativoUsuarioLocacao.ativosConvidados = ativoUsuarioLocacao.ativosConvidados ?? [];
      _ativoUsuarioLocacao.quantidadeConvidados = ativoUsuarioLocacao.quantidadeConvidados ?? 0;
      _ativoUsuarioLocacao.quantidadeConvidadosAssociados = ativoUsuarioLocacao.quantidadeConvidadosAssociados ?? 0;
      _ativoUsuarioLocacao.quantidadeConvidadosNaoAssociados =
          ativoUsuarioLocacao.quantidadeConvidadosNaoAssociados ?? 0;
    });
  }
}
