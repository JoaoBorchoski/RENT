import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/ativo_regras_repository.dart';

var ativoRegraProvider = [
  ChangeNotifierProxyProvider<Authentication, AtivoRegraRepository>(
    create: (_) => AtivoRegraRepository(),
    update: (ctx, auth, previous) {
      return AtivoRegraRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
