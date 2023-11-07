import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/ativo_repository.dart';

var ativoProvider = [
  ChangeNotifierProxyProvider<Authentication, AtivoRepository>(create: (_) => AtivoRepository(),
    update: (ctx, auth, previous) {
      return AtivoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
