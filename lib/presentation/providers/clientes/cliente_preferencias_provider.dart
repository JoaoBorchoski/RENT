import 'package:locacao/data/repositories/clientes/cliente_preferencias_repository.dart';
import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var clientePreferenciasProvider = [
  ChangeNotifierProxyProvider<Authentication, ClientePreferenciasRepository>(
    create: (_) => ClientePreferenciasRepository(),
    update: (ctx, auth, previous) {
      return ClientePreferenciasRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
