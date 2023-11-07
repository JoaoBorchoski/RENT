import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';

var locacoesProvider = [
  ChangeNotifierProxyProvider<Authentication, LocacoesRepository>(create: (_) => LocacoesRepository(),
    update: (ctx, auth, previous) {
      return LocacoesRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
