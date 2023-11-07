import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locacao/data/repositories/clientes/usuarios_locacao_repository.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/ui/clientes/locacao_funcionario_detalhe/components/convidado_convidado_list.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class LocacaoFuncionarioDetalhePage extends StatefulWidget {
  const LocacaoFuncionarioDetalhePage({Key? key}) : super(key: key);

  @override
  State<LocacaoFuncionarioDetalhePage> createState() => _LocacaoFuncionarioDetalhePageState();
}

class _LocacaoFuncionarioDetalhePageState extends State<LocacaoFuncionarioDetalhePage> {
  bool _dataIsLoaded = false;

  final _ativoUsuarioLocacao = AtivoUsuariosLocacao(
    id: '',
    locacaoId: '',
    locacoesStatus: '',
    locacaoDataInicio: null,
    locacaoDataTermino: null,
    locacaoObservacoes: '',
    usuarioId: '',
    usuariosNome: '',
    usuariosCodigoSocio: '',
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
        Navigator.of(context).pushNamedAndRemoveUntil('/locacao-funcionario', (route) => false);

        return retorno;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Locação de ${_ativoUsuarioLocacao.ativoNome.toString()}'),
          backgroundColor: AppColors.primary,
          leading: BackButton(color: AppColors.background),
        ),
        body: fieldsDetalhe(context),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Row(
                    children: [
                      Card(
                        color: AppColors.success,
                        child: SizedBox(height: 15, width: 15),
                      ),
                      Text('Associado'),
                    ],
                  ),
                  Row(
                    children: [
                      Card(
                        color: AppColors.alert,
                        child: SizedBox(height: 15, width: 15),
                      ),
                      Text('Não associado'),
                    ],
                  ),
                ],
              ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoLocador,
                _buildDataHora,
                ConvidadoConvidadoList(ativoUsuarioLocacao: _ativoUsuarioLocacao),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildInfoLocador {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
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
            'Informações da locação',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Responsável Código de sócio',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.usuariosCodigoSocio.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Responsável Nome',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.usuariosNome.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nome do ativo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.ativoNome.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categoria do ativo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.categoriaNome.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total de convidados',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.ativosConvidados!.length.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados não sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.quantidadeConvidadosNaoAssociados.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Convidados sócios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                Text(
                  _ativoUsuarioLocacao.quantidadeConvidadosAssociados.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Obeservações',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                ),
                SizedBox(height: 5),
                Text(
                  _ativoUsuarioLocacao.locacaoObservacoes! == ''
                      ? 'Nenhuma observações'
                      : _ativoUsuarioLocacao.locacaoObservacoes.toString(),
                  style: TextStyle(fontSize: 16, color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  Widget get _buildDataHora {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8, top: 8),
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
      _ativoUsuarioLocacao.locacaoDataInicio = ativoUsuarioLocacao.locacaoDataInicio;
      _ativoUsuarioLocacao.locacaoDataTermino = ativoUsuarioLocacao.locacaoDataTermino;
      _ativoUsuarioLocacao.locacaoHoraInicio = ativoUsuarioLocacao.locacaoHoraInicio;
      _ativoUsuarioLocacao.locacaoHoraTermino = ativoUsuarioLocacao.locacaoHoraTermino;
      _ativoUsuarioLocacao.locacaoObservacoes = ativoUsuarioLocacao.locacaoObservacoes ?? '';
      _ativoUsuarioLocacao.usuarioId = ativoUsuarioLocacao.usuarioId ?? '';
      _ativoUsuarioLocacao.usuariosNome = ativoUsuarioLocacao.usuariosNome ?? '';
      _ativoUsuarioLocacao.usuariosCodigoSocio = ativoUsuarioLocacao.usuariosCodigoSocio ?? '';
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
      _ativoUsuarioLocacao.quantidadeConvidadosExtra = ativoUsuarioLocacao.quantidadeConvidadosExtra ?? 0;
      _ativoUsuarioLocacao.ativoLimiteConvidadosExtra = ativoUsuarioLocacao.ativoLimiteConvidadosExtra ?? 0;
      _ativoUsuarioLocacao.quantidadeConvidadosAssociados = ativoUsuarioLocacao.quantidadeConvidadosAssociados ?? 0;
      _ativoUsuarioLocacao.quantidadeConvidadosNaoAssociados =
          ativoUsuarioLocacao.quantidadeConvidadosNaoAssociados ?? 0;
    });
  }
}
