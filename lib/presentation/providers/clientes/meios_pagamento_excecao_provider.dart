import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/meios_pagamento_excecao_repository.dart';

var meiosPagamentoExcecaoProvider = [
  ChangeNotifierProxyProvider<Authentication, MeiosPagamentoExcecaoRepository>(create: (_) => MeiosPagamentoExcecaoRepository(),
    update: (ctx, auth, previous) {
      return MeiosPagamentoExcecaoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
