import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/convidados_repository.dart';

var convidadosProvider = [
  ChangeNotifierProxyProvider<Authentication, ConvidadosRepository>(create: (_) => ConvidadosRepository(),
    update: (ctx, auth, previous) {
      return ConvidadosRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
