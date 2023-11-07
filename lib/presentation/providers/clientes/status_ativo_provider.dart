import 'package:locacao/data/repositories/clientes/status_ativo_repository.dart';
import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var statusAtivoProvider = [
  ChangeNotifierProxyProvider<Authentication, StatusAtivoRepository>(
    create: (_) => StatusAtivoRepository(),
    update: (ctx, auth, previous) {
      return StatusAtivoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
