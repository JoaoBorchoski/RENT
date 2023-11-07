import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/categorias_repository.dart';

var categoriasProvider = [
  ChangeNotifierProxyProvider<Authentication, CategoriasRepository>(create: (_) => CategoriasRepository(),
    update: (ctx, auth, previous) {
      return CategoriasRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
