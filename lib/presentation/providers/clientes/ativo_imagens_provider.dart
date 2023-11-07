import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/ativo_imagens_repository.dart';

var ativoImagensProvider = [
  ChangeNotifierProxyProvider<Authentication, AtivoImagensRepository>(create: (_) => AtivoImagensRepository(),
    update: (ctx, auth, previous) {
      return AtivoImagensRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
