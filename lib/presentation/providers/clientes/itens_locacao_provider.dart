import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/itens_locacao_repository.dart';

var itensLocacaoProvider = [
  ChangeNotifierProxyProvider<Authentication, ItensLocacaoRepository>(create: (_) => ItensLocacaoRepository(),
    update: (ctx, auth, previous) {
      return ItensLocacaoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
