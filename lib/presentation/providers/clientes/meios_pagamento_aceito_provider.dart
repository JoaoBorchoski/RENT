import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/meios_pagamento_aceito_repository.dart';

var meiosPagamentoAceitoProvider = [
  ChangeNotifierProxyProvider<Authentication, MeiosPagamentoAceitoRepository>(create: (_) => MeiosPagamentoAceitoRepository(),
    update: (ctx, auth, previous) {
      return MeiosPagamentoAceitoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
