import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/comum/meio_pagamento_repository.dart';

var meioPagamentoProvider = [
  ChangeNotifierProxyProvider<Authentication, MeioPagamentoRepository>(create: (_) => MeioPagamentoRepository(),
    update: (ctx, auth, previous) {
      return MeioPagamentoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
