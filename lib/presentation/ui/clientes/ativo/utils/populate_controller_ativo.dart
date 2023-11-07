import 'package:locacao/domain/models/clientes/ativo.dart';

Future<void> populateController(Ativo ativo, AtivoController controllers) async {
  controllers.id!.text = ativo.id ?? '';
  controllers.clienteId!.text = ativo.clienteId ?? '';
  controllers.clienteNome!.text = ativo.clienteNome ?? '';
  controllers.categoriaId!.text = ativo.categoriaId ?? '';
  controllers.categoriasNome!.text = ativo.categoriasNome ?? '';
  controllers.identificador!.text = ativo.identificador ?? '';
  controllers.nome!.text = ativo.nome ?? '';
  controllers.descricao!.text = ativo.descricao ?? '';
  controllers.valor!.text = (ativo.valor ?? '').toString();
  controllers.limiteConvidados!.text = (ativo.limiteConvidados ?? '').toString();
  controllers.limiteConvidadosExtra!.text = (ativo.limiteConvidadosExtra ?? '').toString();
  controllers.limiteDiasHorasSeguidas!.text = (ativo.limiteDiasHorasSeguidas ?? '').toString();
  controllers.limiteAntecedenciaLocar!.text = (ativo.limiteAntecedenciaLocar ?? '').toString();
  controllers.statusId!.text = ativo.statusId ?? '';
  controllers.statusNome!.text = ativo.statusNome ?? '';
  controllers.pagamentoDiaHoraValue!.text = ativo.pagamentoDiaHoraValue ?? '';
  controllers.pagamentoDiaHoraNome!.text =
      ativo.pagamentoDiaHoraValue![0].toUpperCase() + ativo.pagamentoDiaHoraValue!.substring(1);
}
