import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/cliente_repository.dart';

var clienteProvider = [
  ChangeNotifierProxyProvider<Authentication, ClienteRepository>(create: (_) => ClienteRepository(),
    update: (ctx, auth, previous) {
      return ClienteRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
